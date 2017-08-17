rm(list=ls())

library(RecordLinkage)
set.seed(12345)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_PHONE_jarowinkler.RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

set.seed(12345)

train_pairs = allPairs
eval_pairs = allPairs

CMethod = c("bagging")
for(c_idx in 1:length(CMethod)) {
  print("##################\n")
  print(paste(format(Sys.time(), "%H:%M:%S  Training with "), CMethod[c_idx], sep=""))
  model  = trainSupv(train_pairs, method=CMethod[c_idx])
  print(format(Sys.time(), "%H:%M:%S  Done with training"))

  print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), CMethod[c_idx], sep=""))
  result = classifySupv(model, newdata = eval_pairs)
  print(format(Sys.time(), "%H:%M:%S  Done with testing"))

  summary(result)
}

FN = intersect(which(result$prediction == "N"),which( result$pairs$is_match == 1))
FP = intersect(which(result$prediction == "L"),which( result$pairs$is_match == 0))
print(FN)
print(FP)
#> print(FN)
#[1] 185250 185771 186216 186222 186239
#> print(FP)
#[1] 232783

#> print(FN)
#[1] 185250 185389 186216 186228
#> print(FP)
#[1] 232818


################################

rm(list=ls())

library(RecordLinkage)
data(RLdata500)

set.seed(12345)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"

load(paste(OutDIR,"/RL_myPairs_PHONE_levenshteinSim.RData",sep=""))
#load(paste(OutDIR,"/RL_myPairs_PHONE_jarowinkler.RData",sep=""))
#load(paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_levenshteinSim.RData",sep=""))
#load(paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_jarowinkler.RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

train_pairs = allPairs
eval_pairs = allPairs

CMethod = c("bagging")
for(c_idx in 1:length(CMethod)) {
  print("##################\n")
  print(paste(format(Sys.time(), "%H:%M:%S  Training with "), CMethod[c_idx], sep=""))
  model  = trainSupv(train_pairs, method=CMethod[c_idx])
  print(format(Sys.time(), "%H:%M:%S  Done with training"))

  print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), CMethod[c_idx], sep=""))
  result = classifySupv(model, newdata = eval_pairs)
  print(format(Sys.time(), "%H:%M:%S  Done with testing"))

  summary(result)
}


