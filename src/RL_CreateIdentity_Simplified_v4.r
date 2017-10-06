rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

#AllPos = combinePair("../submit/AllPos.csv","../submit/PosSet009.csv","../submit/submit085_AllPos.csv")
#AllNeg = combinePair("../submit/notsubmit_AllNeg.csv","../submit/sameEMAIL_AllFP.csv","../tmp/tmp3.csv")

AllPos = read.csv("~/workspace/PatientMatching/submit_sampc003/pmc3_submit047_All_Pos_52462TP.csv", header=F)
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

save(Identity, file="/media/chen/4TB1/PatientMatching/meta11/RL_Identity_Simplified_v4.RData")

save.image(file="/media/chen/4TB1/PatientMatching/meta11/RL_Identity_Simplified_v4_WholeImage.RData")
print(format(Sys.time(), "%H:%M:%S"))














