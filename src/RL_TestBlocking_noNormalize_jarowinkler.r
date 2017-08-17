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

#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"    "18"    "19"      "20"  "21"  "22"
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "EMAIL" "ALIAS" "MIDINIT" "M"   "D"   "Y"

# DOB c(6)
# EMAIL c(17)
# SSN c(8)
# MOTHERS_MAIDEN_NAME c(12)

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8),   c(18,2), c(18,3), c(18,4), c(18,9), c(18,20,21), c(18,20,22), c(18,21,22),     c(18,19),    c(17,2), c(17,3), c(17,4), c(17,9), c(17,20,21), c(17,20,22), c(17,21,22), c(17,7), c(17,19), c(17,20), c(17,21), c(17,22))

if(FALSE) {
for(b_idx in 40:length(blocklist)) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair_noNormalize = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair_noNormalize$pairs)[1], " pairs" , sep=""))
    save(thisPair_noNormalize, blocklist, file=paste("/media/chen/4TB1/PatientMatching/meta8/Voting_v9/RL_Block_blockID_", blockID, "_noNormalize_jarowinkler.RData", sep=""))
    rm(thisPair_noNormalize)
}
}

input_df_SSN_MRN = input_df[,c(8,13)]

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
gc()

input_df = input_df[,-c(20,21)]
input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")

input_df$MRN = input_df_SSN_MRN$MRN
input_df$SSN = input_df_SSN_MRN$SSN

rm(input_df_SSN_MRN)
gc()

#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"    "18"    "19"      "20"  "21"  "22"
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "EMAIL" "ALIAS" "MIDINIT" "M"   "D"   "Y"

# 2: LAST
# 3: FIRST
# 6: DOB => 20, 21,22
# 8: SSN
# 9: ADDRESS1
# 16: PHONE => Can be mapped later
# 19: MIDINIT => Not a good feature...

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8),   c(18,2), c(18,3), c(18,4), c(18,9), c(18,20,21), c(18,20,22), c(18,21,22),     c(18,19),    c(17,2), c(17,3), c(17,4), c(17,9), c(17,20,21), c(17,20,22), c(17,21,22), c(17,7), c(17,19), c(17,20), c(17,21), c(17,22))


# 7, 19
# [7] Same, don't worry
# -rwxrwxrwx 1 chen chen  98752483 Aug 13 14:25 RL_Block_blockID_3_20_21_FIRST_M_D_jarowinkler.RData
# -rwxrwxrwx 1 chen chen 100713076 Aug 13 10:47 RL_Block_blockID_3_20_21_FIRST_M_D_noNormalize_jarowinkler.RData
# [19] 
# -rwxrwxrwx 1 chen chen 160766399 Aug 13 14:25 RL_Block_blockID_6_7_DOB_GENDER_jarowinkler.RData
# -rwxrwxrwx 1 chen chen 146648272 Aug 13 10:56 RL_Block_blockID_6_7_DOB_GENDER_noNormalize_jarowinkler.RData
 
# 8

for(b_idx in 23:length(blocklist)) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair_someNormalize = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair_someNormalize$pairs)[1], " pairs" , sep=""))
    save(thisPair_someNormalize, blocklist, file=paste("/media/chen/4TB1/PatientMatching/meta8/Voting_v9/RL_Block_blockID_", blockID, "_someNormalize_jarowinkler.RData", sep=""))
    rm(thisPair_someNormalize)
}


#########################


rm(list=ls())
library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.RData")
rm(sub_df)
#rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")

#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"    "18"    "19"      "20"  "21"  "22"
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "EMAIL" "ALIAS" "MIDINIT" "M"   "D"   "Y"

# 2: LAST
# 3: FIRST
# 6: DOB => 20, 21,22
# 8: SSN
# 9: ADDRESS1
# 16: PHONE => Can be mapped later
# 19: MIDINIT => Not a useful feature


blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8),   c(18,2), c(18,3), c(18,4), c(18,9), c(18,20,21), c(18,20,22), c(18,21,22),     c(18,19),    c(17,2), c(17,3), c(17,4), c(17,9), c(17,20,21), c(17,20,22), c(17,21,22), c(17,7), c(17,19), c(17,20), c(17,21), c(17,22))


for(b_idx in 23:length(blocklist)) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair$pairs)[1], " pairs" , sep=""))
    save(thisPair, blocklist, file=paste("/media/chen/4TB1/PatientMatching/meta8/Voting_v9/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep=""))
    rm(thisPair)
}



#######################################  
rm(list=ls())
library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.RData")
rm(sub_df, combinePair, df_V2, df_V4, diffPair, EID, Identity, match_idx, midx, orderPair, PHONE2, PHONE3, PHONE4, PHONE_dict, PHONE_key, V2_idx, V4_idx, w_idx, wrongPHONE)
#rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")

#219 E 121ST ST                               13940
#219E E 121ST ST                               1929

input_df$ADDRESS1[which(input_df$ADDRESS1 == "219E E 121ST ST")] = "219 E 121ST ST"

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8),   c(18,2), c(18,3), c(18,4), c(18,9), c(18,20,21), c(18,20,22), c(18,21,22),     c(18,19),    c(17,2), c(17,3), c(17,4), c(17,9), c(17,20,21), c(17,20,22), c(17,21,22), c(17,7), c(17,19), c(17,20), c(17,21), c(17,22))

for(b_idx in 38:length(blocklist)) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair_Address1 = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair_Address1$pairs)[1], " pairs" , sep=""))
    save(thisPair_Address1, blocklist, file=paste("/media/chen/4TB1/PatientMatching/meta8/Voting_v9/RL_Block_blockID_", blockID, "_address1_jarowinkler.RData", sep=""))
    rm(thisPair_Address1)
}


