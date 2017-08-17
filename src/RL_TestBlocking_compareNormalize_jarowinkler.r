rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/original-dataset/FInalDataset_1M.csv", stringsAsFactors=FALSE)
rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")
input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")


load("/media/chen/4TB1/PatientMatching/meta8/Voting_v7/AggregateVoting_V7F1_Randseed1000_VotingPredict_Batch1to5.RData")
splitPair = strsplit(unionPair, split="_")
allPairs = data.frame(cbind(EID[as.numeric(sapply(splitPair,function(X) X[1]))], EID[as.numeric(sapply(splitPair,function(X) X[2]))]))
colnames(allPairs) = c("V1","V2")
allPairs = orderPair(allPairs) 

#allPairs_Out = paste(allPairs$V1, allPairs$V2, 1,sep=",")
#write(allPairs_Out, file = "submit_sampc001/unsubmit_Vote1000_allPairs.csv", append = FALSE, sep = " ")


#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"    "18"    "19"      "20"  "21"  "22"
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "EMAIL" "ALIAS" "MIDINIT" "M"   "D"   "Y"

VotingDIR = "/media/chen/4TB1/PatientMatching/meta8/Voting_v9/"

blocklist1 = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8),   c(18,2), c(18,3), c(18,4), c(18,9), c(18,20,21), c(18,20,22), c(18,21,22),     c(18,19),    c(17,2), c(17,3), c(17,4), c(17,9), c(17,20,21), c(17,20,22), c(17,21,22), c(17,7), c(17,19), c(17,20), c(17,21), c(17,22))


source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

VotingDIR2 = "/media/chen/4TB1/PatientMatching/meta8/Voting_v10/"
dir.create(VotingDIR2)

#for(b_idx in 1:length(blocklist1)) {

for(b_idx in 23:length(blocklist1)) {
  if(b_idx!=7) {
    blockID = paste( c(blocklist1[[b_idx]], colnames(input_df)[blocklist1[[b_idx]]]) , collapse="_")
    print("###############")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    Name1 = paste("RL_Block_blockID_", blockID, "_noNormalize_jarowinkler", sep="")
    Name2 = paste("RL_Block_blockID_", blockID, "_someNormalize_jarowinkler", sep="")
    Name3 = paste("RL_Block_blockID_", blockID, "_address1_jarowinkler", sep="")
    Name4 = paste("RL_Block_blockID_", blockID, "_jarowinkler", sep="")

    load(paste(VotingDIR, Name1, ".RData", sep=""))
    load(paste(VotingDIR, Name2, ".RData", sep=""))
    load(paste(VotingDIR, Name3, ".RData", sep=""))
    load(paste(VotingDIR, Name4, ".RData", sep=""))

#    P1 = paste(input_df$EnterpriseID[thisPair_noNormalize$pairs$id1], input_df$EnterpriseID[thisPair_noNormalize$pairs$id2],1,sep=",")
#    P2 = paste(input_df$EnterpriseID[thisPair_someNormalize$pairs$id1], input_df$EnterpriseID[thisPair_someNormalize$pairs$id2],1,sep=",")
#    P3 = paste(input_df$EnterpriseID[thisPair_Address1$pairs$id1], input_df$EnterpriseID[thisPair_Address1$pairs$id2],1,sep=",")

    P1 = data.frame(cbind(input_df$EnterpriseID[thisPair_noNormalize$pairs$id1], input_df$EnterpriseID[thisPair_noNormalize$pairs$id2]))
    P2 = data.frame(cbind(input_df$EnterpriseID[thisPair_someNormalize$pairs$id1], input_df$EnterpriseID[thisPair_someNormalize$pairs$id2]))
    P3 = data.frame(cbind(input_df$EnterpriseID[thisPair_Address1$pairs$id1], input_df$EnterpriseID[thisPair_Address1$pairs$id2]))
    colnames(P1) = c("V1","V2")
    colnames(P2) = c("V1","V2")
    colnames(P3) = c("V1","V2")

    print(paste("[All]  normalized Pairs: ", dim(thisPair$pairs)[1], sep=""))
#    print("---------")
#    print(paste("[No]   normalized Pairs: ", dim(thisPair_noNormalize$pairs)[1], sep=""))
#    identifySubPair(allPairs,P1,paste(VotingDIR, Name1, "_subPairs.csv", sep=""))
#    print(paste("[Some] normalized Pairs: ", dim(thisPair_someNormalize$pairs)[1], sep=""))
#    identifySubPair(allPairs,P2,paste(VotingDIR, Name2, "_subPairs.csv", sep=""))
#    print(paste("[Addr] normalized Pairs: ", dim(thisPair_Address1$pairs)[1], sep=""))
#    identifySubPair(allPairs,P3,paste(VotingDIR, Name3, "_subPairs.csv", sep=""))

    print("---------")
    print(paste("[No]   normalized Pairs: ", dim(thisPair_noNormalize$pairs)[1], sep=""))
    identifySubPair(allPairs,P1,paste(VotingDIR2, Name1, "_subPairs.csv", sep=""))
    print(paste("[Some] normalized Pairs: ", dim(thisPair_someNormalize$pairs)[1], sep=""))
    identifySubPair(allPairs,P2,paste(VotingDIR2, Name2, "_subPairs.csv", sep=""))
    print(paste("[Addr] normalized Pairs: ", dim(thisPair_Address1$pairs)[1], sep=""))
    identifySubPair(allPairs,P3,paste(VotingDIR2, Name3, "_subPairs.csv", sep=""))
  }
}

