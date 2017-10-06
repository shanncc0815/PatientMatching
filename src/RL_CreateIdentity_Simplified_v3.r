rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

#AllPos = combinePair("../submit/AllPos.csv","../submit/PosSet009.csv","../submit/submit085_AllPos.csv")
#AllNeg = combinePair("../submit/notsubmit_AllNeg.csv","../submit/sameEMAIL_AllFP.csv","../tmp/tmp3.csv")

AllPos = read.csv("submit_sampc003/submit034_All_Pos_52452TP.csv", header=F)
AllNeg = read.csv("~/workspace/PatientMatching/tmp_submit/unsubmit_Label_false_1600TN.csv", header=F)

#dim(AllNeg)
#[1] 6310961       3

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
sub_df = input_df[,-c(20,21)]

PosID = unique(c(as.character(AllPos$V1),as.character(AllPos$V2)))
#> length(PosID)
#[1] 38892
#> dim(AllPos)  # Number of Pairs
#[1] 40424     3

NegID = unique(c(as.character(AllNeg$V1),as.character(AllNeg$V2)))
length(NegID)

PNID = unique(c(PosID, NegID))
match_idx = match(PNID, sub_df$EnterpriseID)
sub_df = sub_df[match_idx,]


Identity = sub_df[,c(1,1)]
colnames(Identity) = c("eID","iID")
Identity$iID = ""

#match(AllPos$V1[1], Identity$eID)
#match(AllPos$V2[1], Identity$eID)

print(format(Sys.time(), "%H:%M:%S"))

AllPos$iID = ""
count = 0;
#mylist <- vector("list", length = 57482)
for(i in 1:dim(AllPos)[1]) {
#N=100
#for(i in 1:N) {
  if(i == 1) {
    count = count + 1;
    AllPos$iID[i] = count;
#    mylist[[count]] = c(AllPos$V1[i], AllPos$V2[i])
    Identity$iID[match(AllPos$V1[i], Identity$eID)] = count;
    Identity$iID[match(AllPos$V2[i], Identity$eID)] = count;
  } else {
    if((Identity$iID[match(AllPos$V1[i], Identity$eID)] == "") && (Identity$iID[match(AllPos$V2[i], Identity$eID)] == "")) {
      count = count + 1;  
      AllPos$iID[i] = count;
#      mylist[[count]] = c(AllPos$V1[i], AllPos$V2[i])
      Identity$iID[match(AllPos$V1[i], Identity$eID)] = count;
      Identity$iID[match(AllPos$V2[i], Identity$eID)] = count;
    } else {
      if(Identity$iID[match(AllPos$V1[i], Identity$eID)] == "") { 
        thisID = Identity$iID[match(AllPos$V2[i], Identity$eID)] 
      } else { 
        thisID = Identity$iID[match(AllPos$V1[i], Identity$eID)]
      }
      AllPos$iID[i] = thisID;
#      mylist[[thisID]] = union(mylist[[thisID]], c(AllPos$V1[i], AllPos$V2[i]))
      Identity$iID[match(AllPos$V1[i], Identity$eID)] = thisID;
      Identity$iID[match(AllPos$V2[i], Identity$eID)] = thisID;
    }
  }
}

print(format(Sys.time(), "%H:%M:%S"))
#AllPos[1:N,]
#Identity[which(Identity$iID != ""),]

#save.image(file="meta6/uspsAddress_RL_Identity_0728_2017.RData")

Old_Identity = Identity

negIdx = which(Identity$iID == "")
Identity$iID[negIdx] = 60000+1:length(negIdx)
length(unique(Identity$iID))

save(Identity, file="/media/chen/4TB1/PatientMatching/meta9/RL_Identity_Simplified_v3.RData")

save.image(file="/media/chen/4TB1/PatientMatching/meta9/RL_Identity_Simplified_v3_WholeImage.RData")
print(format(Sys.time(), "%H:%M:%S"))



if(FALSE) {

#> length(which(Identity$iID == ""))
#[1] 896
#> a = table(Identity$iID) 
#> length(which(a == 2))
#[1] 35824
#> length(which(a == 3))
#[1] 1532
#> length(which(a == 4))
#[1] 2

#> min(as.numeric(rownames(as.data.frame(a[which(a == 3)]))))
#[1] 13


#> which(Identity$iID == 1)
#[1]     1 38892 38893 76252
#> which(Identity$iID == 2)
#[1]     2     3 38894 38895
#> count
#[1] 37358

Identity$iID[38892] = Identity$iID[76252] = 39999
Identity$iID[3]     = Identity$iID[38895] = 40000

a = table(Identity$iID) 
length(which(a == 2))
#[1] 35828
length(which(a == 3))
#[1] 1532

#> dim(AllPos)
#[1] 40424     5

#> 35828 + 1532*3
#[1] 40424

negIdx = which(Identity$iID == "")
Identity$iID[negIdx] = 40000+1:length(negIdx)

#save.image(file="meta6/uspsAddress_RL_Identity_0728_2017_v2.RData")
#load("meta6/uspsAddress_RL_Identity_0728_2017_v2.RData")

#AllPos = combinePair("submit/AllPos.csv","submit/PosSet009.csv","submit/submit085_AllPos.csv")
#AllNeg = combinePair("submit/AllNeg.csv","submit/NegSet001.csv","submit/notsubmit_AllNeg.csv")
#PosID = unique(c(as.character(AllPos$V1),as.character(AllPos$V2)))
#NegID = unique(c(as.character(AllNeg$V1),as.character(AllNeg$V2)))
#PNID = unique(c(PosID, NegID))
#match_idx = match(PNID, input_df$EnterpriseID)

#save(Identity, AllPos, AllNeg, PosID, NegID, PNID, match_idx, file = "meta6/RL_Identity_V1.RData")

save.image(file="meta6/uspsAddress_RL_Identity_0801_2017_v1_EMAIL.RData")


#PM_pair1 <- compare.dedup(sub_df, blockfld = c(2, 3, 6), identity = Identity$iID)  # same last name, first name, and DOB
#PM_pair1 = compare.dedup(sub_df, blockfld = list(c(2,3),c(2,6),c(2,8),c(3,6),c(3,8),c(6,8)), identity = Identity$iID, strcmp=TRUE, strcmpfun=levenshteinDist)

sub_df$MIDINIT = substr(sub_df$MIDDLE,1,1)

#PM_pair1 = compare.dedup(sub_df, blockfld = c(2,3,6), identity = Identity$iID, exclude=1, strcmp=TRUE, strcmpfun=levenshteinDist)
#PM_pair1$pairs[1:5,]
#sum(PM_pair1$pairs$is_match) / dim(AllPos)[1]

#PM_pair1 = compare.dedup(sub_df, blockfld = list(2,3,6,8,9,20), identity = Identity$iID, exclude=1, strcmp=TRUE, strcmpfun=levenshteinDist)
#sum(PM_pair1)
#PM_pair1$pairs[1:5,]
#sum(PM_pair1$pairs$is_match) / dim(AllPos)[1]


#     [,1]           [,2]   [,3]    [,4]     [,5]     [,6]  [,7]     [,8]  [,9]       [,10]     
#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#     [,11] [,12]                 [,13] [,14]  [,15]   [,16]   [,17]    [,18]   [,19]  
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"   
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS"


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

rpairs1_eW <- epiWeights(PM_pair1)
summary(rpairs1_eW)

l=splitData(dataset=rpairs1_eW, prop=0.5, keep.mprop=TRUE)
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












