rm(list=ls())


library(RecordLinkage)
options(width=100)
load("/media/chen/4TB1/PatientMatching/meta9/RL_myPairs_jarowinkler_V9.RData")

load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])

#allPairs$pairs = allPairs$pairs[c(pos_idx, neg_idx),]

allPairs$pairs$MRN = abs(allPairs$data$MRN[allPairs$pairs$id1] - allPairs$data$MRN[allPairs$pairs$id2])
allPairs$pairs$MRN = 1 - (allPairs$pairs$MRN / 4963312)
allPairs$pairs$PHONE = (PHONE_MAP[allPairs$pairs$id1,2] == PHONE_MAP[allPairs$pairs$id2,2]) * 1



VotingOutDIR = "/media/chen/4TB1/PatientMatching/meta10/"
dir.create(VotingOutDIR)
RandTotal = 200
FNList <- vector("list", length = RandTotal)
FPList <- vector("list", length = RandTotal)

train_pairs = allPairs
eval_pairs = allPairs

allFN = NULL
allFP = NULL
for(i in 1:RandTotal) {
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

print(table(allFN))
print(table(allFP))


    FNList[[i]]=FN
    FPList[[i]]=FP
    save(FN, FP, model, file=paste(VotingOutDIR, "trainSupv_bagging_jarowinkler_randomSeed",i,".RData",sep=""))
    print(table(result$pairs$is_match, result$prediction))
}

save(FNList, FPList, allFN, allFP, file=paste(VotingOutDIR, "trainSupv_bagging_jarowinkler_Summary.RData",sep=""))
print(table(allFN))
print(table(allFP))