tmp1 = diffPair("submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","submit/submit085_AllPos.csv","tmp/tmp1.csv")
tmp2 = diffPair("submit/submit085_AllPos.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","tmp/tmp2.csv")
tmp3 = read.csv("original-dataset/Label.csv")
Label_True = tmp3[tmp3$valid == "true",]
Label_False = tmp3[tmp3$valid == "false",]

#dim(tmp3)[1]
# [1] 922 true cases
Out = paste(Label_True$id1, Label_True$id2, 1, sep=",")
write(Out, file = paste("original-dataset/submit035_Label_true.csv", sep=""), append = FALSE, sep = " ")

Out = paste(Label_False$id1, Label_False$id2, 1, sep=",")
write(Out, file = paste("original-dataset/submit036_Label_false.csv", sep=""), append = FALSE, sep = " ")

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/original-dataset/FInalDataset_1M.csv", stringsAsFactors=FALSE)
#tmp4 = diffPair("submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","original-dataset/submit035_Label_true.csv","tmp/tmp4.csv")
tmp5 = diffPair("original-dataset/submit035_Label_true.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","src_submit/tmp5.csv")

tmp5a = diffPair("original-dataset/submit035_Label_true.csv","submit_sampc001/submit010_Vote1000_V7F1_52557.csv","src_submit/tmp5a.csv")

tmp6 = diffPair("original-dataset/submit035_Label_true.csv","submit_sampc001/unsubmit_Vote1000_allPairs.csv","src_submit/tmp6.csv")

#> tmp5 = diffPair("original-dataset/submit035_Label_true.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","tmp/tmp5.csv")
#[1] "allPair file original-dataset/submit035_Label_true.csv (922 pairs), set1Pair file submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv (55530 pairs), common 899 pairs, additional 20 pairs are stored in tmp/tmp5.csv"

#> tmp5a = diffPair("original-dataset/submit035_Label_true.csv","submit_sampc001/submit010_Vote1000_V7F1_52557.csv","src_submit/tmp5a.csv")
#[1] "allPair file original-dataset/submit035_Label_true.csv (922 pairs), set1Pair file submit_sampc001/submit010_Vote1000_V7F1_52557.csv (52557 pairs), common 888 pairs, additional 31 pairs are stored in src_submit/tmp5a.csv"


#> tmp6 = diffPair("original-dataset/submit035_Label_true.csv","submit_sampc001/unsubmit_Vote1000_allPairs.csv","tmp/tmp6.csv")
#[1] "allPair file original-dataset/submit035_Label_true.csv (922 pairs), set1Pair file submit_sampc001/unsubmit_Vote1000_allPairs.csv (14546586 pairs), common 918 pairs, additional 1 pairs are stored in tmp/tmp6.csv"

#cat tmp/tmp6.csv
#13941996,14187510,1
#chen@GPU:~/workspace/git_examples/PatientMatching$ grep 13941996 original-dataset/FInalDataset_1M.csv 
#13941996,ALLEN,JAMES,ELMER,,,MALE,,,,,,4458819,,,267-318-5224,,,
#chen@GPU:~/workspace/git_examples/PatientMatching$ grep 14187510 original-dataset/FInalDataset_1M.csv 
#14187510,GOAD,JAMES,H,,1/2/2013,MALE,894-53-9428,455 SCHENECTADY AVE,6E,11203,,4462606,BROOKLYN,NY,203-209-2324,,,

# This is the FP
#8	13941996	ALLEN	JAMES	ELMER			MALE						4458819			267-318-5224
#8	14187510	GOAD	JAMES	H		1/2/2013	MALE	894-53-9428	455 SCHENECTADY AVE	6E	11203		4462606	BROOKLYN	NY	203-209-2324

## => original-dataset/submit035_Label_true.csv has 919 (899+20 or 918+1) unique pairs       => 918 TP and 1 FP
##  can consider FIRST, GENDER



