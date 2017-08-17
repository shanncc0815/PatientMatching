rm(list=ls())

library(RecordLinkage)
options(width=100)


# Here we test a subset of 77148 samples (40424 True pairs)
#load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
#load("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_jarowinkler.RData")

InDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
#OutDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData"
load(paste(InDIR,"/RL_myPairs_PHONE_jarowinkler.RData",sep=""))

# normalized by larger of the two
#max_tmp = cbind(allPairs$data$MRN[allPairs$pairs$id1],allPairs$data$MRN[allPairs$pairs$id2])
#max_tmp = apply(max_tmp,1,max)
#max_tmp[which(is.na(max_tmp))] = 1

allPairs$pairs$MRN = abs(allPairs$data$MRN[allPairs$pairs$id1] - allPairs$data$MRN[allPairs$pairs$id2])
allPairs$pairs$MRN = 1- (allPairs$pairs$MRN / 4963312)

#allPairs$pairs$MRN[which(allPairs$pairs$is_match==1)[1:100]]
#allPairs$pairs$MRN[which(allPairs$pairs$is_match==0)[1:100]]
OutDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData"
save(allPairs, file=paste(OutDIR,"/RL_myPairs_PHONE_jarowinkler.RData",sep=""))

#########################

rm(list=ls())

library(RecordLinkage)
options(width=100)


# Here we test a subset of 197185 samples (40424 True pairs)
# load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
# load("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_EMAIL_jarowinkler.RData")

InDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
load(paste(InDIR,"/RL_myPairs_EMAIL_PHONE_jarowinkler.RData",sep=""))

# normalized by larger of the two
#max_tmp = cbind(allPairs$data$MRN[allPairs$pairs$id1],allPairs$data$MRN[allPairs$pairs$id2])
#max_tmp = apply(max_tmp,1,max)
#max_tmp[which(is.na(max_tmp))] = 1

allPairs$pairs$MRN = abs(allPairs$data$MRN[allPairs$pairs$id1] - allPairs$data$MRN[allPairs$pairs$id2])
allPairs$pairs$MRN = 1- (allPairs$pairs$MRN / 4963312)

#allPairs$pairs$MRN[which(allPairs$pairs$is_match==1)[1:100]]
#allPairs$pairs$MRN[which(allPairs$pairs$is_match==0)[1:100]]
OutDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData"
save(allPairs, file=paste(OutDIR,"/RL_myPairs_EMAIL_PHONE_jarowinkler.RData",sep=""))


#########################
rm(list=ls())
library(RecordLinkage)
options(width=100)

InDIR = "/home/chen/workspace/git_examples/PatientMatching/meta7/CompareAddressRData"
OutDIR = "/media/chen/4TB/PatientMatching/meta8/CompareAddressRData"
dir.create(OutDIR)
load(paste(InDIR,"/RL_FIELDS.RData",sep=""))
FIELDS = FIELDS[-17]
FIELDS[c(19,20,21,22)]=c("MIDINIT","M","D","Y")
#load(paste(InDIR,"/RL_myPairs_EMAIL_PHONE_jarowinkler.RData",sep=""))

#load("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_0801_2017.RData")
#load(paste(OutDIR,"/RL_FIELDS.RData",sep=""))
#load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")

#load("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.RData")
#rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H:%M:%S")

blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

for(bb_idx in 1:length(blocklist)) {
    print(paste(bb_idx,"/",length(blocklist), format(Sys.time(), "%H:%M:%S"), sep=" "))

    blockID = paste( c(blocklist[[bb_idx]], FIELDS[blocklist[[bb_idx]]]) , collapse="_")
    print(paste(format(Sys.time(), "%H:%M:%S  Processing "), bb_idx, ":Block ", blockID, sep=""))
#    thisPair = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)
    load(paste(InDIR,"/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep=""))
#    thisPair$pairs$PHONE = (PHONE_MAP[thisPair$pairs$id1,2] == PHONE_MAP[thisPair$pairs$id2,2]) * 1
#    max_tmp = cbind(thisPair$data$MRN[thisPair$pairs$id1],allPairs$data$MRN[thisPair$pairs$id2])
#    max_tmp = apply(max_tmp,1,max)
#    max_tmp[which(is.na(max_tmp))] = 1

    thisPair$pairs$MRN = abs(thisPair$data$MRN[thisPair$pairs$id1] - thisPair$data$MRN[thisPair$pairs$id2])
    thisPair$pairs$MRN = 1- (thisPair$pairs$MRN / 4963312)

    save(thisPair, file=paste(OutDIR,"/RL_Block_blockID_", blockID, "_jarowinkler.RData", sep=""))
    rm(thisPair)
}


