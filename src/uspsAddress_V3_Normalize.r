library(RecordLinkage)

input_df <- read.csv("/home/chen/workspace/git_examples/PatientMatching/meta3/uspsAddress_full_V2.csv")
print(head(input_df))
options(width=100)
rbind(1:28,colnames(input_df))
#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"    "20"        
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS" "ReturnText"
#[1,] "21"          "22"              "23"               "24"       "25"        "26"      "27"       "28" 
#[2,] "Description" "uspsMainAddress" "uspsMinorAddress" "uspsCity" "uspsState" "uspsZIP" "uspsZIP5" "uspsZIP4"

PM_pair1 <- compare.dedup(input_df, blockfld = c(2, 3, 6))  # same last name, first name, and DOB
PM_pair1$pairs[1:5,]
#> dim(PM_pair1$pairs)
#[1] 37238    31
# Submit 66, using R RecordLinkage Package, with blocking blockfld = c(2, 3, 6)   LAST, FIRST, DOB) => 37238 pairs.  Surprising 10 FP.  Apparently, data preprocessing is needed…

submitFName = "submit066_LASTFIRSTDOB.csv"
Out = paste(input_df$EnterpriseID[PM_pair1$pairs$id1],",", input_df$EnterpriseID[PM_pair1$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


#input_df[c(15,307933),]

input_df_clean = input_df
## all the preprocessing goes here...

#Convert to Upper Case
#input_df_clean[,-1] <- as.data.frame(sapply(input_df_clean[,-1], toupper))
# input_df$SSN[30] is a valid NA in SSN FIELD

SSNFreq = as.data.frame(table(input_df_clean$SSN))
SSNnaList = SSNFreq$Var1[which(SSNFreq$Freq > 3)][-1]

# 39 pairs with TP, need to find the rules...
#098-76-5432    23
#109-87-6543    27
#210-98-7654    22
#321-09-8765    18
#432-10-9876    29
#543-21-0987    17
#654-32-1098    27
#765-43-2109    23
#876-54-3210    22
#000-00-0001    23
#234-56-7890    19
#345-67-8901    13
#456-78-9012    20
#567-89-0123    15
#678-90-1234    22
#789-01-2345    22
#890-12-3456    19
#901-23-4567    22

# Normalize SSN
for(r_idx in 1:length(SSNnaList)) {
    input_df_clean[,"SSN"] <- as.data.frame(sapply(input_df_clean[,"SSN"], function(x) gsub(SSNnaList[r_idx], input_df$SSN[30], x)))
}



# Normalize Gender
input_df_clean[,"GENDER"] <- as.data.frame(sapply(input_df_clean[,"GENDER"], function(x) gsub("FEMALE", "F", x)))
input_df_clean[,"GENDER"] <- as.data.frame(sapply(input_df_clean[,"GENDER"], function(x) gsub("MALE", "M", x)))
input_df_clean[,"GENDER"] <- as.data.frame(sapply(input_df_clean[,"GENDER"], function(x) gsub("U", input_df_clean[36,"GENDER"], x)))


# Normalize SUFFIX
input_df_clean[,"SUFFIX"] <- as.data.frame(sapply(input_df_clean[,"SUFFIX"], function(x) gsub("SR.", "SR", x)))
input_df_clean[,"SUFFIX"] <- as.data.frame(sapply(input_df_clean[,"SUFFIX"], function(x) gsub("JR.", "JR", x)))
#table(input_df_clean[,"SUFFIX"])


# Normalize ZIP code  0=>blank
# The lowest ZIP Code is 00501, a unique ZIP Code for the Internal Revenue Service in Holtsville, NY.
# The highest ZIP Code is 99950 in Ketchikan, AK.
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("999999", input_df_clean[17,"ZIP"], x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("99999", input_df_clean[17,"ZIP"], x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("99995", input_df_clean[17,"ZIP"], x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("10000", input_df_clean[17,"ZIP"], x)))

input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("76081011", "076081011", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("65141819", "065141819", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("76422217", "076422217", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("60843751", "060843751", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("76211215", "076211215", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("88071466", "088071466", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("88334517", "088334517", x)))
input_df_clean[,"ZIP"] <- as.data.frame(sapply(input_df_clean[,"ZIP"], function(x) gsub("63792176", "063792176", x)))

# Here we only try to rescue those which can't be mapped by uspstools at the first time
ZIPLen = sapply(input_df_clean[,"ZIP"], function(x) nchar(as.character(x)))
input_df_clean[which(input_df_clean$ZIPLen <5),"ZIP"] = ""


# UNIQ: 12322916,"MIMSSEARLS","BERNADETTE C.","1138 EAST 229TH STREET","10000","","NY","","Invalid Zip Code.  "  
# UNIQ: 14580163,"GARDEN","JEANNE","462 1ST AVE","10000","N","NY","","Invalid Zip Code.  ","",NA,"","",NA,NA,NA


input_df_clean[which(input_df_clean[,"ADDRESS1"] == "TEST PATIENT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "TEST TEST TEST"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "TO BE PUT IN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U  N  D O  M  I  C  L  E"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U N D O M I C I L E"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U N D O M I C I L E D"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U N D O M I C L E"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U N K N O W N"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U UNDOMICILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UBNDOMICILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABE TO OBTAIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO GIVE INFO"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBTAIN ADDRESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBTAIN INFO"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBTAIN INFORMA"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBTAIN INTOX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TOBTAIN INF"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TOBTAIN INFORMA"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TOOBTAIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNBALT TO OBTAIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNCOMICAIL"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDMICILE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOM"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMCILE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMCILIED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMI"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICDLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIAL"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIDAL"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIDE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIDLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIELD"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICIL"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILD"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILEC"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILED INTOX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILED NY"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILED XX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILEFD"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILLED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICLID"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICLIED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMILCED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMILCES"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMILICED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMINCIL"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMINICILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMLICE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMOCILE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDONICILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK NICHOLAS AVENUE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK NICHOLAS AVE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK PUSH THROUGH FOR CASHIER"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNONW"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK UNK"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKKNOWN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKN UNABLE TO OBTAIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKN3146 86TH STREE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U-N-K-N-O-W-N"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNOWN ST"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKWNOWN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNSBLR TO OBTAIN ST"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UUUU"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "VOID"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]




# TO CHECK
#16002679,"JAMISON","ALEASHA","UNKN3146 86TH STREE","11373","QUEENS","NY","","Address Not Found.  ","",NA,"","",NA,NA,NA,"5"
#15550680,"JAMISON","ALEASHA","","11111","NY","NY","","Address Not Found.  ","",NA,"","",NA,NA,NA,"5"



input_df_clean[which(input_df_clean[,"ADDRESS1"] == "0"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "99999"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "9999999999"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "DO NOT USE THIS ACCT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "DO NOT USE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NONE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NOT GIVEN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NONE GIVEN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "DO NOT USE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NONE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NOT GIVEN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NONE GIVEN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "U"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UINK"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UK"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UKN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UKNOWN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBTAIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OPTAIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMCILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMCILLED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMECILE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILED RM5"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILIED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICLED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMOCILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK ADDRESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK UNKNOWN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNOW"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNOWN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNOWN ADDRESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNWON"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKPARENT UNAVAILABLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKWN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNOBTAINABLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNTO"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTI"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTO"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTO DEMOGRAPHICS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTO PATIENT LEFT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTO PT UNAVAILABLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "VETS HIGHWAY"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "X"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "XX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "XXX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS1"]),1,4) == "XXXX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

# assume one character => no useful information, but two characters contains some information...
ADDRESS1Len = sapply(input_df_clean[,"ADDRESS1"], function(x) nchar(as.character(x)))
input_df_clean[which(ADDRESS1Len == 1),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

#input_df_clean[which(ADDRESS1Len == 2),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
#input_df_clean[which(input_df_clean[,"ADDRESS1"] == "XXX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

# check
#12211409,"RUSSELL","KATHRYN","6302 32ND AVE","11377","WOODSIDE","NY","","Address Not Found.  ","",NA,"","",NA,NA,NA,"5"
#12903302,"RUSSELL","KATHRYN","NONE","","UNKNOWN","NY","","Invalid Zip Code.  ","",NA,"","",NA,NA,NA,""

#13138234,"MOSSBURG","JACOB","NY FOUNDLING HOME","","NONE","NY","","Invalid Zip Code.  ","",NA,"","",NA,NA,NA,""
#13011748,"MOSS","JACOB","40 RICHMAN PLZ","10453","BRONX","NY","Default address: The address you entered was found but more information is needed (such as an apartment, suite, or box number) to match to a specific address.","","40 RICHMAN PLZ",NA,"BRONX","NY",104536402,10453,6402,"5"

# TP => very very special case
#15571218,"HORNE","AUSTIN","UNK ADDRESS","","UNK","NY","","Invalid Zip Code.  ","",NA,"","",NA,NA,NA,""
#16020248,"HORNE","AUSTIN","UNK ADDRESS","","UNK","NY","","Invalid Zip Code.  ","",NA,"","",NA,NA,NA,""

#12603114,"REED","GAIL","0000 WILLIAMSBRIDGE RD","10461","BRONX","NY","","Address Not Found.  ","",NA,"","",NA,NA,NA,"5"
#12312786,"REED","JENNA","2130 WILLIAMSBRIDGE RD","10461","BRONX","NY","Default address: The address you entered was found but more information is needed (such as an apartment, suite, or box number) to match to a specific address.","","2130 WILLIAMSBRIDGE RD",NA,"BRONX","NY",104611619,10461,1619,"5"

#12734430,"WAHLER","RICHARD","426 MC DONOUGH ST","11233","BROOKLYN","NY","","","426 MACDONOUGH ST",NA,"BROOKLYN","NY",112331107,11233,1107,"5"
#12407624,"WAHLER","RICHARD","00000 NEW STRET","11235","BROOKLYN","NY","","Address Not Found.  ","",NA,"","",NA,NA,NA,"5"


input_df_clean[which(input_df_clean[,"ADDRESS1"] == "H O M E L E S S"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "HOMELESS PER OFFICER"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "HOMELESS PER POINT"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "H O  M  E  L  E  S   S"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "H.O.M.E.L.E.S.S"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "HOME LESS"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "HOMELES"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "HOMLESS"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "H-O-M-E-L-E-S-S"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PATIENT STATES HO"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STATES HOMELES"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STAATES HOMELESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STS HOMELESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STATES HOMELESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]


write.table(input_df_clean, file = "/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_SSN_V3.csv", row.names=F, col.names=T, sep=",")





#input_df_clean[,-1] <- as.data.frame(sapply(input_df_clean[,-1], function(x) gsub("[[:punct:]]", "", x)))

CheckFileName = paste(submitFName,"Check.csv",sep="")
write.csv(t(c("FIELD",colnames(input_df_clean))), file = CheckFileName, row.names=FALSE,append=F, quote=F)

#for (i in 1:dim(Out)[1)] {
print(format(Sys.time(), "%H:%M:%S"))

WriteN = length(Out)
#WriteN = 10
for (i in 1:WriteN) {
    MyData = cbind(i,input_df_clean[c(PM_pair1$pairs$id1[i],PM_pair1$pairs$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}
print(format(Sys.time(), "%H:%M:%S"))
#for (i in 1:dim(Out)[1)] {

#input_df[c(15,307933),]
#input_df[c(30,211759),]


# Normalize Address would be difficult...


# Normalize Name would be difficult...

#[1,] "1"            "2"    "3"     "4"      "5"      "6"   "7"      "8"   "9"        "10"      
#[2,] "EnterpriseID" "LAST" "FIRST" "MIDDLE" "SUFFIX" "DOB" "GENDER" "SSN" "ADDRESS1" "ADDRESS2"
#[1,] "11"  "12"                  "13"  "14"   "15"    "16"    "17"     "18"    "19"    "20"        
#[2,] "ZIP" "MOTHERS_MAIDEN_NAME" "MRN" "CITY" "STATE" "PHONE" "PHONE2" "EMAIL" "ALIAS" "ReturnText"
#[1,] "21"          "22"              "23"               "24"       "25"        "26"      "27"       "28" 
#[2,] "Description" "uspsMainAddress" "uspsMinorAddress" "uspsCity" "uspsState" "uspsZIP" "uspsZIP5" "uspsZIP4"

PM_pair3 <- compare.dedup(input_df, blockfld = c(2, 3, 6, 8))  # same last name, first name, DOB and SSN
PM_pair3$pairs[1:5,]
#> dim(PM_pair3$pairs)
#[1] 13960    31
submitFName = "submit069.csv"
Out = paste(input_df$EnterpriseID[PM_pair3$pairs$id1],",", input_df$EnterpriseID[PM_pair3$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


PM_pair4 <- compare.dedup(input_df, blockfld = c(2, 3, 8))  # same last name, first name and SSN
PM_pair4$pairs[1:5,]
#> dim(PM_pair4$pairs)
#[1] 16306    31
submitFName = "submit071_LASTFIRSTSSN.csv"
Out = paste(input_df$EnterpriseID[PM_pair4$pairs$id1],",", input_df$EnterpriseID[PM_pair4$pairs$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")


#PM_pair3_clean <- compare.dedup(input_df_clean, blockfld = c(2, 3, 6, 8))  # same last name, first name, DOB and SSN
#dim(PM_pair3$pairs_clean)
#[1] 13924    31

################# Now try "Clean DOB data"
PM_pair5 <- compare.dedup(input_df_clean, blockfld = c(2, 3, 6))
#> dim(PM_pair5$pairs)
#[1] 37238    31

length(which(PM_pair5$pairs$SSN==0))
PM_pair5_sub = PM_pair5$pairs[which(PM_pair5$pairs$SSN==0),]

submitFName = "submit072_CheckDOB.csv"
Out = paste(input_df$EnterpriseID[PM_pair5_sub$id1],",", input_df$EnterpriseID[PM_pair5_sub$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")

CheckFileName = paste("Check.csv",sep="")
write.csv(t(c("FIELD",colnames(input_df_clean))), file = CheckFileName, row.names=FALSE,append=F, quote=F)
WriteN = dim(PM_pair5_sub)[1]
for (i in 1:WriteN) {
    MyData = cbind(i,input_df_clean[c(PM_pair5_sub$id1[i],PM_pair5_sub$id2[i]),])
    write.csv(MyData, file = CheckFileName, row.names=FALSE, append=T, quote=F)
    write.csv("", file = CheckFileName, row.names=FALSE, append=T, quote=F)
}

PM_pair5_sub2 = PM_pair5$pairs[which(is.na(PM_pair5$pairs$SSN)),]
submitFName = "submit073_CheckDOBnull.csv"
Out = paste(input_df$EnterpriseID[PM_pair5_sub2$id1],",", input_df$EnterpriseID[PM_pair5_sub2$id2],",1",sep="")
write(Out, file = submitFName, append = FALSE, sep = " ")

PM_pair5_sub2$MRN1=""
PM_pair5_sub2$MRN2=""
PM_pair5_sub2$MRNdiff=""
for(i in 1:dim(PM_pair5_sub2)[1]) {
    PM_pair5_sub2$MRN1[i] = input_df_clean$MRN[PM_pair5_sub2$id1[i]]
    PM_pair5_sub2$MRN2[i] = input_df_clean$MRN[PM_pair5_sub2$id2[i]]
    PM_pair5_sub2$MRNdiff[i] = abs(input_df_clean$MRN[PM_pair5_sub2$id1[i]] - input_df_clean$MRN[PM_pair5_sub2$id2[i]])
}

write.csv(PM_pair5_sub2, file = "PM_pair5_sub2_CheckOneFP.csv", append = FALSE, sep = ",", row.names=F, quote=F)


#> input_df_clean[c(141790,742828),]
#       EnterpriseID   LAST  FIRST MIDDLE SUFFIX      DOB GENDER         SSN       ADDRESS1 ADDRESS2
#141790     12271234 MILLER ROBERT      W        5/4/1993   MALE             35 PARK AVENUE         
#742828     15205672 MILLER ROBERT   RICK        5/4/1993   MALE 864-05-7307    6720 14 AVE       1R
#         ZIP MOTHERS_MAIDEN_NAME     MRN      CITY STATE        PHONE       PHONE2 EMAIL ALIAS
#141790 11717                     3928279 BRENTWOOD    NY 929-425-5753 929-425-5753            
#742828 11219                     4516711  BROOKLYN    NY 718-924-7215                         












