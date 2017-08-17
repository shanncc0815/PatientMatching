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

input_df$FIRST2 = substr(input_df$FIRST,1,2)
input_df$LAST2 = substr(input_df$LAST,1,2)

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

blocklist1 = list(c(2,11,15), c(2,16), c(3,7,11,14,15), c(3,16), c(4,7,11,15), c(4,16), c(12,11,15), c(7,23,20,21,10), c(7,23,20,22,10), c(7,23,21,22,10),   c(7,24,20,21,10), c(7,24,20,22,10), c(7,24,21,22,10))

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

VotingDIR2 = "/media/chen/4TB1/PatientMatching/meta8/Voting_v11/"
dir.create(VotingDIR2)

for(b_idx in 8:length(blocklist1)) {
    blockID = paste( c(blocklist1[[b_idx]], colnames(input_df)[blocklist1[[b_idx]]]) , collapse="_")
    print("###############")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    Name1 = paste("RL_Block_blockID_", blockID, "_noNormalize_jarowinkler", sep="")
    Name2 = paste("RL_Block_blockID_", blockID, "_someNormalize_jarowinkler", sep="")
    Name3 = paste("RL_Block_blockID_", blockID, "_address1_jarowinkler", sep="")
    Name4 = paste("RL_Block_blockID_", blockID, "_jarowinkler", sep="")

    if( file.exists(paste(VotingDIR, Name1, ".RData", sep="")) ) {    
        load(paste(VotingDIR, Name1, ".RData", sep=""))
        P1 = data.frame(cbind(input_df$EnterpriseID[thisPair_noNormalize$pairs$id1], input_df$EnterpriseID[thisPair_noNormalize$pairs$id2]))
        colnames(P1) = c("V1","V2")
        print(paste("[No]   normalized Pairs: ", dim(thisPair_noNormalize$pairs)[1], sep=""))
        identifySubPair(allPairs,P1,paste(VotingDIR2, Name1, "_subPairs.csv", sep=""))
    }

    if( file.exists(paste(VotingDIR, Name2, ".RData", sep="")) ) {
        load(paste(VotingDIR, Name2, ".RData", sep=""))
        P2 = data.frame(cbind(input_df$EnterpriseID[thisPair_someNormalize$pairs$id1], input_df$EnterpriseID[thisPair_someNormalize$pairs$id2]))
        colnames(P2) = c("V1","V2")
        print(paste("[Some] normalized Pairs: ", dim(thisPair_someNormalize$pairs)[1], sep=""))
        identifySubPair(allPairs,P2,paste(VotingDIR2, Name2, "_subPairs.csv", sep=""))
    }

    if( file.exists(paste(VotingDIR, Name3, ".RData", sep="")) ) {
        load(paste(VotingDIR, Name3, ".RData", sep=""))
        P3 = data.frame(cbind(input_df$EnterpriseID[thisPair_Address1$pairs$id1], input_df$EnterpriseID[thisPair_Address1$pairs$id2]))
        colnames(P3) = c("V1","V2")
        print(paste("[Addr] normalized Pairs: ", dim(thisPair_Address1$pairs)[1], sep=""))
        identifySubPair(allPairs,P3,paste(VotingDIR2, Name3, "_subPairs.csv", sep=""))
    }

    if( file.exists(paste(VotingDIR, Name4, ".RData", sep="")) ) {
        load(paste(VotingDIR, Name4, ".RData", sep=""))
        P4 = data.frame(cbind(input_df$EnterpriseID[thisPair$pairs$id1], input_df$EnterpriseID[thisPair$pairs$id2]))       
        colnames(P4) = c("V1","V2")
        print(paste("[All] normalized Pairs: ", dim(thisPair$pairs)[1], sep=""))
        identifySubPair(allPairs,P4,paste(VotingDIR2, Name4, "_subPairs.csv", sep=""))
    }
}


if(FALSE) {
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


}
