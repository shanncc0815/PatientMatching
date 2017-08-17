rm(list=ls())

library(RecordLinkage)
options(width=100)


# Here we test a subset of 77148 samples (40424 True pairs)
load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
load("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_levenshteinSim.RData")

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
#load("meta6/uspsAddress_Merge_V6_2.RData")

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


rbind(1:dim(sub_df)[2],colnames(sub_df))
format(Sys.time(), "%H-%M-%S")

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

#allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
#sum(allPairs$pairs$is_match)

#MapID = cbind(sub_df$EnterpriseID, 1:length(sub_df$EnterpriseID))
#MapID = sub_df$EnterpriseID
match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])

#PHONE_MAP[allPairs$pairs$id1,2][1:5] == PHONE_MAP[allPairs$pairs$id2,2][1:5]
#300865 300865 300865     30     30 
# FALSE   TRUE  FALSE  FALSE   TRUE 
allPairs$pairs$PHONE = (PHONE_MAP[allPairs$pairs$id1,2] == PHONE_MAP[allPairs$pairs$id2,2]) * 1

#myPairs <- vector("list", length = length(blocklist))
for(b_idx in 1:length(blocklist)) {
#    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinSim)
    myPairs[[b_idx]]$pairs$PHONE = (PHONE_MAP[myPairs[[b_idx]]$pairs$id1,2] != PHONE_MAP[myPairs[[b_idx]]$pairs$id2,2]) * 10
}

save.image(file=paste(OutDIR,"/RL_myPairs_PHONE_levenshteinSim.RData",sep=""))


#########################

rm(list=ls())

library(RecordLinkage)
options(width=100)


# Here we test a subset of 197185 samples (40424 True pairs)
load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
load("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_EMAIL_levenshteinSim.RData")

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"

#load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_RL_Identity_EMAIL_0801_2017.RData")

rbind(1:dim(sub_df)[2],colnames(sub_df))
format(Sys.time(), "%H-%M-%S")

# first, do with Identity submatrix, without exclude, add DOB only (can filter later), add SSN only (can filter later)
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

#allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
#sum(allPairs$pairs$is_match)

#MapID = cbind(sub_df$EnterpriseID, 1:length(sub_df$EnterpriseID))
#MapID = sub_df$EnterpriseID
match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])

#PHONE_MAP[allPairs$pairs$id1,2][1:5] == PHONE_MAP[allPairs$pairs$id2,2][1:5]
#300865 300865 300865     30     30 
# FALSE   TRUE  FALSE  FALSE   TRUE 
allPairs$pairs$PHONE = (PHONE_MAP[allPairs$pairs$id1,2] == PHONE_MAP[allPairs$pairs$id2,2]) * 1

#myPairs <- vector("list", length = length(blocklist))
for(b_idx in 1:length(blocklist)) {
#    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinSim)
    myPairs[[b_idx]]$pairs$PHONE = (PHONE_MAP[myPairs[[b_idx]]$pairs$id1,2] != PHONE_MAP[myPairs[[b_idx]]$pairs$id2,2]) * 10
}

#FIELDS =  colnames(input_df)
save.image(file=paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_levenshteinSim.RData",sep=""))
#save(FIELDS, file=paste(OutDIR,"/RL_FIELDS.RData",sep=""))





#########################
rm(list=ls())
library(RecordLinkage)
options(width=100)

OutDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_0801_2017.RData")
load(paste(OutDIR,"/RL_FIELDS.RData",sep=""))
load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")

#load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.RData")
#rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H:%M:%S")

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

#MapID = cbind(sub_df$EnterpriseID, 1:length(sub_df$EnterpriseID))
match_idx = match(input_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])

FIELDS =  colnames(input_df)
for(bb_idx in 1:length(blocklist)) {
    blockID = paste( c(blocklist[[bb_idx]], FIELDS[blocklist[[bb_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), bb_idx, ":Block ", blockID, sep=""))
#    thisPair = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=levenshteinSim)
    load(paste("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_Block_blockID_", blockID, "_levenshteinSim.RData", sep=""))
    thisPair$pairs$PHONE = (PHONE_MAP[thisPair$pairs$id1,2] == PHONE_MAP[thisPair$pairs$id2,2]) * 1
    save(thisPair, file=paste(OutDIR,"/RL_Block_blockID_", blockID, "_levenshteinSim.RData", sep=""))
    rm(thisPair)
}


