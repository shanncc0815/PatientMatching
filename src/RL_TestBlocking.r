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

if(FALSE) {
# try not to exclude anything...
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(2,19),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(3,19),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(20,21,19),c(20,22,19),c(21,22,19),c(8,9),c(8,19),c(9,19))

# first, do with Identity submatrix, without exclude
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(21,22))


blocklist = list(c(21,22))
allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
sum(allPairs$pairs$is_match)
p1

##########33
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9))
allPairs2 = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
sum(allPairs2$pairs$is_match)

p1 = allPairs$pairs[which(allPairs$pairs$is_match==1),]
p2 = allPairs2$pairs[which(allPairs2$pairs$is_match==1),]
p1$idx = paste(p1$id1, p1$id2, sep="_")
p2$idx = paste(p2$id1, p2$id2, sep="_")

# sum(allPairs2$pairs$is_match)
# 40421

#> setdiff(union(p1$idx,p2$idx),p2$idx)
#[1] "38507_75867" "38693_76053" "38719_76079"

#> which(p1$id1 == 38507)
#[1] 37953
#> which(p1$id1 == 38693)
#[1] 38126
#> which(p1$id1 == 38719)
#[1] 38152

p1[c(37953,38126,38152),]
sub_df[c(38507,75867),]
sub_df[c(38693,76053),]
sub_df[c(38719,76079),]

}

# first, do with Identity submatrix, without exclude, add DOB only (can filter later), add SSN only (can filter later)
blocklist = list(c(2,3),c(2,20,21),c(2,20,22),c(2,21,22),c(2,8),c(2,9),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(8,9),c(6,7),c(7,8))

allPairs = compare.dedup(sub_df, blockfld = blocklist, exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
sum(allPairs$pairs$is_match)

myPairs <- vector("list", length = length(blocklist))
for(b_idx in 1:length(blocklist)) {
    myPairs[[b_idx]] = compare.dedup(sub_df, blockfld = blocklist[[b_idx]], exclude=1, identity=Identity[,2], strcmp=TRUE, strcmpfun=levenshteinDist)
}

save.image(file="/home/chen/workspace/git_examples/PatientMatching/meta7/RL_myPairs_0801_2017.RData")


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
    thisPair = compare.dedup(input_df, blockfld = blocklist[[b_idx]], exclude=1, strcmp=TRUE, strcmpfun=levenshteinDist)
    print(paste(format(Sys.time(), "%H:%M:%S "), b_idx, ":Block ", blockID, " ",dim(thisPair$pairs)[1], " pairs" , sep=""))
    save(thisPair, blocklist, file=paste("/home/chen/workspace/git_examples/PatientMatching/meta7/RL_Block_blockID_", blockID, ".RData", sep=""))
    rm(thisPair)
}




if(FALSE) {

#PM_pair4 = compare.dedup(input_df, blockfld = list(c(2,3),c(2,20,21),c(2,20,22),c(21,22),c(2,8),c(2,9),c(2,20),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(3,20),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(20,21,20),c(20,22,20),c(21,22,20),c(8,9),c(8,20),c(9,20)), exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)

PM_pair4 = compare.dedup(input_df, blockfld = list(c(2,3)), exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)

PM_pair4$pairs[1:5,]
dim(PM_pair4$pairs)
#[1] 2856704      15

PM_pair5 = compare.dedup(input_df, blockfld = list(c(2,20,21)), exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)

PM_pair5$pairs[1:5,]
dim(PM_pair5$pairs)
#[1] 2856704      15


PM_pair6 = compare.dedup(input_df, blockfld = list(c(2,3),c(2,20,21)), exclude=c(1,4,5,7,10,11,12,13,14,15,16,17,18,19), strcmp=TRUE, strcmpfun=levenshteinDist)

PM_pair6$pairs[1:5,]
dim(PM_pair6$pairs)
#[1] 2856704      15


save.image(PM_pair4, file="meta6/PM_pair4_0731_2017.RData")




#PM_pair5 = compare.dedup(input_df, blockfld = list(c(2,3),c(2,20,21),c(2,20,22),c(21,22),c(2,8),c(2,9),c(2,20),c(3,20,21),c(3,20,22),c(3,21,22),c(3,8),c(3,9),c(3,20),c(20,21,8),c(20,22,8),c(21,22,8),c(20,21,9),c(20,22,9),c(21,22,9),c(20,21,20),c(20,22,20),c(21,22,20),c(8,9),c(8,20),c(9,20)), exclude=c(1), strcmp=TRUE, strcmpfun=levenshteinDist)







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
#[1] 37228    31
# Submit 66, using R RecordLinkage Package, with blocking blockfld = c(2, 3, 6)   LAST, FIRST, DOB) => 37228 pairs.  Surprising 10 FP.  Apparently, data preprocessing is needed…
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
#[1] 37228    31

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
#141790     12171224 MILLER ROBERT      W        5/4/1993   MALE             35 PARK AVENUE         
#742828     15205672 MILLER ROBERT   RICK        5/4/1993   MALE 864-05-7307    6720 14 AVE       1R
#         ZIP MOTHERS_MAIDEN_NAME     MRN      CITY STATE        PHONE       PHONE2 EMAIL ALIAS
#141790 11717                     3928279 BRENTWOOD    NY 929-425-5753 929-425-5753            
#742828 11209                     4516711  BROOKLYN    NY 718-924-7205                         





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

rpairs$pairs[c(540,11782,16016,17369,21562),]
RLdata500[c(2,43),]
RLdata500[c(25,107),]


#      id1 id2 fname_c1 fname_c2 lname_c1 lname_c2 by bm bd is_match
#540     2  43        1       NA        0       NA  1  1  1        1
#11782  25 107        1       NA        1       NA  1  0  1        1
#16016  34 111        1       NA        0       NA  1  1  1        1
#17369  37  72        0       NA        0       NA  1  1  1        1
#21562  48 228        0       NA        1       NA  1  1  1        1


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
#1    CARSTEN     <NA>    MEIER     <NA> 1949  7 21
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












