rm(list=ls())

source("src/Pair_Utility.r")

SubmitDIR = "/home/chen/workspace/PatientMatching/tmp_submit/"
SubmitCsvA = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000A.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000A.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000A.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000A.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000A.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000A.csv")

SubmitCsvB = c("pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Top500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Bottom500000B.csv","pmc1_submit015_Vote1000_noVote_V7F1_Batch4_Top500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Bottom500000B.csv","pmc1_submit016_Vote1000_noVote_V7F1_Batch5_Top500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Bottom500000B.csv","pmc1_submit017_Vote1000_noVote_V7F1_Batch6_Top500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Bottom500000B.csv","pmc1_submit018_Vote1000_noVote_V7F1_Batch7_Top500000B.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Bottom500000B.csv")

#SubmitCsv = c("pmc3_submit036_2961_184FP.csv","pmc1_submit012_Vote1000_noVote_V7F1_Batch1.csv","pmc1_submit013_Vote1000_noVote_V7F1_Batch2.csv", SubmitCsvA, SubmitCsvB, "pmc2_submit044_Checksubmit014_MoreBlocking_0816_Batch14.csv")

SubmitCsv = c("pmc1_submit012_Vote1000_noVote_V7F1_Batch1.csv","pmc1_submit013_Vote1000_noVote_V7F1_Batch2.csv", SubmitCsvA, SubmitCsvB, "pmc2_submit044_Checksubmit014_MoreBlocking_0816_Batch14.csv","pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Bottom500000A.csv","pmc1_submit014_Vote1000_noVote_V7F1_Batch3_Bottom500000B.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Top500000A.csv","pmc1_submit019_Vote1000_noVote_V7F1_Batch8_Top500000B.csv")

DiffDIR = "/home/chen/workspace/PatientMatching/diff_submit/"
dir.create(DiffDIR)




print("#####################")

if(FALSE) {


for(s_idx in 23:length(SubmitCsv)) {
            tmp = diffPair(paste(SubmitDIR, SubmitCsv[s_idx],sep=""),"submit_sampc004/pmc4_submit280_57255TP_0FP.csv",paste(DiffDIR, "pmc4_submit",280+s_idx,"_",s_idx,"_",SubmitCsv[s_idx],sep=""))
}



#if(FALSE) {

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

library(RecordLinkage)
options(width=100)

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
input_df = input_df[,-c(20,21)]

input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22



for(s_idx in 24:length(SubmitCsv)) {

print(paste("[",s_idx,"/",length(SubmitCsv),"] Dedup ", SubmitCsv[s_idx], sep=""))

CsvFileName = paste(DiffDIR, "pmc4_submit",280+s_idx,"_",s_idx,"_",SubmitCsv[s_idx],sep="")

check_df = read.csv(CsvFileName, header=F)
checkID_idx = paste(check_df$V1, check_df$V2, sep="_")
#> dim(check_df)
#[1] 12025     3

checkID = unique(c(as.character(check_df$V1),as.character(check_df$V2)))
#> length(checkID)
#[1] 24032


sub_df = input_df[match(checkID, input_df$EnterpriseID),]
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8),   c(12), c(8))

load("/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
match_idx = match(sub_df$EnterpriseID, PHONE_dict$EID)
PHONE_MAP = as.matrix(PHONE_dict[match_idx,])


thisPair = compare.dedup(sub_df, blockfld = blocklist, exclude=1, strcmp=TRUE, strcmpfun=jarowinkler)

dim(thisPair$pairs)
#[1] 26306    24

pairID_idx1 = paste(sub_df[thisPair$pairs$id1,1], sub_df[thisPair$pairs$id2,1], sep="_")
pairID_idx2 = paste(sub_df[thisPair$pairs$id2,1], sub_df[thisPair$pairs$id1,1], sep="_")
length(intersect(checkID_idx, pairID_idx1))
#[1] 2960
length(intersect(checkID_idx, pairID_idx2))
#[1] 1

miss_idx = which(is.na(match(checkID_idx, intersect(checkID_idx, pairID_idx1))))
#[1] 2945
#> which(checkID_idx == intersect(checkID_idx, pairID_idx2))
#[1] 2945
checkID_idx[miss_idx]
#[1] "15419663_15849291"

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

rm(thisPair)

# Do normalization on MRN and PHONE
checkPair$pairs$MRN = abs(checkPair$data$MRN[checkPair$pairs$id1] - checkPair$data$MRN[checkPair$pairs$id2])
checkPair$pairs$MRN = 1 - (checkPair$pairs$MRN / 4963312)
checkPair$pairs$PHONE = (PHONE_MAP[checkPair$pairs$id1,2] == PHONE_MAP[checkPair$pairs$id2,2]) * 1

pairs_eW <- epiWeights(checkPair)
summary(pairs_eW)

# tail(getPairs(pairs_eW, 0.2, 0))
Out = head(getPairs(pairs_eW, 1, 0), n=1000000000000000)
OutName = paste("tmp_submit/Examine_Clustering_",SubmitCsv[s_idx],sep="")
write.table(Out, file = OutName, sep=",")
save(checkPair, file=paste(OutName, ".RData", sep=""))

rm(pairs_eW, checkPair, Out, sub_df)
gc()

}