tmp7 = diffPair("original-dataset/submit036_Label_false.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","src_submit/tmp7.csv")
tmp8 = diffPair("original-dataset/submit036_Label_false.csv","submit_sampc001/unsubmit_Vote1000_allPairs.csv","src_submit/tmp8.csv")

examineCSV <- function(inputPairName, input_df) {
    f1 = read.csv(inputPairName,header=F)
    f2 = read.csv(paste(inputPairName,"common.csv",sep=""),header=F)
    outf1 = paste(inputPairName, ".Examine.csv", sep="")
    outf2 = paste(inputPairName, "common.Examine.csv", sep="")

    write.csv(t(c("FIELD",colnames(input_df))), file = outf1, row.names=FALSE,append=F, quote=F)     
    for (i in 1:dim(f1)[1]) {
      id1=match(f1$V1[i], input_df[,1])
      id2=match(f1$V2[i], input_df[,1])
      MyData = cbind(i,input_df[c(id1,id2),])
      write.csv(MyData, file = outf1, row.names=FALSE, append=T, quote=F)
      write.csv("", file = outf1, row.names=FALSE, append=T, quote=F)
    }

    write.csv(t(c("FIELD",colnames(input_df))), file = outf2, row.names=FALSE,append=F, quote=F)
    for (i in 1:dim(f2)[1]) {
      id1=match(f2$V1[i], input_df[,1])
      id2=match(f2$V2[i], input_df[,1])
      MyData = cbind(i,input_df[c(id1,id2),])
      write.csv(MyData, file = outf2, row.names=FALSE, append=T, quote=F)
      write.csv("", file = outf2, row.names=FALSE, append=T, quote=F)
    }
}


#inputPairName = "src_submit/tmp7.csv"
#examineCSV(inputPairName, input_df)
examineCSV("src_submit/tmp5.csv", input_df)
examineCSV("src_submit/tmp5a.csv", input_df)
examineCSV("src_submit/tmp6.csv", input_df)
examineCSV("src_submit/tmp7.csv", input_df)
examineCSV("src_submit/tmp8.csv", input_df)

# tmp7 = diffPair("original-dataset/submit036_Label_false.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","tmp/tmp7.csv")
# [1] "allPair file original-dataset/submit036_Label_false.csv (1630 pairs), set1Pair file submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv (55530 pairs), common 19 pairs, additional 1603 pairs are stored in tmp/tmp7.csv"
# can consider GENDER, MOTHERS_MAIDEN_NAME
# can consider LAST, GENDER
# can consider DOB, GENDER
# just SSN?
# CHARLEE vs CHARLES in FIRST NAME?
# can consider FIRST, MOTHERS_MAIDEN_NAME
# just DOB?

#> tmp8 = diffPair("original-dataset/submit036_Label_false.csv","submit_sampc001/unsubmit_Vote1000_allPairs.csv","tmp/tmp8.csv")
#[1] "allPair file original-dataset/submit036_Label_false.csv (1630 pairs), set1Pair file submit_sampc001/unsubmit_Vote1000_allPairs.csv (14546586 pairs), common 629 pairs, additional 993 pairs are stored in tmp/tmp8.csv"

## => original-dataset/submit036_Label_true.csv has 1622 (19+1693 or 629+993) unique pairs   => 22 TP and 1600 TN
## The 19 commonID should be TP

#submit/submit085_AllPos.csv
#submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv
#original-dataset/Label.csv

# Manual curation...  src_submit/submit028_additionalPairs_Batch2.csv has 2 TP => binary search...
examineCSV("src_submit/unsubmit079.28_additionalPairs_Batch2_CBA_2001to2025.csv", input_df)
examineCSV("src_submit/submit086.28_additionalPairs_Batch2_CCA_4576to4675.csv", input_df)

tmp9 = diffPair("submit_sampc001/submit090_Vote1000g0_V7F1_55530_53.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","src_submit/tmp9.csv")
#[1] "allPair file submit_sampc001/submit090_Vote1000g0_V7F1_55530_53.csv (55583 pairs), set1Pair file submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv (55530 pairs), common 55530 pairs, additional 23 pairs are stored in src_submit/tmp9.csv"
examineCSV("src_submit/tmp9.csv", input_df)

tmp10 = diffPair("src_submit/tmp9.csv","submit_sampc001/unsubmit_Vote1000_allPairs.csv","src_submit/tmp10.csv")
examineCSV("src_submit/tmp10.csv", input_df)


#examineCSV("", input_df)
examineCSV("src_submit/tmp_15430336.csv", input_df)
examineCSV("src_submit/tmp_15881893.csv", input_df)
examineCSV("src_submit/tmp_15622465.csv", input_df)
examineCSV("src_submit/tmp_15900506.csv", input_df)



