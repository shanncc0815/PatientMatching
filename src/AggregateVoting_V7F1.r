rm(list=ls())

library(RecordLinkage)

RDataDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/"
#VotingInDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/Voting_v2/"
VotingOutDIR = "/media/chen/4TB/PatientMatching/meta8/Voting_v7/"
META = c("PHONE_jarowinkler","EMAIL_PHONE_jarowinkler")
meta_flag = 1

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
  save(data, PairList, file=paste(RDataDIR, "PairList.RData",sep=""))
}

load(paste(RDataDIR, "PairList.RData",sep=""))

predictionList <- vector("list", length = length(blocklist))

RandTotal = 100
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
    predictionFile = paste(VotingOutDIR, "/classifySupv_RL_Block_blockID_", blockID, "_randomSeed",i,".RData", sep="")
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

Vote = NULL
for(i in 1:RandTotal) {
  if(i == 1) {
    Vote = (VotingPredict[[i]] == "L") * 1
  } else {
    Vote = Vote + (VotingPredict[[i]] == "L") * 1
  }
}

print(table(Vote))
submit = strsplit(unionPair[which(Vote == 100)], split="_")
Out = paste(data$EnterpriseID[as.numeric(sapply(submit,function(X) X[1]))], data$EnterpriseID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = "submit004_Vote100_V7F1.csv", append = FALSE, sep = " ")

submit = strsplit(unionPair[which(Vote > 0)], split="_")
Out = paste(data$EnterpriseID[as.numeric(sapply(submit,function(X) X[1]))], data$EnterpriseID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = paste("submit005_Vote100g0_V7F1_",length(Out),".csv", sep=""), append = FALSE, sep = " ")

save.image(file=paste(VotingOutDIR, "AggregateVoting_V7F1.RData",sep=""))



#       0        1        2        3 
#14492802      571      560    52653 


###########
 
if(FALSE) {
  unionPair = NULL
  unionPred = NULL
  for(b_idx in 1:length(blocklist)) {
    if(b_idx == 1) {
      unionPair = PairList[[b_idx]]
      unionPred = predictionList[[b_idx]]
    } else {
      tmp = intersect(unionPair, PairList[[b_idx]])
      idx1 = match(tmp, unionPair)
      idx2 = match(tmp, PairList[[b_idx]])
      if(sum(unionPair[idx1] != predictionList[[b_idx]][idx2])) {
        unionPair = union(unionPair, PairList[[b_idx]])
        unionPred = union(unionPred, predictionList[[b_idx]][idx2])        
      } else {
        print(paste("Problematic Matching...randseed=",i,",b_idx=",b_idx,sep=""))        
      }
    }
  }
  VotingPair[[i]] = unionPair
  VotingPredict[[i]] = unionPred
}

if(FALSE) {
  unionPairPred = NULL
  for(b_idx in 1:length(blocklist)) {
    unionPairPred = union(unionPairPred,paste(PairList[[b_idx]],predictionList[[b_idx]],sep=","))
  }

  VotingPair = sapply(strsplit(unionPairPred, split=","),function(X) X[1])
  VotingPredict[[i]] = sapply(strsplit(unionPairPred, split=","),function(X) X[1])
  checkRep = table(VotingPair)
  if(which(checkRep>1) > 0) {
    print(paste("Problematic Matching...randseed=",i,",b_idx=",b_idx,sep=""))
  }


}


