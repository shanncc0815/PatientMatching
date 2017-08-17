rm(list=ls())

library(RecordLinkage)

RDataDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/"
#VotingInDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/Voting_v2/"
VotingOutDIR = "/media/chen/4TB/PatientMatching/meta8/Voting_v4/"
META = c("PHONE_jarowinkler","EMAIL_PHONE_jarowinkler")
meta_flag = 2

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

load("/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/RL_FIELDS.RData")
FIELDS = FIELDS[-17]
FIELDS[c(19,20,21,22)]=c("MIDINIT","M","D","Y")

if(FALSE) {
  PairList <- vector("list", length = length(blocklist))
  for(b_idx in 1:length(blocklist)) {
    blockID = paste( c(blocklist[[b_idx]], FIELDS[blocklist[[b_idx]]]) , collapse="_")
    testFile = paste(RDataDIR,"/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep="")
    print(paste(format(Sys.time(), "%H:%M:%S  Load Test File "), testFile, sep=""))
    load(testFile)  # thisPair$pairs
    PairList[[b_idx]] = paste(thisPair$pairs$id1,thisPair$pairs$id2,sep="_")
  }
  data = thisPair$data
  save(data, PairList, file=paste(RDataDIR, "PHONE_PairList.RData",sep=""))
}

load(paste(RDataDIR, "PHONE_PairList.RData",sep=""))

predictionList <- vector("list", length = length(blocklist))

RandTotal = 20
#VotingPair    <- vector("list", length = length(RandTotal))
VotingPredict <- vector("list", length = length(RandTotal))
for(i in 1:RandTotal) {
  set.seed(i)
#    trainFile = paste(VotingInDIR, "trainSupv_bagging_",META[meta_flag],"_randomSeed",i,".RData",sep="")
#    load(trainFile)
#    print(paste(format(Sys.time(), "%H:%M:%S  Training with model "), trainFile, sep=""))

  print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction results with randseed "), i, sep=""))
  for(b_idx in 1:length(blocklist)) {
    blockID = paste( c(blocklist[[b_idx]], FIELDS[blocklist[[b_idx]]]) , collapse="_")
    predictionFile = paste(VotingOutDIR, "/classifySupv_RL_Block_blockID_", blockID, "_randomSeed",i,"_F",meta_flag,".RData", sep="")
#    print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction result "), predictionFile, sep=""))
    load(predictionFile)
    predictionList[[b_idx]] = as.character(prediction)
  }

  unionPair = NULL
  unionPred = NULL
  for(b_idx in 1:length(blocklist)) {
    if(b_idx == 1) {
      unionPair = PairList[[b_idx]]
      unionPred = predictionList[[b_idx]]
    } else {
      common = intersect(unionPair, PairList[[b_idx]])
      idx1 = match(common, unionPair)
      idx2 = match(common, PairList[[b_idx]])
      if(sum(unionPair[idx1] != predictionList[[b_idx]][idx2])) {
        idx3 = which(is.na(match(PairList[[b_idx]], common)))
        unionPair = c(unionPair, PairList[[b_idx]][idx3])
        unionPred = c(unionPred, predictionList[[b_idx]][idx3])
      } else {
        print(paste("Problematic Matching...randseed=",i,",b_idx=",b_idx,sep=""))
      }
    }
  }
  VotingPredict[[i]] = unionPred
}

# "3" == "L" for some reason...
Vote = NULL
for(i in 1:RandTotal) {
  if(i == 1) {
    Vote = (VotingPredict[[i]] == "3") * 1
  } else {
    Vote = Vote + (VotingPredict[[i]] == "3") * 1
  }
}

if(TRUE) {
  submit = strsplit(unionPair[which(Vote > 0)], split="_")
  Out = paste(data$EnterpriseID[as.numeric(sapply(submit,function(X) X[1]))], data$EnterpriseID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
  write(Out, file = paste("submit008_Vote20g20_V4F2_",length(Out),".csv", sep=""), append = FALSE, sep = " ")
}

if(FALSE) {

print(table(Vote))

submit = strsplit(unionPair[which(Vote == 20)], split="_")
Out = paste(data$EnterpriseID[as.numeric(sapply(submit,function(X) X[1]))], data$EnterpriseID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = paste("submit008_Vote20g0_V4F2_",length(Out),".csv", sep=""), append = FALSE, sep = " ")

submit = strsplit(unionPair[which(Vote > 0)], split="_")
Out = paste(data$EnterpriseID[as.numeric(sapply(submit,function(X) X[1]))], data$EnterpriseID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = paste("submit009_Vote20g0_V4F2_",length(Out),".csv", sep=""), append = FALSE, sep = " ")

rm(submit, Out)
gc()
}

save.image(file=paste(VotingOutDIR, "AggregateVoting_V4F2.RData",sep=""))



#       0        1        2        3 
#14492802      571      560    52653 

