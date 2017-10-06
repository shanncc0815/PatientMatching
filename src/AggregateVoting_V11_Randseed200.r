rm(list=ls())

library(RecordLinkage)
#RDataDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData/"
VotingInDIR = "/media/chen/4TB1/PatientMatching/meta11/"
VotingOutDIR = "/media/chen/4TB1/PatientMatching/meta11/Voting_v11/"

SubmitDIR = "/home/chen/workspace/PatientMatching/tmp_submit"
SubmitCsvA = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000A.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000A.csv")

SubmitCsvB = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000B.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000B.csv")

#SubmitCsv = c(SubmitCsvA, SubmitCsvB)
SubmitCsv = c("pmc3_submit036_2961_184FP.csv","pmc1_submit012_Vote1000_noVote_V7F1_Batch1.csv","pmc1_submit013_Vote1000_noVote_V7F1_Batch2.csv", SubmitCsvA, SubmitCsvB)


RandTotal = 200
VotingPredict <- vector("list", length = length(RandTotal))
EIDList <- vector("list", length = length(RandTotal))
unionPairList <- vector("list", length = length(RandTotal))

#for(s_idx in 1:length(SubmitCsv)) {

for(s_idx in 1:length(SubmitCsv)) {
    testFile = paste(SubmitDIR,"/Examine_EpiClustering_jarowinkler_",SubmitCsv[s_idx],".RData",sep="")
    load(testFile)  # checkPair
    EIDList[[s_idx]] = checkPair$data$EnterpriseID
    unionPairList[[s_idx]] = paste(checkPair$pairs$id1,checkPair$pairs$id2, sep="_")

    PairN = dim(checkPair$pairs)[1]
    print(paste("[Csv=",s_idx,"] # of pairs in testFile:",PairN,sep=""))

    for(i in 1:RandTotal) {
      predictionFile = paste(VotingOutDIR, "/classifySupv_SubmitCsv",s_idx,"_randomSeed",i,".RData", sep="")
      load(predictionFile)  # prediction
      VotingPredict[[i]] = as.character(prediction)
#      print(paste("[Csv=",s_idx,",Rand=",i,"] # of pairs in testFile/prediction:",dim(checkPair$pairs)[1],",",length(prediction),sep=""))  
    }
    print("################")

#}
#save(VotingPredict, EIDList, VotingInDIR, VotingOutDIR, SubmitCsv, unionPairList, file=paste(VotingOutDIR, "AggregateVoting_V11_Randseed200_VotingPredict.RData",sep=""))

#for(s_idx in 1:length(SubmitCsv)) {
#for(s_idx in 1:1){
    
    Vote = NULL
    for(i in 1:RandTotal) {
        if(i == 1) {
            Vote = (VotingPredict[[i]] == "L") * 1
        } else { 
            Vote = Vote + (VotingPredict[[i]] == "L") * 1
        }
    }
#    print(table(Vote))

    EID = EIDList[[s_idx]]

    submit = strsplit(unionPairList[[s_idx]][which(Vote == 200)], split="_")
    Out = paste(EID[as.numeric(sapply(submit,function(X) X[1]))], EID[as.numeric(sapply(submit,function(X) X[2]))],1,sep=",")
    OutFileName1 = paste(SubmitDIR,"/[",s_idx,"]",SubmitCsv[s_idx],"_Vote200_V11_",length(Out),"_",PairN,".csv", sep="")
    write(Out, file = OutFileName1, append = FALSE, sep = " ")

    vote_idx = which(Vote > 0)
    submit = strsplit(unionPairList[[s_idx]][vote_idx], split="_")
    conf = Vote[vote_idx]
    Out = paste(EID[as.numeric(sapply(submit,function(X) X[1]))], EID[as.numeric(sapply(submit,function(X) X[2]))],conf/200,sep=",")
    Out = Out[order(conf, decreasing=T)]
    OutFileName2 = paste(SubmitDIR,"/[",s_idx,"]",SubmitCsv[s_idx],"_Vote200g0_V11_",length(Out),"_",PairN,".csv", sep="")
    write(Out, file = OutFileName2, append = FALSE, sep = " ")

    zero_idx = which(Vote == 0)
    submit = strsplit(unionPairList[[s_idx]][zero_idx], split="_")
    Out = paste(EID[as.numeric(sapply(submit,function(X) X[1]))], EID[as.numeric(sapply(submit,function(X) X[2]))],0,sep=",")
    OutFileName3 = paste(SubmitDIR,"/[",s_idx,"]",SubmitCsv[s_idx],"_Vote200zero_V11_",length(Out),"_",PairN,".csv", sep="")
    write(Out, file = OutFileName3, append = FALSE, sep = " ")

    print(OutFileName1)
    print(OutFileName2)
    print(OutFileName3)

}


save(VotingPredict, EIDList, VotingInDIR, VotingOutDIR, SubmitCsv, unionPairList, file=paste(VotingOutDIR, "AggregateVoting_V11_Randseed200_VotingPredict.RData",sep=""))

