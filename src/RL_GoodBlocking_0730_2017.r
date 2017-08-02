library(RecordLinkage)
options(width=100)

# or use tryCatch()  http://mazamascience.com/WorkingWithData/?p=912
orderPair <- function(Pair) {
  idx = which(Pair$V1 > Pair$V2); 
  tmp = Pair$V1[idx]; Pair$V1[idx] = Pair$V2[idx]; Pair$V2[idx] = tmp
  Pair$idx = paste(Pair$V1,Pair$V2,sep="_")
  return(Pair)
}

diffPair <- function(allPairName,set1PairName,outPairName) {
  if (file.exists(allPairName) & file.exists(set1PairName)) {
    PA = read.csv(allPairName,header=F)
    P1 = read.csv(set1PairName,header=F)
#    print(P1[1:10,])
    PA = orderPair(PA); 
    P1 = orderPair(P1);
#    print(P1[1:10,])
    commonID = intersect(P1$idx, PA$idx)
    P2 = setdiff(PA$idx,commonID)
    set2Pairs = data.frame(cbind(sapply(strsplit(P2, split="_"),function(x) x[1]),sapply(strsplit(P2, split="_"),function(x) x[2]),1))
    colnames(set2Pairs) = c("V1","V2","V3")
    print(sprintf('Subset %s from allPair %s and store as %s.', set1PairName, allPairName, outPairName))
    write.table(set2Pairs,file=outPairName,row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
  } else {
    print(sprintf('Either %s or %s does not exist.  Please check again', set1PairName, allPairName))
    stop("diffPair error")
  }
  return(set2Pairs)
}

combinePair <- function(set1PairName,set2PairName,outPairName) {
  if (file.exists(set1PairName) & file.exists(set2PairName)) {
    P1 = read.csv(set1PairName,header=F)
    P2 = read.csv(set2PairName,header=F)
    P1 = orderPair(P1);
    P2 = orderPair(P2);
    P12 = rbind(P1,P2);
    PU = unique(P12$idx)
    cPair = data.frame(cbind(sapply(strsplit(PU, split="_"),function(x) x[1]),sapply(strsplit(PU, split="_"),function(x) x[2]),1))
    colnames(cPair) = c("V1","V2","V3")

    print(sprintf('Combine %s and %s and store as %s.', set1PairName, set2PairName, outPairName))
    write.table(cPair,file=outPairName,row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
  } else {
    print(sprintf('Either %s or %s does not exist.  Please check again', set1PairName, set2PairName))
    stop("combinePair error")
  }
  return(cPair)
}

#PosID = unique(c(as.character(AllPos$V1),as.character(AllPos$V2)))
#NegID = unique(c(as.character(AllNeg$V1),as.character(AllNeg$V2)))
#length(NegID)

#> length(PosID)
#[1] 38892
#> dim(AllPos)  # Number of Pairs
#[1] 40424     3

#PNID = unique(c(PosID, NegID))
#match_idx = match(PNID, sub_df$EnterpriseID)
#sub_df = sub_df[match_idx,]


load(file="meta6/uspsAddress_RL_Identity_0728_2017_v2.RData")

sub_df$MIDINIT = substr(sub_df$MIDDLE,1,1)  # FIELD 20
sub_df$M = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[1]) # FIELD 21
sub_df$D = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[2]) # FIELD 22
sub_df$Y = sapply(strsplit(sub_df$DOB, split = "/"), function(X) X[3]) # FIELD 23

sub_df$SSN1 = sapply(strsplit(sub_df$SSN, split = "-"), function(X) X[1]) # FIELD 24
sub_df$SSN2 = sapply(strsplit(sub_df$SSN, split = "-"), function(X) X[2]) # FIELD 25
sub_df$SSN3 = sapply(strsplit(sub_df$SSN, split = "-"), function(X) X[3]) # FIELD 26

rbind(1:dim(sub_df)[2],colnames(sub_df))

# [1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
# [2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
# [1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"    "20"     
# [2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS" "MIDINIT"
# [1,] "21"  "22"  "23"  "24"   "25"   "26"  
# [2,] "M"   "D"   "Y"   "SSN1" "SSN2" "SSN3"

