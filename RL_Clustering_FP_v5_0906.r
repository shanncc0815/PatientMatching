rm(list=ls())

library(RecordLinkage)
options(width=100)

source("Utility/Pair_Utility.r")
input_df = read.csv("meta/cleanDataset_1M_withQuote.csv", stringsAsFactors=FALSE)

input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

SubmitDIR = "submit_sampc004"

SubmitCsv = c("pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv","pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv")

for(s_idx in 1:length(SubmitCsv)) {
    print(paste("[",s_idx,"/",length(SubmitCsv),"] Dedup ", SubmitCsv[s_idx], sep=""))

    check_df = read.csv(paste(SubmitDIR,'/',SubmitCsv[s_idx],sep=""),header=F)
    checkID_idx = paste(check_df$V1, check_df$V2, sep="_")
    #> dim(check_df)

    checkID = unique(c(as.character(check_df$V1),as.character(check_df$V2)))
    #> length(checkID)

    sub_df = input_df[match(checkID, input_df$EnterpriseID),]
    blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8))

    load("meta/PHONE_dict.RData")
    match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
    PHONE_MAP = as.matrix(PHONE_dict[match_idx,])

    thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)

    dim(thisPair$pairs)

    pairID_idx1 = paste(sub_df[thisPair$pairs$id1,1], sub_df[thisPair$pairs$id2,1], sep="_")
    pairID_idx2 = paste(sub_df[thisPair$pairs$id2,1], sub_df[thisPair$pairs$id1,1], sep="_")
    length(intersect(checkID_idx, pairID_idx1))
    length(intersect(checkID_idx, pairID_idx2))

    miss_idx = which(is.na(match(checkID_idx, intersect(checkID_idx, pairID_idx1))))
    checkID_idx[miss_idx]

    checkID_idx_swap = checkID_idx
    checkID_idx_swap[miss_idx] =  sapply(strsplit( checkID_idx[miss_idx], split="_"), function(X) paste(X[2],X[1],sep="_"))
    if( length(intersect(checkID_idx_swap, pairID_idx1)) == dim(check_df)[1]) {
        print(paste("[",s_idx,"]All ",dim(check_df)[1]," pairs can be covered:", SubmitCsv[s_idx], sep=""))
    } else {
        print(paste("[CHECK ",s_idx,"]",length(intersect(checkID_idx_swap, pairID_idx1)),"/",dim(check_df)[1]," pairs are covered:", SubmitCsv[s_idx], sep=""))
    }

    match_idx = match(checkID_idx_swap, pairID_idx1)
    checkPair = thisPair
    checkPair$pairs = thisPair$pairs[match_idx,]

    # Do normalization on MRN and PHONE
    checkPair$pairs$MRN = abs(checkPair$data$MRN[checkPair$pairs$id1] - checkPair$data$MRN[checkPair$pairs$id2])
    checkPair$pairs$MRN = 1 - (checkPair$pairs$MRN / 4963312)
    checkPair$pairs$PHONE = (PHONE_MAP[checkPair$pairs$id1,2] == PHONE_MAP[checkPair$pairs$id2,2]) * 1

    pairs_eW <- epiWeights(checkPair)
    summary(pairs_eW)

    # tail(getPairs(pairs_eW, 0.2, 0))
    Out = head(getPairs(pairs_eW, 1, 0), n=10000000000)
    OutName = paste("Examine_EpiClustering_jarowinkler_",SubmitCsv[s_idx],sep="")
    write.table(Out, file = OutName, sep=",")
    save(checkPair, file=paste(OutName, ".RData", sep=""))

    rm(pairs_eW, checkPair, Out, sub_df)
    gc()
}

