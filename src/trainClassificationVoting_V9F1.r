rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

load("/media/chen/4TB1/PatientMatching/meta9/RL_Identity_Simplified_v3_WholeImage.RData")
sub_df$PHONE2 = NULL
sub_df$MIDINIT = substr(sub_df$MIDDLE,1,1)  # FIELD 19
sub_df$M = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
sub_df$D = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
sub_df$Y = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

rbind(1:dim(sub_df)[2],colnames(sub_df))
format(Sys.time(), "%H-%M-%S")

#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"    "18"    "19"      "20"  "21"  "22"
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "EMAIL" "ALIAS" "MIDINIT" "M"   "D"   "Y"

# 2: LAST
# 3: FIRST
# 6: DOB => 20, 21,22
# 8: SSN
# 9: ADDRESS1
# 16: PHONE => Can be mapped later
# 19: MIDINIT => Not a good feature...

# try a PHONE mapping tonight~~~
# can use EMAIL to exclude

# first, do with Identity submatrix, without exclude, add DOB only (can filter later), add SSN only (can filter later)
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8))

allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=jarowinkler)
sum(allPairs$pairs$is_match)
#[1] 52460
# => submit 52462... Missing two
dim(AllPos)
#[1] 52452     4

AllPos$idx = paste(AllPos$V1, AllPos$V2, sep="_")
AllNeg$idx = paste(AllNeg$V1, AllNeg$V2, sep="_")
#> dim(AllNeg)
#[1] 1600    4


b = allPairs$pairs[which(allPairs$pairs$is_match == 1),]
b$idx1 = paste(allPairs$data$EnterpriseID[b$id1], allPairs$data$EnterpriseID[b$id2], sep="_")
b$idx2 = paste(allPairs$data$EnterpriseID[b$id2], allPairs$data$EnterpriseID[b$id1], sep="_")
length(intersect(AllPos$idx, b$idx1))
#[1] 51952
length(intersect(AllPos$idx, b$idx2))
#[1] 498
length(intersect(AllPos$idx, b$idx1)) + length(intersect(AllPos$idx, b$idx2))
#[1] 52450

b = allPairs$pairs
b$idx1 = paste(allPairs$data$EnterpriseID[b$id1], allPairs$data$EnterpriseID[b$id2], sep="_")
b$idx2 = paste(allPairs$data$EnterpriseID[b$id2], allPairs$data$EnterpriseID[b$id1], sep="_")
common1 = intersect(AllPos$idx, b$idx1)
common2 = intersect(AllPos$idx, b$idx2)
pos_idx = c(match(common1, b$idx1), match(common2, b$idx2))



a = allPairs$pairs[which(allPairs$pairs$is_match == 0),]
a$idx1 = paste(allPairs$data$EnterpriseID[a$id1], allPairs$data$EnterpriseID[a$id2], sep="_")
a$idx2 = paste(allPairs$data$EnterpriseID[a$id2], allPairs$data$EnterpriseID[a$id1], sep="_")
length(intersect(AllNeg$idx, a$idx1))
#[1] 835
length(intersect(AllNeg$idx, a$idx2))
#[1] 88
length(intersect(AllNeg$idx, a$idx1)) + length(intersect(AllNeg$idx, a$idx2))
#[1] 923

a = allPairs$pairs
a$idx1 = paste(allPairs$data$EnterpriseID[a$id1], allPairs$data$EnterpriseID[a$id2], sep="_")
a$idx2 = paste(allPairs$data$EnterpriseID[a$id2], allPairs$data$EnterpriseID[a$id1], sep="_")
common1 = intersect(AllNeg$idx, a$idx1)
common2 = intersect(AllNeg$idx, a$idx2)
neg_idx = c(match(common1, a$idx1), match(common2, a$idx2))

Out = paste(allPairs$data$EnterpriseID[allPairs$pairs$id1], allPairs$data$EnterpriseID[allPairs$pairs$id2],1, sep=",")
write.table(Out,file=paste("pmc3_submit039_381824.csv",sep=""),row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
# chen@GPU:~/workspace/git_examples/PatientMatching$ wc ../../PatientMatching/submit_sampc003/pmc3_submit039.csv 
# 381824  381824 7636480 ../../PatientMatching/submit_sampc003/pmc3_submit039.csv
#submit 381824   52462 TP (Missing two), 329362 FP

save.image(file="/media/chen/4TB1/PatientMatching/meta9/RL_myPairs_jarowinkler_V9.RData")





library(RecordLinkage)
options(width=100)
load("/media/chen/4TB1/PatientMatching/meta9/RL_myPairs_jarowinkler_V9.RData")

load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])

allPairs$pairs = allPairs$pairs[c(pos_idx, neg_idx),]

allPairs$pairs$MRN = abs(allPairs$data$MRN[allPairs$pairs$id1] - allPairs$data$MRN[allPairs$pairs$id2])
allPairs$pairs$MRN = 1 - (allPairs$pairs$MRN / 4963312)
allPairs$pairs$PHONE = (PHONE_MAP[allPairs$pairs$id1,2] == PHONE_MAP[allPairs$pairs$id2,2]) * 1



VotingOutDIR = "/media/chen/4TB1/PatientMatching/meta9/"
RandTotal = 100
FNList <- vector("list", length = RandTotal)
FPList <- vector("list", length = RandTotal)

train_pairs = allPairs
eval_pairs = allPairs

allFN = NULL
allFP = NULL
for(i in 94:RandTotal) {
    set.seed(i)
    print("##################")
    print(paste(format(Sys.time(), "%H:%M:%S  Training with "), "bagging, seed=", i, sep=""))
    model  = trainSupv(train_pairs, method="bagging")
    print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), "bagging, seed=", i, sep=""))
    result = classifySupv(model, newdata = eval_pairs)
    FN = intersect(which(result$prediction == "N"),which( result$pairs$is_match == 1))
    FP = intersect(which(result$prediction == "L"),which( result$pairs$is_match == 0))
    allFN = c(allFN, FN)
    allFP = c(allFP, FP)
    FNList[[i]]=FN
    FPList[[i]]=FP
    save(FN, FP, model, file=paste(VotingOutDIR, "trainSupv_bagging_jarowinkler_randomSeed",i,".RData",sep=""))
    print(table(result$pairs$is_match, result$prediction))
}

#save(FNList, FPList, allFN, allFP, file=paste(VotingOutDIR, "trainSupv_bagging_jarowinkler_Summary.RData",sep=""))
#print(table(allFN))
#print(table(allFP))


