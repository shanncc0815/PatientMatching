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

#input_df$FIRST4 = substr(input_df$FIRST,1,4)
#input_df$LAST4 = substr(input_df$LAST,1,4)

input_df$FIRST2 = substr(input_df$FIRST,1,2)
input_df$LAST2 = substr(input_df$LAST,1,2)

rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")

#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"    "18"    "19"      "20"  "21"  "22"
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "EMAIL" "ALIAS" "MIDINIT" "M"   "D"   "Y"

#blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8),   c(18,2), c(18,3), c(18,4), c(18,9), c(18,20,21), c(18,20,22), c(18,21,22),     c(18,19),    c(17,2), c(17,3), c(17,4), c(17,9), c(17,20,21), c(17,20,22), c(17,21,22), c(17,7), c(17,19), c(17,20), c(17,21), c(17,22))

#input_df[c(588610,814883),]
#       EnterpriseID      LAST   FIRST MIDDLE SUFFIX       DOB GENDER SSN
#588610     15881893 QUITIQUIT CEDESTE               10/2/2007      F    
#814883     15430336 QUITIQUIT CELESTE                4/6/2010      F    
#             ADDRESS1 ADDRESS2  ZIP MOTHERS_MAIDEN_NAME     MRN           CITY
#588610 516 EDGAR ROAD       A3 7202                     4836892 ELIZABETH  AVE
#814883   516 EDGAR RD       A3 7202             KIGGENS 4836901      ELIZABETH
#       STATE        PHONE                EMAIL ALIAS MIDINIT  M D    Y
#588610    NJ 631-801-6255                                    10 2 2007
#814883    NJ 631-801-6255 CQUITIQUIT@AMGGT.COM                4 6 2010

#> input_df[c(763283,783956),]
#       EnterpriseID   LAST   FIRST MIDDLE SUFFIX        DOB GENDER         SSN
#763283     15900506 HANLEY  SABRIN  NORMA        12/15/1926      F 849-76-0853
#783956     15622465  CAREY SABRINE               12/16/1926      F            
#             ADDRESS1 ADDRESS2   ZIP MOTHERS_MAIDEN_NAME     MRN     CITY STATE
#763283 550 W 125TH ST      13A 10027                     4756720 NEW YORK    NY
#783956 550 125 STREET      13A 11223                     4756727 BROOKLYN    NY
#              PHONE EMAIL ALIAS MIDINIT  M  D    Y
#763283 732-147-5072                   N 12 15 1926
#783956 570-197-3874                     12 16 1926

blocklist = list(c(2,11,15), c(2,16), c(3,7,11,14,15), c(3,16), c(4,7,11,15), c(4,16), c(12,11,15), c(7,23,20,21,10), c(7,23,20,22,10), c(7,23,21,22,10),   c(7,24,20,21,10), c(7,24,20,22,10), c(7,24,21,22,10))

if(FALSE) {

for(b_idx in 1:length(blocklist)) {
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

input_df$FIRST2 = substr(input_df$FIRST,1,2)
input_df$LAST2 = substr(input_df$LAST,1,2)

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

# 1 and 3 memory...
blocklist = list(c(2,11,15), c(2,16), c(3,7,11,14,15), c(3,16), c(4,7,11,15), c(4,16), c(12,11,15), c(7,23,20,21,10), c(7,23,20,22,10), c(7,23,21,22,10),   c(7,24,20,21,10), c(7,24,20,22,10), c(7,24,21,22,10))


for(b_idx in 3:3) { # length(blocklist)) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair_someNormalize = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair_someNormalize$pairs)[1], " pairs" , sep=""))
    save(thisPair_someNormalize, blocklist, file=paste("/media/chen/4TB1/PatientMatching/meta8/Voting_v9/RL_Block_blockID_", blockID, "_someNormalize_jarowinkler.RData", sep=""))
    rm(thisPair_someNormalize)
}




#########################
if(FALSE) {


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

input_df$FIRST2 = substr(input_df$FIRST,1,2)
input_df$LAST2 = substr(input_df$LAST,1,2)

blocklist = list(c(2,11,15), c(2,16), c(3,7,11,14,15), c(3,16), c(4,7,11,15), c(4,16), c(12,11,15), c(7,23,20,21,10), c(7,23,20,22,10), c(7,23,21,22,10),   c(7,24,20,21,10), c(7,24,20,22,10), c(7,24,21,22,10))




# 3, 5 memory...
for(b_idx in 5:5){#length(blocklist)) {
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

input_df$FIRST2 = substr(input_df$FIRST,1,2)
input_df$LAST2 = substr(input_df$LAST,1,2)


blocklist = list(c(2,11,15), c(2,16), c(3,7,11,14,15), c(3,16), c(4,7,11,15), c(4,16), c(12,11,15), c(7,23,20,21,10), c(7,23,20,22,10), c(7,23,21,22,10),   c(7,24,20,21,10), c(7,24,20,22,10), c(7,24,21,22,10))

#memory 1,3,5,8
#for(b_idx in 12:length(blocklist)) {
for(b_idx in 1:1) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair_Address1 = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair_Address1$pairs)[1], " pairs" , sep=""))
    save(thisPair_Address1, blocklist, file=paste("/media/chen/4TB1/PatientMatching/meta8/Voting_v9/RL_Block_blockID_", blockID, "_address1_jarowinkler.RData", sep=""))
    rm(thisPair_Address1)
}
}
