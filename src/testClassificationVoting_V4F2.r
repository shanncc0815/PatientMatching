rm(list=ls())

library(RecordLinkage)
RDataDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/"
VotingInDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/Voting_v2/"
VotingOutDIR = "/media/chen/4TB/PatientMatching/meta8/Voting_v4/"
#dir.create(VotingOutDIR)
META = c("PHONE_jarowinkler","EMAIL_PHONE_jarowinkler")

meta_flag = 2

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

load("/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/RL_FIELDS.RData")
FIELDS = FIELDS[-17]
FIELDS[c(19,20,21,22)]=c("MIDINIT","M","D","Y")

RandTotal=20
BATCHSIZE = 1000000
for(i in 4:RandTotal) {
    set.seed(i)
    print("##################")

    trainFile = paste(VotingInDIR, "trainSupv_bagging_",META[meta_flag],"_randomSeed",i,".RData",sep="")
    load(trainFile)
    print(paste(format(Sys.time(), "%H:%M:%S  Training with model "), trainFile, sep=""))

    for(b_idx in 1:length(blocklist)) {
      blockID = paste( c(blocklist[[b_idx]], FIELDS[blocklist[[b_idx]]]) , collapse="_")
      testFile = paste(RDataDIR,"/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep="")
      testFilePostFix = paste("Rand:",i," Block:",b_idx," RL_Block_blockID_", blockID, "_jarowinkler.RData", sep="")
      load(testFile)

      batches = ceiling(dim(thisPair$pairs)[1]/BATCHSIZE)

#      result = classifySupv(model, newdata = thisPair)
      print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), testFilePostFix, " with ", dim(thisPair$pairs)[1], " pairs", sep=""))
      tmpPair = thisPair
      prediction = NULL
      for(batch_idx in 1:batches) {
        if(batch_idx != batches) {
          print(paste(format(Sys.time(), "%H:%M:%S  Testing with "),"Batch ", batch_idx, "/", batches, sep=""))
          tmpPair$pairs = thisPair$pairs[(1+(batch_idx-1)*BATCHSIZE):(batch_idx*BATCHSIZE),]
        } else {
          tmpPair$pairs = thisPair$pairs[(1+(batch_idx-1)*BATCHSIZE):dim(thisPair$pairs)[1],]
        }
        result = classifySupv(model, newdata = tmpPair)
        prediction = c(prediction, result$prediction)
      }
      print(table(prediction))
      save(prediction, file=paste(VotingOutDIR, "/classifySupv_RL_Block_blockID_", blockID, "_randomSeed",i,"_F",meta_flag,".RData", sep="")) 
      rm(thisPair, tmpPair)
    }
    rm(model)
}

source("src/AggregateVoting_V4F2.r")