PM_pair1 = compare.dedup(sub_df, blockfld = list(c(2,3),c(2,6),c(2,8),c(2,9),c(2,20),c(3,6),c(3,8),c(3,9),c(3,20),c(6,8),c(6,9),c(6,20),c(8,9),c(8,20),c(9,20)), identity = Identity$iID, exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)


PM_pair1$pairs[1:5,]

dim(PM_pair1$pairs)
# [1] 165097     22

sum(PM_pair1$pairs$is_match)
# [1] 40414 <= Positive cases

dim(PM_pair1$pairs)[1] - sum(PM_pair1$pairs$is_match)
# [1] 124683 <= Negative cases

sum(PM_pair1$pairs$is_match) / dim(AllPos)[1]

# dim(AllPos)[1] * (1-0.9997526)
# [1] 10 <= Missed 10 cases, Blocking is missing


GoodPai1 = PM_pair1$pairs[which(PM_pair1$pairs$is_match == 1),]
outPair1 = paste(sub_df$EnterpriseID[GoodPair1$id1],",",sub_df$EnterpriseID[GoodPair1$id2],",1",sep="")
write.table(outPair1,file="tmp/GoodPair1.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
missPair = diffPair("submit/submit085_AllPos.csv","tmp/GoodPair1.csv","tmp/tmp2.csv")

#WriteN = length(Out)
CheckFileName = paste("Check_",Sys.Date(),"_",format(Sys.time(), "%H-%M-%S"), ".csv", sep="")
write.csv(t(c("FIELD",colnames(sub_df))), file = CheckFileName, row.names=FALSE,append=F, quote=F)

WriteN = 10
for (i in 1:WriteN) {
    MyData = cbind(i,sub_df[c(match(missPair$V1[i],sub_df[,1]),match(missPair$V2[i],sub_df[,1])),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}
print(format(Sys.time(), "%H:%M:%S"))
##################################################

# [1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
# [2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
# [1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"    "20"     
# [2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS" "MIDINIT"
# [1,] "21"  "22"  "23"  "24"   "25"   "26"  
# [2,] "M"   "D"   "Y"   "SSN1" "SSN2" "SSN3"

# DOB => M, D, Y    6 => relaxed to 21, 22, 23
PM_pair2 = compare.dedup(sub_df, blockfld = list(c(2,3),c(2,21,22),c(2,21,23),c(22,23),c(2,8),c(2,9),c(2,20),c(3,21,22),c(3,21,23),c(3,22,23),c(3,8),c(3,9),c(3,20),c(21,22,8),c(21,23,8),c(22,23,8),c(21,22,9),c(21,23,9),c(22,23,9),c(21,22,20),c(21,23,20),c(22,23,20),c(8,9),c(8,20),c(9,20)), identity = Identity$iID, exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)


PM_pair2$pairs[1:5,]
dim(PM_pair2$pairs)
#[1] 2856704      15

sum(PM_pair2$pairs$is_match)
# [1] 40424 <= Positive cases

dim(PM_pair2$pairs)[1] - sum(PM_pair2$pairs$is_match)
# [1] 2816280 <= Negative cases

sum(PM_pair2$pairs$is_match) / dim(AllPos)[1]
# [1] 1


GoodPair2 = PM_pair2$pairs
outPair2 = paste(sub_df$EnterpriseID[GoodPair2$id1],",",sub_df$EnterpriseID[GoodPair2$id2],",1",sep="")
write.table(outPair2,file="tmp/all_GoodPair2.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")


GoodPair2 = PM_pair2$pairs[1:1000000,]
outPair2 = paste(sub_df$EnterpriseID[GoodPair2$id1],",",sub_df$EnterpriseID[GoodPair2$id2],",1",sep="")
write.table(outPair2,file="submit/submit086_GoodPair2a.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
# Recall 0.261751505, 57482 * 0.261751505 = 15046

GoodPair2 = PM_pair2$pairs[1:1000000+1000000,]
outPair2 = paste(sub_df$EnterpriseID[GoodPair2$id1],",",sub_df$EnterpriseID[GoodPair2$id2],",1",sep="")
write.table(outPair2,file="submit/submit087_GoodPair2b.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
# Recall 0.343585818, 57482 * 0.343585818 = 19750

GoodPair2 = PM_pair2$pairs[2000001:2856704,]
outPair2 = paste(sub_df$EnterpriseID[GoodPair2$id1],",",sub_df$EnterpriseID[GoodPair2$id2],",1",sep="")
write.table(outPair2,file="submit/submit088_GoodPair2c.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
# Recall 0.099474618, 57482 * 0.099474618 = 5718

# Check with Server: Recall is just 0.7048 (40514) => Not good enough...
# The others are the ones without DOB information, or at least one patient without DOB


###############################################3

# [1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
# [2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
# [1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"    "20"     
# [2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS" "MIDINIT"
# [1,] "21"  "22"  "23"  "24"   "25"   "26"  
# [2,] "M"   "D"   "Y"   "SSN1" "SSN2" "SSN3"

# DOB => M, D, Y      6 => relaxed to 21, 22, 23
# SSN => SSN1, 2, 3   8 => relaxed to 24, 25, 26

PM_pair3 = compare.dedup(sub_df, blockfld = list(c(2,3),c(2,21,22),c(2,21,23),c(22,23),c(2,24,25),c(2,24,26),c(2,25,26),c(2,9),c(2,20),c(3,21,22),c(3,21,23),c(3,22,23),c(3,24,25),c(3,24,26),c(3,25,26),c(3,9),c(3,20),c(21,22,24,25),c(21,22,24,26),c(21,22,25,26),c(21,23,24,25),c(21,23,24,26),c(21,23,25,26),c(22,23,24,25),c(22,23,24,26),c(22,23,25,26),c(21,22,9),c(21,23,9),c(22,23,9),c(21,22,20),c(21,23,20),c(22,23,20),c(24,25,9),c(24,26,9),c(25,26,9),c(24,25,20),c(24,26,20),c(25,26,20),c(9,20)), identity = Identity$iID, exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)


PM_pair3$pairs[1:5,]
dim(PM_pair3$pairs)
#[1] 2859199      15  (previous 2856704).  It didn't add much

sum(PM_pair3$pairs$is_match)
# [1] 40424 <= Positive cases

dim(PM_pair3$pairs)[1] - sum(PM_pair3$pairs$is_match)
# [1] 2818775 <= Negative cases

sum(PM_pair3$pairs$is_match) / dim(AllPos)[1]
# [1] 1


GoodPair3 = PM_pair3$pairs
outPair3 = paste(sub_df$EnterpriseID[GoodPair3$id1],",",sub_df$EnterpriseID[GoodPair3$id2],",1",sep="")
write.table(outPair3,file="tmp/all_GoodPair3.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")

missPair = diffPair("tmp/all_GoodPair3.csv","tmp/all_GoodPair2.csv","tmp/tmp3.csv")
write.table(missPair,file="submit/submit089_diff_GoodPair3.csv",row.names=FALSE,col.names=F,append=F,quote=F,sep=",")

# 0 percision... not good

# DOB => M, D, Y    6 => relaxed to 21, 22, 23

input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 20
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 21
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 22
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 23


# [1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
# [2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
# [1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"    "20"     
# [2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS" "MIDINIT"
# [1,] "21"  "22"  "23"  "24"   "25"   "26"  
# [2,] "M"   "D"   "Y"   "SSN1" "SSN2" "SSN3"

# DOB => M, D, Y      6 => relaxed to 21, 22, 23
# SSN => SSN1, 2, 3   8 => relaxed to 24, 25, 26

PM_pair4 = compare.dedup(input_df, blockfld = list(c(2,3),c(2,21,22),c(2,21,23),c(22,23),c(2,8),c(2,9),c(2,20),c(3,21,22),c(3,21,23),c(3,22,23),c(3,8),c(3,9),c(3,20),c(21,22,8),c(21,23,8),c(22,23,8),c(21,22,9),c(21,23,9),c(22,23,9),c(21,22,20),c(21,23,20),c(22,23,20),c(8,9),c(8,20),c(9,20)), exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)


rm(PM_pair1)
rm(PM_pair2)
rm(PM_pair3)
gc()


PM_pair4$pairs[1:5,]
dim(PM_pair4$pairs)
#[1] 2856704      15





PM_pair5 = compare.dedup(input_df, blockfld = list(c(2,3),c(2,21,22),c(2,21,23),c(22,23),c(2,8),c(2,9),c(2,20),c(3,21,22),c(3,21,23),c(3,22,23),c(3,8),c(3,9),c(3,20),c(21,22,8),c(21,23,8),c(22,23,8),c(21,22,9),c(21,23,9),c(22,23,9),c(21,22,20),c(21,23,20),c(22,23,20),c(8,9),c(8,20),c(9,20)), exclude=c(1), strcmp=TRUE, strcmpfun=levenshteinDist)








rpairs2_eW <- epiWeights(PM_pair2)
summary(rpairs2_eW)

l=splitData(dataset=rpairs2_eW, prop=0.5, keep.mprop=TRUE)
threshold=optimalThreshold(l$train)
print(threshold)
summary(epiClassify(l$valid,threshold))





CheckFileName = paste("Check_",Sys.Date(),"_",format(Sys.time(), "%H-%M-%S"), ".csv", sep="")
write.csv(t(c("FIELD",colnames(sub_df))), file = CheckFileName, row.names=FALSE,append=F, quote=F)
print(format(Sys.time(), "%H:%M:%S"))

#WriteN = length(Out)
WriteN = 10
for (i in 1:WriteN) {
    MyData = cbind(i,sub_df[c(PM_pair1$pairs$id1[i],PM_pair1$pairs$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}
print(format(Sys.time(), "%H:%M:%S"))






if(FALSE) {


# Now we need to build an identity vector

#> dim(sub_df)
#[1] 77148    19
#> length(NegID)
#[1] 3725
#> length(PosID)
save.image(input_df_clean, file="meta6/uspsAddress_RL_Identity_0728_2017.RData")
#[1] 76252

print(head(sub_df))
rbind(1:dim(sub_df)[2],colnames(sub_df))

#     [,1]           [,2]   [,3]    [,4]     [,5]     [,6]  [,7]     [,8]  [,9]       [,10]     
#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#     [,11] [,12]                 [,13] [,14]  [,15]   [,16]   [,17]    [,18]   [,19]  
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"   
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS"

PM_pair1 <- compare.dedup(sub_df, blockfld = c(2, 3, 6))  # same last name, first name, and DOB
PM_pair1$pairs[1:5,]
#> dim(PM_pair1$pairs)
#[1] 37238    31
# Submit 66, using R RecordLinkage Package, with blocking blockfld = c(2, 3, 6)   LAST, FIRST, DOB) => 37238 pairs.  Surprising 10 FP.  Apparently, data preprocessing is needed…
i = 1
sub_df[c(PM_pair1$pairs$id1[i],PM_pair1$pairs$id2[i]),]

CheckFileName = paste("Check_",Sys.Date(),"_",format(Sys.time(), "%H-%M-%S"), ".csv", sep="")
write.csv(t(c("FIELD",colnames(sub_df))), file = CheckFileName, row.names=FALSE,append=F, quote=F)

print(format(Sys.time(), "%H:%M:%S"))

#WriteN = length(Out)
#WriteN = 10
for (i in 1:WriteN) {
    MyData = cbind(i,sub_df[c(PM_pair1$pairs$id1[i],PM_pair1$pairs$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}
print(format(Sys.time(), "%H:%M:%S"))

PM_pair3 <- compare.dedup(sub_df, blockfld = c(2, 3, 6, 8))  # same last name, first name, DOB and SSN
PM_pair3$pairs[1:5,]
#> dim(PM_pair3$pairs)
#[1] 13960    31
submitFName = "submit069.csv"
Out = paste(sub_df$EnterpriseID[PM_pair3$pairs$id1],",", sub_df$EnterpriseID[PM_pair3$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


PM_pair4 <- compare.dedup(sub_df, blockfld = c(2, 3, 8))  # same last name, first name and SSN
PM_pair4$pairs[1:5,]
#> dim(PM_pair4$pairs)
#[1] 16306    31
submitFName = "submit071_LASTFIRSTSSN.csv"
Out = paste(sub_df$EnterpriseID[PM_pair4$pairs$id1],",", sub_df$EnterpriseID[PM_pair4$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


#PM_pair3_clean <- compare.dedup(sub_df, blockfld = c(2, 3, 6, 8))  # same last name, first name, DOB and SSN
#dim(PM_pair3$pairs_clean)
#[1] 13924    31

################# Now try "Clean DOB data"
PM_pair5 <- compare.dedup(sub_df, blockfld = c(2, 3, 6))
#> dim(PM_pair5$pairs)
#[1] 37238    31

length(which(PM_pair5$pairs$SSN==0))
PM_pair5_sub = PM_pair5$pairs[which(PM_pair5$pairs$SSN==0),]

submitFName = "submit072_CheckDOB.csv"
Out = paste(sub_df$EnterpriseID[PM_pair5_sub$id1],",", sub_df$EnterpriseID[PM_pair5_sub$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")

CheckFileName = paste("Check.csv",sep="")
write.csv(t(c("FIELD",colnames(sub_df))), file = CheckFileName, row.names=FALSE,append=F, quote=F)
WriteN = dim(PM_pair5_sub)[1]
for (i in 1:WriteN) {
    MyData = cbind(i,sub_df[c(PM_pair5_sub$id1[i],PM_pair5_sub$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}

PM_pair5_sub2 = PM_pair5$pairs[which(is.na(PM_pair5$pairs$SSN)),]
submitFName = "submit073_CheckDOBnull.csv"
Out = paste(sub_df$EnterpriseID[PM_pair5_sub2$id1],",", sub_df$EnterpriseID[PM_pair5_sub2$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")

PM_pair5_sub2$MRN1=""
PM_pair5_sub2$MRN2=""
PM_pair5_sub2$MRNdiff=""
for(i in 1:dim(PM_pair5_sub2)[1]) {
    PM_pair5_sub2$MRN1[i] = sub_df$MRN[PM_pair5_sub2$id1[i]]
    PM_pair5_sub2$MRN2[i] = sub_df$MRN[PM_pair5_sub2$id2[i]]
    PM_pair5_sub2$MRNdiff[i] = abs(sub_df$MRN[PM_pair5_sub2$id1[i]] - sub_df$MRN[PM_pair5_sub2$id2[i]])
}

write.csv(PM_pair5_sub2, file = "PM_pair5_sub2_CheckOneFP.csv", append = FALSE, sep = ",", row.names=F, quote=F)


#> sub_df[c(141790,742828),]
#       EnterpriseID   LAST  FIRST MIDDLE SUFFIX      DOB GENDER         SSN       ADDRESS1 ADDRESS2
#141790     12271234 MILLER ROBERT      W        5/4/1993   MALE             35 PARK AVENUE         
#742828     15205672 MILLER ROBERT   RICK        5/4/1993   MALE 864-05-7307    6720 14 AVE       1R
#         ZIP MOTHERS_MAIDEN_NAME     MRN      CITY STATE        PHONE       PHONE2 EMAIL ALIAS
#141790 11717                     3928279 BRENTWOOD    NY 929-425-5753 929-425-5753            
#742828 11219                     4516711  BROOKLYN    NY 718-924-7215                         





#######################

#if(FALSE) {

# http://rpubs.com/ahmademad/RecordLinkage
# https://journal.r-project.org/archive/2010-2/RJournal_2010-2_Sariyar+Borg.pdf
# https://cran.r-project.org/web/packages/RecordLinkage/RecordLinkage.pdf

library(RecordLinkage)
data(RLdata500)
dim(RLdata500)
# [1] 500  7
RLdata500[1:5, ]

rpairs <- compare.dedup(RLdata500, identity = identity.RLdata500)
dim(rpairs$pairs)
# [1] 124750     10

identity.RLdata500

rpairs$pairs[1:5,]

which(rpairs$pairs$is_match == 1)

rpairs$pairs[c(540,11782,16016,17369,22562),]
RLdata500[c(2,43),]
RLdata500[c(25,107),]


#      id1 id2 fname_c1 fname_c2 lname_c1 lname_c2 by bm bd is_match
#540     2  43        1       NA        0       NA  1  1  1        1
#11782  25 107        1       NA        1       NA  1  0  1        1
#16016  34 111        1       NA        0       NA  1  1  1        1
#17369  37  72        0       NA        0       NA  1  1  1        1
#22562  48 238        0       NA        1       NA  1  1  1        1


rpairs_block <- compare.dedup(RLdata500, blockfld = list(1, 5:7), identity = identity.RLdata500)

dim(rpairs_block$pairs)
pairs_block$pairs[1:4,]

#  id1 id2 fname_c1 fname_c2 lname_c1 lname_c2 by bm bd is_match
#1   1 174        1       NA        0       NA  0  0  0        0
#2   1 204        1       NA        0       NA  0  0  0        0
#3   2   7        1       NA        0       NA  0  0  0        0
#4   2  43        1       NA        0       NA  1  1  1        1

#> RLdata500[c(2,43),]
#   fname_c1 fname_c2 lname_c1 lname_c2   by bm bd
#2      GERD     <NA>    BAUER     <NA> 1968  7 27
#43     GERD     <NA>   BAUERH     <NA> 1968  7 27
#> RLdata500[c(1,174),]
#    fname_c1 fname_c2 lname_c1 lname_c2   by bm bd
#1    CARSTEN     <NA>    MEIER     <NA> 1949  7 22
#174  CARSTEN     <NA>  SCHMITT     <NA> 2001  6 27


rpairsfuzzy <- compare.dedup(RLdata500, blockfld = c(5, 6), strcmp = TRUE, identity = identity.RLdata500)
rpairsfuzzy$pairs[1:5, ]
#  id1 id2  fname_c1 fname_c2  lname_c1 lname_c2 by bm bd is_match
#1   2  43 1.0000000       NA 0.9666667       NA  1  1  1        1
#2   4 392 0.5777778       NA 0.4833333       NA  1  1  1        0
RLdata500[c(2,43),]
#   fname_c1 fname_c2 lname_c1 lname_c2   by bm bd
#2      GERD     <NA>    BAUER     <NA> 1968  7 27
#43     GERD     <NA>   BAUERH     <NA> 1968  7 27
RLdata500[c(4,392),]
#    fname_c1 fname_c2 lname_c1 lname_c2   by bm bd
#4     STEFAN     <NA>    WOLFF     <NA> 1957  9  2
#392    HELGA     <NA>     KOCH     <NA> 1957  9  2


rpairsfuzzy <- compare.dedup(RLdata500, blockfld = c(5, 6), strcmp = TRUE)
rpairsfuzzy$pairs[1:10, ]

#> jarowinkler("Andreas","Anreas")
#[1] 0.9619048
#> levenshteinSim("Andreas",c("Anreas","Andeas"))
#[1] 0.8571429 0.8571429
#> jarowinkler("Andreas",c("Anreas","Andeas"))
#[1] 0.9619048 0.9666667
#> levenshteinDist("Andreas",c("Anreas","Andeas"))
#[1] 1 1
#> levenshteinDist("Andreas","Andreas")
#[1] 0
#> levenshteinDist("Andreas","Andresa")
#[1] 2

rpairs1 <- compare.dedup(RLdata500, identity = identity.RLdata500, blockfld = c(5,6), strcmp=TRUE, strcmpfun=levenshteinSim)
rpairs1$pairs[1:10, ]

# My observation
rpairs2 <- compare.dedup(RLdata500, identity = identity.RLdata500, blockfld = c(5,6), strcmp=TRUE, strcmpfun=levenshteinDist)
rpairs2$pairs[1:10, ]

# default!
rpairs3 <- compare.dedup(RLdata500, identity = identity.RLdata500, blockfld = c(5,6), strcmp=TRUE, strcmpfun=jarowinkler)
rpairs3$pairs[1:10, ]
rpairs3_eW <- epiWeights(rpairs3)
summary(rpairs3_eW)

tail(getPairs(rpairs3_eW, 0.7, 0.6))
result <- epiClassify(rpairs3_eW, 0.7)
summary(result)

#           classification
#true status   N   P   L
#      FALSE 119   0   0
#      TRUE    0   0  38

# l=splitData(dataset=rpairs3_eW, prop=0.5, keep.mprop=TRUE)
# threshold=optimalThreshold(l$train)
# summary(epiClassify(l$valid,threshold))

threshold
#[1] 0.6578897
#           classification
#true status  N  P  L
#      FALSE 60  0  0
#      TRUE   0  0 19

# Unsupervised, not good enough
#getParetoThreshold(rpairs3_eW, quantil = 0.95, interval = c(0.6,0.7))
#[1] 0.6289449




}












