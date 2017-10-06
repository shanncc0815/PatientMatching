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

SubmitDIR = "/home/chen/workspace/PatientMatching/tmp_submit"
SubmitCsvA = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000A.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000A.csv")

SubmitCsvB = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000B.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000B.csv")

SubmitCsv = c("pmc3_submit036_2961_184FP.csv","pmc1_submit012_Vote1000_noVote_V7F1_Batch1.csv","pmc1_submit013_Vote1000_noVote_V7F1_Batch2.csv", SubmitCsvA, SubmitCsvB, "pmc2_submit044_Checksubmit014_MoreBlocking_0816_Batch14.csv")

print("#####################")
print("Examine sets with at least one vote out of 200 votes")
Diff_Vote200g = diffPair("submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv","submit_sampc004/pmc4_submit031_54672TP_0FP.csv","tmp/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv")






for(s_idx in 1:length(SubmitCsv)) {

print(paste("[",s_idx,"/",length(SubmitCsv),"] Dedup ", SubmitCsv[s_idx], sep=""))

check_df = read.csv(paste(SubmitDIR,'/',SubmitCsv[s_idx],sep=""),header=F)
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


thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)

dim(thisPair$pairs)
#[1] 26306    24

pairID_idx1 = paste(sub_df[thisPair$pairs$id1,1], sub_df[thisPair$pairs$id2,1], sep="_")
pairID_idx2 = paste(sub_df[thisPair$pairs$id2,1], sub_df[thisPair$pairs$id1,1], sep="_")
length(intersect(checkID_idx, pairID_idx1))
#[1] 2960
length(intersect(checkID_idx, pairID_idx2))
#[1] 1

miss_idx = which(is.na(match(checkID_idx, intersect(checkID_idx, pairID_idx1))))
#[1] 2945
#> which(checkID_idx == intersect(checkID_idx, pairID_idx2))
#[1] 2945
checkID_idx[miss_idx]
#[1] "15419663_15849291"

checkID_idx_swap = checkID_idx
checkID_idx_swap[miss_idx] =  sapply(strsplit( checkID_idx[miss_idx], split="_"), function(X) paste(X[2],X[1],sep="_"))
if( length(intersect(checkID_idx_swap, pairID_idx1) == dim(check_df)[1])) {
    print(paste("[",s_idx,"]All ",dim(check_df)[1]," pairs can be covered:", SubmitCsv[s_idx], sep=""))
} else {
    print(paste("[CHECK ",s_idx,"]",length(intersect(checkID_idx_swap, pairID_idx1),"/",dim(check_df)[1]," pairs are covered:", SubmitCsv[s_idx], sep="")))
}


match_idx = match(checkID_idx_swap, pairID_idx1)
checkPair = thisPair
checkPair$pairs = thisPair$pairs[match_idx,]

rm(thisPair)

# Do normalization on MRN and PHONE
checkPair$pairs$MRN = abs(checkPair$data$MRN[checkPair$pairs$id1] - checkPair$data$MRN[checkPair$pairs$id2])
checkPair$pairs$MRN = 1 - (checkPair$pairs$MRN / 4963312)
checkPair$pairs$PHONE = (PHONE_MAP[checkPair$pairs$id1,2] == PHONE_MAP[checkPair$pairs$id2,2]) * 1

pairs_eW <- epiWeights(checkPair)
summary(pairs_eW)

# tail(getPairs(pairs_eW, 0.2, 0))
Out = head(getPairs(pairs_eW, 1, 0), n=10000000000)
OutName = paste("tmp_submit/Examine_EpiClustering_jarowinkler_",SubmitCsv[s_idx],sep="")
write.table(Out, file = OutName, sep=",")
save(checkPair, file=paste(OutName, ".RData", sep=""))

rm(pairs_eW, checkPair, Out, sub_df)
gc()

}

