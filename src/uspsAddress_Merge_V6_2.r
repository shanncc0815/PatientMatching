rm(list=ls())

library(RecordLinkage)
options(width=100)

print(format(Sys.time(), "%H-%M-%S"))

# Merge two versions of Normalized dataset
df_V2 <- read.csv("/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_SSN_V4.csv", stringsAsFactors=FALSE)
df_V4 <- read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_clean_sub_V6.csv", stringsAsFactors=FALSE)

df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("\\.", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("-", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("\\[", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("]", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("'", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("=", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("/", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub(",", "", x)))
df_V2[,"ADDRESS2"] <- as.data.frame(sapply(df_V2[,"ADDRESS2"], function(x) gsub("#", "", x)))
df_V4[,"ADDRESS2"] <- as.data.frame(sapply(df_V4[,"ADDRESS2"], function(x) gsub("#", "", x)))

#save.image(file="meta6/uspsAddress_Merge.RData")
#load("meta6/uspsAddress_Merge.RData")

V2_idx = which(df_V2$Description == "")  # take V2 for Address
df_V2$ADDRESS1[V2_idx] = df_V2$uspsMainAddress[V2_idx]
df_V2$CITY[V2_idx] = df_V2$uspsCity[V2_idx]
df_V2$STATE[V2_idx] = df_V2$uspsState[V2_idx]
df_V2$ZIP[V2_idx] = df_V2$uspsZIP5[V2_idx]

V4_idx = which(df_V4$Description_V4 == "")
df_V4$ADDRESS1[V4_idx] = df_V4$uspsMainAddress_V4[V4_idx]
df_V4$CITY[V4_idx] = df_V4$uspsCity_V4[V4_idx]
df_V4$STATE[V4_idx] = df_V4$uspsState_V4[V4_idx]
df_V4$ZIP[V4_idx] = df_V4$uspsZIP5_V4[V4_idx]

midx = match(df_V4$EnterpriseID, df_V2$EnterpriseID)
df_V2$ADDRESS1[midx] = df_V4$ADDRESS1
df_V2$CITY[midx] = df_V4$CITY
df_V2$STATE[midx] = df_V4$STATE
df_V2$ZIP[midx] = df_V4$ZIP
df_V2$Description[midx] = df_V4$Description_V4

df_V2$uspsMainAddress = NULL
df_V2$uspsMinorAddress = NULL
df_V2$uspsCity = NULL
df_V2$uspsState = NULL
df_V2$uspsZIP = NULL
df_V2$uspsZIP5 = NULL
df_V2$uspsZIP4 = NULL

df_V4$MIDINIT = substr(df_V4$MIDDLE,1,1)  # FIELD 20
df_V4$M = sapply(strsplit(df_V4$DOB, split = "/"), function(X) X[1]) # FIELD 21
df_V4$D = sapply(strsplit(df_V4$DOB, split = "/"), function(X) X[2]) # FIELD 22
df_V4$Y = sapply(strsplit(df_V4$DOB, split = "/"), function(X) X[3]) # FIELD 23

EID = as.character(df_V2[,1])
wrongPHONE = c("5555555555","9999999999","222-222-2222","666-666-6666","777-777-7777","555-555-5555","111-111-1111","1111111111","333-333-3333","8888888888","4444444444","444-444-4444","2222222222","999-999-9999","6666666666","123-456-7890","888-888-8888","3333333333","7777777777","000-000-0000","0","1234567890")

df_V2$PHONE = as.character(df_V2$PHONE)
for(w_idx in 1:length(wrongPHONE)) {
    df_V2$PHONE[which(df_V2$PHONE == wrongPHONE[w_idx])] = ""
}

PHONE2 = sapply(strsplit(as.character(df_V2$PHONE2),split = "\\^\\^"), function(X) X[1])
PHONE3 = sapply(strsplit(as.character(df_V2$PHONE2),split = "\\^\\^"), function(X) X[2])
PHONE4 = sapply(strsplit(as.character(df_V2$PHONE2),split = "\\^\\^"), function(X) X[3])

PHONE_dict = cbind(EID, df_V2$PHONE)
PHONE_dict = rbind(PHONE_dict, cbind(EID, PHONE2))
PHONE_dict = rbind(PHONE_dict, cbind(EID, PHONE3))
PHONE_dict = rbind(PHONE_dict, cbind(EID, PHONE4))


PHONE_dict = as.data.frame(PHONE_dict[-which(PHONE_dict[,2] == ""),])
colnames(PHONE_dict) = c("EID","PHONE")
#PHONE_key = unique(PHONE_dict$PHONE)

save(PHONE_dict, file="/home/chen/workspace/git_examples/PatientMatching/meta6/PHONE_dict.RData")
#format(Sys.time(), "%H-%M-%S")
#PHONE_list = lapply(1:length(PHONE_key), function(X) as.character(PHONE_dict$EID[which(PHONE_dict$PHONE == PHONE_key[X])]))
#format(Sys.time(), "%H-%M-%S")

#for(i in 1:length(PHONE_key)) {
#  mylist[[i]] = PHONE_dict$EID[which(PHONE_dict$PHONE == PHONE_key[i])]
#}
#EMAIL = sapply(strsplit(as.character(df_V2$EMAIL),split = "@"), function(X) X[1])
#df_V2$EMAIL = ""
#df_V2$EMAIL = EMAIL

write.table(df_V2, file = "/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", row.names=F, col.names=T, sep=",")

#rm(list=ls())
input_df <- read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
input_df = input_df[,-c(20,21)]
input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

#load("meta6/RL_Identity_V1.RData"), manual version

load("/home/chen/workspace/git_examples/PatientMatching/meta6/RL_Identity_V2.RData")
match_idx = match(Identity$eID, input_df$EnterpriseID)
sub_df = input_df[match_idx,]
#save(input_df, PHONE_dict, PHONE_key, Identity, file="meta6/uspsAddress_Merge_V6_2.RData")
save.image(file="/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V6_2.RData")

print(format(Sys.time(), "%H-%M-%S"))


if(FALSE) {

df_V2 = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta6/uspsAddress_Merge_V4.csv", stringsAsFactors=FALSE)
df_V4 = df_V2[,-c(20,21)]

print(head(df_V4))
rbind(1:dim(df_V4)[2],colnames(df_V4))

#     [,1]           [,2]   [,3]    [,4]     [,5]     [,6]  [,7]     [,8]  [,9]       [,10]     
#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#     [,11] [,12]                 [,13] [,14]  [,15]   [,16]   [,17]    [,18]   [,19]  
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"   
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS"

PM_pair1 <- compare.dedup(df_V4, blockfld = c(2, 3, 6))  # same last name, first name, and DOB
PM_pair1$pairs[1:5,]
#> dim(PM_pair1$pairs)
#[1] 37238    31
# Submit 66, using R RecordLinkage Package, with blocking blockfld = c(2, 3, 6)   LAST, FIRST, DOB) => 37238 pairs.  Surprising 10 FP.  Apparently, data preprocessing is needed…
i = 1
df_V2[c(PM_pair1$pairs$id1[i],PM_pair1$pairs$id2[i]),]

CheckFileName = paste("Check_",Sys.Date(),"_",format(Sys.time(), "%H-%M-%S"), ".csv", sep="")
write.csv(t(c("FIELD",colnames(df_V2))), file = CheckFileName, row.names=FALSE,append=F, quote=F)

print(format(Sys.time(), "%H:%M:%S"))

#WriteN = length(Out)
#WriteN = 10
for (i in 1:WriteN) {
    MyData = cbind(i,df_V2[c(PM_pair1$pairs$id1[i],PM_pair1$pairs$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}
print(format(Sys.time(), "%H:%M:%S"))

PM_pair3 <- compare.dedup(df_V4, blockfld = c(2, 3, 6, 8))  # same last name, first name, DOB and SSN
PM_pair3$pairs[1:5,]
#> dim(PM_pair3$pairs)
#[1] 13960    31
submitFName = "submit069.csv"
Out = paste(df_V4$EnterpriseID[PM_pair3$pairs$id1],",", df_V4$EnterpriseID[PM_pair3$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


PM_pair4 <- compare.dedup(df_V4, blockfld = c(2, 3, 8))  # same last name, first name and SSN
PM_pair4$pairs[1:5,]
#> dim(PM_pair4$pairs)
#[1] 16306    31
submitFName = "submit071_LASTFIRSTSSN.csv"
Out = paste(df_V4$EnterpriseID[PM_pair4$pairs$id1],",", df_V4$EnterpriseID[PM_pair4$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


#PM_pair3_clean <- compare.dedup(df_V2, blockfld = c(2, 3, 6, 8))  # same last name, first name, DOB and SSN
#dim(PM_pair3$pairs_clean)
#[1] 13924    31

################# Now try "Clean DOB data"
PM_pair5 <- compare.dedup(df_V2, blockfld = c(2, 3, 6))
#> dim(PM_pair5$pairs)
#[1] 37238    31

length(which(PM_pair5$pairs$SSN==0))
PM_pair5_sub = PM_pair5$pairs[which(PM_pair5$pairs$SSN==0),]

submitFName = "submit072_CheckDOB.csv"
Out = paste(df_V4$EnterpriseID[PM_pair5_sub$id1],",", df_V4$EnterpriseID[PM_pair5_sub$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")

CheckFileName = paste("Check.csv",sep="")
write.csv(t(c("FIELD",colnames(df_V2))), file = CheckFileName, row.names=FALSE,append=F, quote=F)
WriteN = dim(PM_pair5_sub)[1]
for (i in 1:WriteN) {
    MyData = cbind(i,df_V2[c(PM_pair5_sub$id1[i],PM_pair5_sub$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}

PM_pair5_sub2 = PM_pair5$pairs[which(is.na(PM_pair5$pairs$SSN)),]
submitFName = "submit073_CheckDOBnull.csv"
Out = paste(df_V4$EnterpriseID[PM_pair5_sub2$id1],",", df_V4$EnterpriseID[PM_pair5_sub2$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")

PM_pair5_sub2$MRN1=""
PM_pair5_sub2$MRN2=""
PM_pair5_sub2$MRNdiff=""
for(i in 1:dim(PM_pair5_sub2)[1]) {
    PM_pair5_sub2$MRN1[i] = df_V2$MRN[PM_pair5_sub2$id1[i]]
    PM_pair5_sub2$MRN2[i] = df_V2$MRN[PM_pair5_sub2$id2[i]]
    PM_pair5_sub2$MRNdiff[i] = abs(df_V2$MRN[PM_pair5_sub2$id1[i]] - df_V2$MRN[PM_pair5_sub2$id2[i]])
}

write.csv(PM_pair5_sub2, file = "PM_pair5_sub2_CheckOneFP.csv", append = FALSE, sep = ",", row.names=F, quote=F)


#> df_V2[c(141790,742828),]
#       EnterpriseID   LAST  FIRST MIDDLE SUFFIX      DOB GENDER         SSN       ADDRESS1 ADDRESS2
#141790     12271234 MILLER ROBERT      W        5/4/1993   MALE             35 PARK AVENUE         
#742828     15205672 MILLER ROBERT   RICK        5/4/1993   MALE 864-05-7307    6720 14 AVE       1R
#         ZIP MOTHERS_MAIDEN_NAME     MRN      CITY STATE        PHONE       PHONE2 EMAIL ALIAS
#141790 11717                     3928279 BRENTWOOD    NY 929-425-5753 929-425-5753            
#742828 11219                     4516711  BROOKLYN    NY 718-924-7215                         





#######################

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












