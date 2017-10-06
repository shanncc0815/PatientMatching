rm(list=ls())

library(RecordLinkage)
RDataDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData/"
VotingOutDIR = "/media/chen/4TB/PatientMatching/meta8/Voting_v5/"
dir.create(VotingOutDIR)
#META = c("PHONE_levenshteinSim","PHONE_jarowinkler","EMAIL_PHONE_levenshteinSim","EMAIL_PHONE_jarowinkler")
META = c("PHONE_jarowinkler","EMAIL_PHONE_jarowinkler")

meta_flag = 1

load(paste(RDataDIR,"RL_myPairs_",META[meta_flag],".RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

RandTotal = 1000
FNList <- vector("list", length = RandTotal)
FPList <- vector("list", length = RandTotal)

train_pairs = allPairs
eval_pairs = allPairs

allFN = NULL
allFP = NULL
for(i in 1:RandTotal) {
    set.seed(i)
    print("##################")
    print(paste(format(Sys.time(), "%H:%M:%S  Training with "), "bagging, seed=", i, " ", META[meta_flag], sep=""))
    model  = trainSupv(train_pairs, method="bagging")
    print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), "bagging, seed=", i, " ", META[meta_flag], sep=""))
    result = classifySupv(model, newdata = eval_pairs)
    FN = intersect(which(result$prediction == "N"),which( result$pairs$is_match == 1))
    FP = intersect(which(result$prediction == "L"),which( result$pairs$is_match == 0))
    allFN = c(allFN, FN)
    allFP = c(allFP, FP)
    FNList[[i]]=FN
    FPList[[i]]=FP
    save(FN, FP, model, file=paste(VotingOutDIR, "trainSupv_bagging_",META[meta_flag],"_randomSeed",i,".RData",sep=""))    
    print(table(result$pairs$is_match, result$prediction))
}

save(FNList, FPList, allFN, allFP, file=paste(VotingOutDIR, "trainSupv_bagging_",META[meta_flag],"_Summary.RData",sep=""))
print(table(allFN))
print(table(allFP))

#i=1; result$data[c(result$pairs$id1[FP[i]],result$pairs$id2[FP[i]]),]
#i=1; result$data[c(result$pairs$id1[FN[i]],result$pairs$id2[FN[i]]),]


