rm(list=ls())

library(RecordLinkage)
options(width=100)

source("src/Pair_Utility.r")

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
input_df = input_df[,-c(20,21)]

input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

check_df = read.csv('/home/chen/workspace/PatientMatching/submit_sampc002/submit021_diff_52592_40593_12025.csv',header=F)
checkID_idx = paste(check_df$V1, check_df$V2, sep="_")
#> dim(check_df)
#[1] 12025     3

checkID = unique(c(as.character(check_df$V1),as.character(check_df$V2)))
#> length(checkID)
#[1] 24032


sub_df = input_df[match(checkID, input_df$EnterpriseID),]
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8))

load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])


DistFun = c("jarowinkler","levenshteinSim","levenshteinDist")

for(f_idx in 3:3) {
#thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)

if(f_idx==1) {thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)}
if(f_idx==2) {thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=levenshteinSim)}
if(f_idx==3) {thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=levenshteinDist)}

dim(thisPair$pairs)
#[1] 26306    24

pairID_idx1 = paste(sub_df[thisPair$pairs$id1,1], sub_df[thisPair$pairs$id2,1], sep="_")
pairID_idx2 = paste(sub_df[thisPair$pairs$id2,1], sub_df[thisPair$pairs$id1,1], sep="_")
length(intersect(checkID_idx, pairID_idx1))
#[1] 12024
length(intersect(checkID_idx, pairID_idx2))
#[1] 1

#> which(is.na(match(checkID_idx, intersect(checkID_idx, pairID_idx1))))
#[1] 5327
#> which(checkID_idx == intersect(checkID_idx, pairID_idx2))
#[1] 5327
#> checkID_idx[5327]
#[1] "15526743_15527976"

checkID_idx_swap = checkID_idx
checkID_idx_swap[5327] = "15527976_15526743"
length(intersect(checkID_idx_swap, pairID_idx1))
match_idx = match(checkID_idx_swap, pairID_idx1)

checkPair = thisPair
checkPair$pairs = thisPair$pairs[match_idx,]

# Do normalization on MRN and PHONE
checkPair$pairs$MRN = abs(checkPair$data$MRN[checkPair$pairs$id1] - checkPair$data$MRN[checkPair$pairs$id2])
checkPair$pairs$MRN = 1 - (checkPair$pairs$MRN / 4963312)
checkPair$pairs$PHONE = (PHONE_MAP[checkPair$pairs$id1,2] == PHONE_MAP[checkPair$pairs$id2,2]) * 1

pairs_eW <- epiWeights(checkPair)
summary(pairs_eW)

# tail(getPairs(pairs_eW, 0.2, 0))
Out = head(getPairs(pairs_eW, 1, 0), n=10000000000)
write.table(Out, file = paste("tmp_submit/Examine_epiWeight_submit021_diff_52592_40593_12025_",DistFun[f_idx],".csv",sep=""), sep="\t")

}

#pairs_eM <- emWeights(checkPair)
#summary(pairs_eM)

# tail(getPairs(pairs_eW, 0.2, 0))
#Out2 = head(getPairs(pairs_eM, 1, 0), n=10000000000)
#write(Out2, file = paste("tmp_submit/Examine_eM_submit021_diff_52592_40593_12025.csv")


