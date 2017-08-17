rm(list=ls())

library(RecordLinkage)
data(RLdata500)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_PHONE_jarowinkler.RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

train_pairs = allPairs
eval_pairs = allPairs

CMethod = c("svm","rpart","ada","bagging","bumping")
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

################################

rm(list=ls())

library(RecordLinkage)
data(RLdata500)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_PHONE_levenshteinSim.RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

train_pairs = allPairs
eval_pairs = allPairs

CMethod = c("svm","rpart","ada","bagging","bumping")
CMethod = c("ada","bagging")
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

################################

rm(list=ls())

library(RecordLinkage)
data(RLdata500)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_PHONE_0802_2017.RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

train_pairs = allPairs
eval_pairs = allPairs

CMethod = c("svm","rpart","ada","bagging","bumping")
CMethod = c("ada","bagging")
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



################################
###--------------------------###
################################
rm(list=ls())

library(RecordLinkage)
data(RLdata500)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_jarowinkler.RData",sep=""))

#> dim(allPairs$pairs)
#[1] 232971     24
#> sum(allPairs$pairs$is_match)
#[1] 40424

train_pairs = allPairs
eval_pairs = allPairs

CMethod = c("svm","rpart","ada","bagging","bumping")
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

################################

rm(list=ls())

library(RecordLinkage)
data(RLdata500)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_levenshteinSim.RData",sep=""))

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

################################


rm(list=ls())

library(RecordLinkage)
data(RLdata500)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_0802_2017.RData",sep=""))

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


