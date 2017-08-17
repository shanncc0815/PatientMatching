rm(list=ls())

library(RecordLinkage)
RDataDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/"
VotingOutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/Voting_v2/"
dir.create(VotingOutDIR)
#META = c("PHONE_levenshteinSim","PHONE_jarowinkler","EMAIL_PHONE_levenshteinSim","EMAIL_PHONE_jarowinkler")
META = c("PHONE_jarowinkler","EMAIL_PHONE_jarowinkler")

meta_flag = 2

load(paste(RDataDIR,"RL_myPairs_",META[meta_flag],".RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

RandTotal = 100
FNList <- vector("list", length = RandTotal)
FPList <- vector("list", length = RandTotal)

train_pairs = allPairs
eval_pairs = allPairs

set.seed(3)
pairs_eW <- epiWeights(allPairs)
summary(pairs_eW)
    
l=splitData(dataset=pairs_eW, prop=0.5, keep.mprop=TRUE)
threshold=optimalThreshold(l$train)
threshold
summary(epiClassify(l$valid,threshold))


# EM takes much longer time to converge...
set.seed(1)
pairs_emW <- emWeights(allPairs)
summary(pairs_emW)

l=splitData(dataset=pairs_emW, prop=0.5, keep.mprop=TRUE)
threshold=optimalThreshold(l$train)
threshold
summary(emClassify(l$valid,threshold))







allFN = NULL
allFP = NULL
for(i in 1:RandTotal) {
    set.seed(i)


rpairs3 <- compare.dedup(RLdata500, identity = identity.RLdata500, blockfld = c(5,6), strcmp=TRUE, strcmpfun=jarowinkler)
rpairs3_eW <- epiWeights(rpairs3)
summary(rpairs3_eW)

#[0.2,0.3] (0.3,0.4] (0.4,0.5] (0.5,0.6] (0.6,0.7] (0.7,0.8] (0.8,0.9]   (0.9,1] 
#        3        29        41        37         9        35         1         2 


l=splitData(dataset=rpairs3_eW, prop=0.5, keep.mprop=TRUE)
threshold=optimalThreshold(l$train)
threshold
summary(epiClassify(l$valid,threshold))




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

