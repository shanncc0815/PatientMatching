rm(list=ls())

library(RecordLinkage)
RDataDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData/"
VotingInDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/Voting_v2/"
VotingOutDIR = "/media/chen/4TB/PatientMatching/meta8/Voting_v3/"
#dir.create(VotingOutDIR)
#META = c("PHONE_levenshteinSim","PHONE_jarowinkler","EMAIL_PHONE_levenshteinSim","EMAIL_PHONE_jarowinkler")
META = c("PHONE_jarowinkler","EMAIL_PHONE_jarowinkler")

meta_flag = 1
RandTotal = 100

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))


for(i in 1:RandTotal) {
    set.seed(i)
    print("##################")

    trainFile = paste(VotingInDIR, "trainSupv_bagging_",META[meta_flag],"_randomSeed",i,".RData",sep="")
    load(trainFile)
    FIELDS =  c("EID",model$attrNames)
    print(paste(format(Sys.time(), "%H:%M:%S  Training with model "), trainFile, sep=""))

    for(b_idx in 1:length(blocklist)) {
      blockID = paste( c(blocklist[[b_idx]], FIELDS[blocklist[[b_idx]]]) , collapse="_")
      testFile = paste(RDataDIR,"/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep="")
      load(testFile)

      print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), testFile, sep=""))

      result = classifySupv(model, newdata = thisPair)
      prediction = result$prediction
      print(table(prediction))
      save(prediction, file=paste(VotingOutDIR, "/classifySupv_RL_Block_blockID_", blockID, "_randomSeed",i,".RData", sep="")) 
    }
}

