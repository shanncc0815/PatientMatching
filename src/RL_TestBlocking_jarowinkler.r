rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.RData")
rbind(1:dim(sub_df)[2],colnames(sub_df))
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
# 19: MIDINIT => Not a good feature...

# try a PHONE mapping tonight~~~
# can use EMAIL to exclude

# first, do with Identity submatrix, without exclude, add DOB only (can filter later), add SSN only (can filter later)
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=jarowinkler)
sum(allPairs$pairs$is_match)

myPairs <- vector("list", length = length(blocklist))
for(b_idx in 1:length(blocklist)) {
#    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinSim)
    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=jarowinkler)
}

save.image(file="/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_jarowinkler.RData")


#########################

rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_RL_Identity_EMAIL_0801_2017.RData")

sub_df$PHONE2 = NULL
sub_df$MIDINIT = substr(sub_df$MIDDLE,1,1)  # FIELD 19
sub_df$M = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
sub_df$D = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
sub_df$Y = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

rbind(1:dim(sub_df)[2],colnames(sub_df))
format(Sys.time(), "%H-%M-%S")

# first, do with Identity submatrix, without exclude, add DOB only (can filter later), add SSN only (can filter later)
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=jarowinkler)
sum(allPairs$pairs$is_match)

myPairs <- vector("list", length = length(blocklist))
for(b_idx in 1:length(blocklist)) {
#    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=jarowinkler)
}

save.image(file="/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_EMAIL_jarowinkler.RData")





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

# try not to exclude anything.. #c(3,19) is bad.
#blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9))

# first, do with Identity submatrix, without exclude

#blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(21,22))


blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

for(b_idx in 1:length(blocklist)) {
    gc()
    blockID = paste( c(blocklist[[b_idx]], colnames(input_df)[blocklist[[b_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), b_idx, ":Block ", blockID, sep=""))
    thisPair = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair$pairs)[1], " pairs" , sep=""))
    save(thisPair, blocklist, file=paste("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep=""))
    rm(thisPair)
}


