rm(list=ls())

print(format(Sys.time(), "%H:%M:%S"))
load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch1.RData")
Vote = NULL
for(i in 1:200) {
  print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction results with randseed "), i, sep=""))
  if(i == 1) {
    Vote = (VotingPredict[[i]] == "L") * 1
  } else {
    Vote = Vote + (VotingPredict[[i]] == "L") * 1
  }
}
rm(VotingPredict)
gc()

print(format(Sys.time(), "%H:%M:%S"))
load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch2.RData")
for(i in 201:400) {
  print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction results with randseed "), i, sep=""))
  Vote = Vote + (VotingPredict_Batch2[[i]] == "L") * 1
}
rm(VotingPredict_Batch2)
gc()

print(format(Sys.time(), "%H:%M:%S"))
load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch3.RData")
for(i in 401:600) {
  print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction results with randseed "), i, sep=""))
  Vote = Vote + (VotingPredict_Batch3[[i]] == "L") * 1
}
rm(VotingPredict_Batch3)
gc()

print(format(Sys.time(), "%H:%M:%S"))
load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch4.RData")
for(i in 601:800) {
  print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction results with randseed "), i, sep=""))
  Vote = Vote + (VotingPredict_Batch4[[i]] == "L") * 1
}
rm(VotingPredict_Batch4)
gc()

print(format(Sys.time(), "%H:%M:%S"))
load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch5.RData")
for(i in 801:1000) {
  print(paste(format(Sys.time(), "%H:%M:%S  Load Prediction results with randseed "), i, sep=""))
  Vote = Vote + (VotingPredict_Batch5[[i]] == "L") * 1
}
rm(VotingPredict_Batch5)
gc()

save(Vote, unionPair, EID, VotingOutDIR, file=paste(VotingOutDIR, "AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch1to5.RData",sep=""))

print(table(Vote))
submit = strsplit(unionPair[which(Vote == 1000)], split="_")
Out = paste(EID[as.numeric(sapply(submit,function(X) X[1]))], EID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = paste("submit010_Vote1000_V7F1_",length(Out)".csv", sep=""), append = FALSE, sep = " ")

submit = strsplit(unionPair[which(Vote > 0)], split="_")
Out = paste(EID[as.numeric(sapply(submit,function(X) X[1]))], EID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = paste("submit011_Vote1000g0_V7F1_",length(Out),".csv", sep=""), append = FALSE, sep = " ")

load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch1to5.RData")
submit = strsplit(unionPair[which(Vote == 0)], split="_")
Out = paste(EID[as.numeric(sapply(submit,function(X) X[1]))], EID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
#write(Out, file = "submit001_Vote3.csv", append = FALSE, sep = " ")
write(Out, file = paste("submit012_Vote1000_noVote_V7F1_",length(Out),".csv", sep=""), append = FALSE, sep = " ")


