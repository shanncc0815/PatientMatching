library(RecordLinkage)
#RDataDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData/"
VotingInDIR = "/media/chen/4TB1/PatientMatching/meta9/"
VotingOutDIR = "/media/chen/4TB1/PatientMatching/meta9/Voting_v10/"
dir.create(VotingOutDIR)

RandTotal = 1000

SubmitDIR = "/home/chen/workspace/PatientMatching/tmp_submit"
SubmitCsvA = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000A.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000A.csv")

SubmitCsvB = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000B.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000B.csv")

#SubmitCsv = c(SubmitCsvA, SubmitCsvB)
SubmitCsv = c("pmc3_submit036_2961_184FP.csv","pmc1_submit012_Vote1000_noVote_V7F1_Batch1.csv","pmc1_submit013_Vote1000_noVote_V7F1_Batch2.csv", SubmitCsvA, SubmitCsvB)


for(i in 118:RandTotal) {
    set.seed(i)
    print("##################")

    trainFile = paste(VotingInDIR, "trainSupv_bagging_jarowinkler_randomSeed",i,".RData",sep="")
    load(trainFile)
    FIELDS =  c("EID",model$attrNames)
    print(paste(format(Sys.time(), "%H:%M:%S  Training with model "), trainFile, sep=""))

    for(s_idx in 1:length(SubmitCsv)) {
      testFile = paste(SubmitDIR,"/Examine_EpiClustering_jarowinkler_",SubmitCsv[s_idx],".RData",sep="")
      load(testFile)

      print(paste(format(Sys.time(), "%H:%M:%S  Testing with "), testFile, sep=""))

      result = classifySupv(model, newdata = checkPair)
      prediction = result$prediction
      print(table(prediction))
      save(prediction, file=paste(VotingOutDIR, "/classifySupv_SubmitCsv",s_idx,"_randomSeed",i,".RData", sep="")) 
    }
}
#source("testClassificationVoting_V8F2.r")

