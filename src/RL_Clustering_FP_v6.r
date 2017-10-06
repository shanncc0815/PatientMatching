rm(list=ls())

library(RecordLinkage)
options(width=100)

source("src/Pair_Utility.r")

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
input_df = input_df[,-c(20,21)]

input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

if(FALSE) {

tmp = diffPair("submit_sampc001/submit010_Vote1000_V7F1_52557.csv","submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv","submit_sampc004/pmc4_submit039_FP140.csv")
#[1] "allPair file submit_sampc001/submit010_Vote1000_V7F1_52557.csv (52557 pairs), set1Pair file submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv (57725 pairs), common 52417 pairs, additional 140 pairs are stored in tmp.csv"

tmp = diffPair("submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv","submit_sampc004/pmc4_submit040_common55193_diff_337.csv")
#[1] "allPair file submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv (55530 pairs), set1Pair file submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv (57725 pairs), common 55193 pairs, additional 337 pairs are stored in tmp.csv"

tmp = diffPair("submit_sampc004/pmc4_submit040_common55193_diff_337.csvcommon.csv","submit_sampc004/pmc4_submit031_54672TP_0FP.csv","submit_sampc004/pmc4_submit041_common54639_diff554_476TP_78FP.csv")
#[1] "allPair file submit_sampc004/pmc4_submit040_common55193_diff_337.csvcommon.csv (55193 pairs), set1Pair file submit_sampc004/pmc4_submit031_54672TP_0FP.csv (54672 pairs), common 54639 pairs, additional 554 pairs are stored in tmp.csv"

tmp = diffPair("submit_sampc004/pmc4_submit040_common55193_diff_337.csv","submit_sampc004/pmc4_submit039_FP140.csv","submit_sampc004/pmc4_submit042_diff197_91TP_106FP.csv")
#[1] "allPair file submit_sampc004/pmc4_submit040_common55193_diff_337.csv (337 pairs), set1Pair file submit_sampc004/pmc4_submit039_FP140.csv (140 pairs), common 140 pairs, additional 197 pairs are stored in tmp.csv"


# no common pairs
#tmp = diffPair("submit_sampc004/pmc4_submit042_diff197_91TP_106FP.csv","submit_sampc004/pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv","tmp.csv")

tmp = diffPair("submit_sampc004/pmc4_submit041_common54639_diff554_476TP_78FP.csv","submit_sampc004/pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv","tmp.csv")

tmp = diffPair("submit_sampc004/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv","submit_sampc004/pmc4_submit042_diff197_91TP_106FP.csv","tmp.csv")

tmp = diffPair("submit_sampc004/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv","submit_sampc004/pmc4_submit041_common54639_diff554_476TP_78FP.csv","tmp.csv")


tmp = combinePair("submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","submit_sampc004/pmc4_submit043_combineg0_58062_57197TP_865FP.csv")

tmp = diffPair("submit_sampc004/pmc4_submit043_combineg0_58062_57197TP_865FP.csv","submit_sampc004/pmc4_submit039_FP140.csv","submit_sampc004/tmp_57922.csv")

tmp = diffPair("submit_sampc004/tmp_57922.csv","submit_sampc004/14FP.csv","submit_sampc004/tmp_57908.csv")

tmp = diffPair("submit_sampc004/tmp_57908.csv","submit_sampc004/pmc4_submit031_54672TP_0FP.csv","submit_sampc004/pmc4_submit044_3236_2525TP_711FP.csv")

tmp = diffPair("submit_sampc004/pmc4_submit044_3236_2525TP_711FP.csv","submit_sampc004/pmc4_submit038_Jimmy_blacklist_fp.csv","submit_sampc004/pmc4_submit057_3139_2511TP_628FP.csv")

}

SubmitCsv = c("pmc4_submit038_Jimmy_blacklist_fp.csv","pmc4_submit057_3139_2511TP_628FP.csv","pmc4_submit043_Jimmy_fp_screen_501-1200.csv","pmc4_submit045_Jimmy_fp_screen_2700-3053.csv","pmc4_submit046_Jimmy_fp_screen_2640-2699.csv","pmc4_submit047_Ryk_fp_screen_1981-2639.csv")
SubmitDIR = "submit_sampc004"

for(s_idx in 6:length(SubmitCsv)) {
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




if(FALSE) {
print("#####################")

for(s_idx in 1:length(SubmitCsv)) {
#    tmp = diffPair("submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv",paste(SubmitDIR, SubmitCsv[s_idx],sep=""),paste(DiffDIR, "[",s_idx,"]",SubmitCsv[s_idx],sep=""))
#    tmp = diffPair("submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv",paste(SubmitDIR, SubmitCsv[s_idx],sep=""),paste(DiffDIR, "[",s_idx,"]",SubmitCsv[s_idx],sep=""))
    tmp = diffPair(paste(SubmitDIR, SubmitCsv[s_idx],sep=""),"submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv",paste(DiffDIR, "[",s_idx,"]",SubmitCsv[s_idx],sep=""))
}


print("#####################")
DOBDIR = "DOBsubmit/"
for(s_idx in 62:63) {
    if(s_idx > 9) {
        DOBfile = paste("sameDOB_FREQ",s_idx,".csv",sep="")
    } else {
        DOBfile = paste("sameDOB_FREQ0",s_idx,".csv",sep="")
    }
    if(s_idx != 61) {
        tmp = diffPair(paste(DOBDIR, DOBfile,sep=""),"submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv",paste(DiffDIR, DOBfile,sep=""))
    }
}

}

