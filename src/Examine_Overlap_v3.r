rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

library(RecordLinkage)
options(width=100)
load("/media/chen/4TB1/PatientMatching/meta9/RL_myPairs_jarowinkler_V9.RData")

input_df = input_df[,-c(20,21)]

input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22



#Match = allPairs$pairs[which(allPairs$pairs$is_match == 1),]
#Out = paste(allPairs$data$EnterpriseID[Match$id1], allPairs$data$EnterpriseID[Match$id2],1, sep=",")
#write.table(Out,file=paste("pmc3_submit040_52460TP.csv",sep=""),row.names=FALSE,col.names=F,append=F,quote=F,sep=",")

#tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit039_381824.csv","/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit040_52460TP.csv","pmc3_unsubmit_diff39_40_329362FP_2TP.csv")


tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit047_All_Pos_52462TP.csv","/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit040_52460TP.csv","tmp.csv")
# cat tmp.csv tmp.csvcommon.csv submit_sampc003/pmc3_submit046_329362FP_2TP_attemp3.csv > submit_sampc003/pmc3_submit048_All_Pos_52462TP.csv

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit047_All_Pos_52462TP.csv","/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit039_381824.csv","tmp.csv")


tmp2 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit039_381824.csv","/home/chen/workspace/PatientMatching/submit_sampc003/pmc3_submit047_All_Pos_52462TP.csv","tmp2.csv")


############### Examine using clustering, can write a function

check_df = read.csv("pmc3_unsubmit_diff39_40_329362FP_2TP.csv", header=F)
checkID_idx = paste(check_df$V1, check_df$V2, sep="_")
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
s_idx="this"
if( length(intersect(checkID_idx_swap, pairID_idx1) == dim(check_df)[1])) {
    print(paste("[",s_idx,"]All ",dim(check_df)[1]," pairs can be covered:", sep=""))
} else {
    print(paste("[CHECK ",s_idx,"]",length(intersect(checkID_idx_swap, pairID_idx1),"/",dim(check_df)[1]," pairs are covered:", sep="")))
}


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
Out = head(getPairs(pairs_eW, 1, 0), n=1000000000)
OutName = paste("Examine_EpiClustering_jarowinkler_diff39_40_329362FP_2TP.csv",sep="")
write.table(Out, file = OutName, sep=",")
#save(checkPair, file=paste(OutName, ".RData", sep=""))


