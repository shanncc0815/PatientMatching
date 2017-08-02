library(RecordLinkage)

print("=== Begin of Normalization===")
print(Sys.time())

input_df_clean = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_SSN_V3.csv", stringsAsFactors=FALSE)
if(which(is.na(input_df_clean$EnterpriseID))) {
    input_df_clean = input_df_clean[-which(is.na(input_df_clean$EnterpriseID)),]
}

ADDRESS1Len = sapply(input_df_clean[,"ADDRESS1"], function(x) nchar(as.character(x)))
## Normalize Gender
##input_df_clean[,"GENDER"] <- as.data.frame(sapply(input_df_clean[,"GENDER"], function(x) gsub("FEMALE", "F", x)))

input_df_clean[,"ADDRESS1"] = as.character(input_df_clean[,"ADDRESS1"])
input_df_clean[,"ADDRESS2"] = as.character(input_df_clean[,"ADDRESS2"])
input_df_clean[,"STATE"] = as.character(input_df_clean[,"STATE"])
input_df_clean[,"CITY"] = as.character(input_df_clean[,"CITY"])

input_df_clean[which(ADDRESS1Len == 1),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(ADDRESS1Len == 2),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PATIENT STATES HO"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STATES HOMELES"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STAATES HOMELESS"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STS HOMELESS"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT STATES HOMELESS"),"ADDRESS1"] = input_df_clean[276,"ADDRESS1"]

input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub(" PLS", " PLAINS", x)))
input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub(" CTR", " CENTER", x)))
input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub("CONNETICUT", "CONNECTICUT", x)))

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "99999 XXX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "ANY"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "ANY ADDRESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "BAD ADDRESS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UN UN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBATIN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNABLE TO OBTIAN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UND"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMILCIED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTO RFUZED TO GIVE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS1"]),1,4) == "0000"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UCP INDIANHEAD ROAD"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UTO PT WALKED OUT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "TRANSITIONAL LIVING"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNDOMICILLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UDOMICILED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNOWNIN POLICE CUSTOD"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NO ENGLISH"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NO INFO ON POINT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NOT AVAILABLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NOT PT REAL NAME 3054101"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PO BOX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "POBOX"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NONE OBTIAN"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS1"]),1,5) == "99999"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "BELLEVUE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "BIGZ52 GMAIL COM"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "HOMELESSPER PSYCH"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "LAB"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NAME STREET"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NO EMAIL"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "NONE AS PER SCPD"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PATIENT LEFT POST TRIAGE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PENDING"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PILGRIM STATE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT DOES NOT REMEMBER"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT DOESNT KNOW WHERE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT WALK OUT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNCONCIOUS"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNK BY POINT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]


idx_BROOKLYN = which(input_df_clean[,"ADDRESS1"] == "UNKNOWN BROOKLYN")
input_df_clean[idx_BROOKLYN,"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[idx_BROOKLYN,"CITY"] = "BROOKLYN"
input_df_clean[idx_BROOKLYN,"STATE"] = "NY"

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "UNKNOWN POINT WALKED OUT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "WALK OUT NO INFO OBTAINED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS1"]),1,5) == "M0000"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS1"]),1,12) == "PT NO ANSWER"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS1"]),1,9) == "PT REFUSE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT NOT AVAILABLE"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PT WALKED OUT"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "PTWALKED OUT AFTER TRIA"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "RESIDENTIAL CHALLENGED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "REVISED"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "SDF"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "RICHJR GMAIL COM"),"ADDRESS1"] = input_df_clean[17,"ADDRESS1"]
input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub("WHT PLNS", "WHITE PLAINS", x)))
input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub("/", "", x)))
input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub("AVENUE", "AVE", x)))


# Aug-00
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),4,15) == "-00"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("\\.", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("-", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("\\[", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("]", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("'", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("=", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub("/", "", x)))
input_df_clean[,"ADDRESS2"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS2"], function(x) gsub(",", "", x)))


input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),1,3) == "000") ,"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "X"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "XX"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "XXX"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "XXXX"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

input_df_clean[which(input_df_clean[,"ADDRESS2"] == "OO"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "UNK"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "0"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "?"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "???"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "/"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

input_df_clean[which(input_df_clean[,"ADDRESS2"] == "12.5"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "#NAME?"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "..."),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "...X"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "1 00 AM"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "#"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "--"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "2 00 AM"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

#input_df_clean[which(input_df_clean[,"ADDRESS2"] == "0 08333334"),"ADDRESS2"] = "008333334"
#input_df_clean[which(input_df_clean[,"ADDRESS2"] == "0 04166667"),"ADDRESS2"] = "004166667"



idx140 = which(input_df_clean[,"ADDRESS1"] == "1410 EAST AVE2A")
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1410 EAST AVE2A"),"ADDRESS2"] = "2A"
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1410 EAST AVE2A"),"ADDRESS1"] = "1410 EAST AVE"
# TP: cat uspsAddress_SSN_V3.csv | cut -f1,2,3,8,9,10,14,15- -d "," | grep "1410 EAST AVENUE"
# 15796304,"MARSHALL","ALLISON","","1410 EAST AVENUE2A","0 08333334","BRONX","NY","718-946-3759","718-946-3759","","","","Address Not Found.  ","",NA,"","",NA,NA,NA
# 15991983,"MARSHALL","BROOKE","808-14-7707","1410 EAST AVENUE","2A","BRONX","NY","718-946-3759","718-946-3759","","","Default address: The address you entered was found but more information is needed (such as an apartment, suite, or box number) to match to a specific address.","","1410 EAST AVE",NA,"BRONX","NY",104627513,10462,7513

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1 LEFRAK PLAZA"),"ADDRESS2"] = ""
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1 LEFRAK PLAZA"),"ADDRESS1"] = "1 LEFRAK CITY PLAZA"

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1 LEFRAK PLZ"),"ADDRESS2"] = ""
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1 LEFRAK PLZ"),"ADDRESS1"] = "1 LEFRAK CITY PLAZA"

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1370NEWYORK"),"ADDRESS2"] = ""
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1370NEWYORK"),"ADDRESS1"] = "1370 NEW YORK AVE"

input_df_clean[which(input_df_clean[,"ADDRESS2"] == "S"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "X14"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "X9"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
input_df_clean[which(input_df_clean[,"ADDRESS2"] == "XE"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

# NEGATIVE VALUE
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),1,1) == "-"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

# 5:00 AM
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),2,2) == ":"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

# 10:00 AM
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),3,3) == ":"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

# 0.04...  These information are actually useful
#input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),1,3) == "0.0"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

# 1.00E+10
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),1,3) == "1.0"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]
# 2.00E+08
input_df_clean[which(substr(as.character(input_df_clean[,"ADDRESS2"]),1,3) == "2.0"),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]

# 3-Jan
Month = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
input_df_clean[which(sapply(as.character(input_df_clean[,"ADDRESS2"]), function(x) substr(x,nchar(x)-2,nchar(x))) %in% Month),"ADDRESS2"] = input_df_clean[17,"ADDRESS2"]


input_df_clean[which(substr(as.character(input_df_clean[,"CITY"]),1,5) == "99999"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(substr(as.character(input_df_clean[,"CITY"]),1,9) == "100000000"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(substr(as.character(input_df_clean[,"CITY"]),1,1) == "X"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "BX"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"CITY"] == "BX NY"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"CITY"] == "BKLYN"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "SUNY @ SB"),"CITY"] = "STONY BROOK"
input_df_clean[which(input_df_clean[,"CITY"] == "SUNY AT STONY B"),"CITY"] = "STONY BROOK"
input_df_clean[which(input_df_clean[,"CITY"] == "CITYNAME"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "HOMELESS"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNKNOWN"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNK"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "NONE"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "NY"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "NO INFOR OBTAINED"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "TRANS # ABOVE"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "0000{000000"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "."),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "/"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == ";"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "ZZZZ"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "U"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UK"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UN"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNDOMICILED"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UTO"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UTI"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNK,UNK"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "USR"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNKN"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNKNWON"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNJ"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNKNONW"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[which(input_df_clean[,"CITY"] == "UNK NY"),"CITY"] = input_df_clean[17,"CITY"]
input_df_clean[,"CITY"] <- as.data.frame(sapply(input_df_clean[,"CITY"], function(x) gsub("WHT PLNS", "WHITE PLAINS", x)))
input_df_clean[which(input_df_clean[,"CITY"] == "YORKTOWN HGTS"),"CITY"] = "YORKTOWN HEIGHTS"
input_df_clean[which(input_df_clean[,"CITY"] == "NEW YORK'"),"CITY"] = "NEW YORK"
input_df_clean[which(input_df_clean[,"CITY"] == "NEW YORK,NY"),"CITY"] = "NEW YORK"
input_df_clean[which(input_df_clean[,"CITY"] == "NEW YORK CITY"),"CITY"] = "NEW YORK"
input_df_clean[which(input_df_clean[,"CITY"] == "NEWYORK"),"CITY"] = "NEW YORK"
input_df_clean[which(input_df_clean[,"CITY"] == "STATEN ISLA"),"CITY"] = "STATEN ISLAND"
input_df_clean[which(input_df_clean[,"CITY"] == "STATENISLAND"),"CITY"] = "STATEN ISLAND"
input_df_clean[which(input_df_clean[,"CITY"] == "MT.VERNON"),"CITY"] = "MOUNT VERNON"
input_df_clean[which(input_df_clean[,"CITY"] == "MT. VERNON"),"CITY"] = "MOUNT VERNON"
input_df_clean[which(input_df_clean[,"CITY"] == "ASTORA"),"CITY"] = "ASTORIA"

############ Added 7.27.2017
input_df_clean[which(input_df_clean[,"CITY"] == "FAR ROCK"),"CITY"] = "FAR ROCKAWAY"
#MORICHES_idx = which(input_df_clean[,"CITY"] == "C. MORICHES")
#input_df_clean[MORICHES_idx,"CITY"] = "CTR MORICHES"

input_df_clean[which(input_df_clean[,"EnterpriseID"] == "14620992"),"STATE"] = "NY"
# 14620992,"ROSWELL","SCOTT","8/11/1932","815-62-0334","1239 STANLEY AVE","3C","BKLYN",""

input_df_clean[which(input_df_clean[,"EnterpriseID"] == "14962564"),"CITY"] = "JACKSON HTS"
# 14962564,"BARNES","CHRISTOPHER","8/15/1985","822-25-9529","3705 88 ST","A3","JACKSON","NY","212-469-3183"


#input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1748 RESEVOIR AVEUNE"),"ADDRESS1"] = "1748 RESEVOIR AVE"

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1180 GERALD AVE"),"ADDRESS1"] = "1180 GERARD AVE"
# 12466691,"ALVAREZ","DEREK","1/7/1945","","1180 GERALD AVE","32C","BX","NY"
# 12545070,"ROBLESAGUILAR","ORLANDO","9/27/1934","863-26-6281","1180 GERALD AVE","32C","BX","NY"
# 12751637,"MCDOUGALL","MARIANN","","834-54-5478","1180 GERALD AVE","S2","BRONX","NY"

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1481 WASLINGTON AVE"),"ADDRESS1"] = "1481 WASHINGTON AVE"
input_df_clean[which(input_df_clean[,"CITY"] == "BX NEW YORK"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"CITY"] == "LAKE RONKON"),"CITY"] = "LAKE RONKONKOMA"
input_df_clean[which(input_df_clean[,"CITY"] == "HEMSTEAD"),"CITY"] = "HEMPSTEAD"
input_df_clean[which(input_df_clean[,"CITY"] == "BRONX,N.Y."),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"CITY"] == "BRONX NY"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"CITY"] == "BRONXLYN"),"CITY"] = "BRONX"

#input_df_clean[which(input_df_clean[,"ADDRESS1"] == "99 STMARY ST"),"ADDRESS1"] = "99 ST MARY ST"
input_df_clean[which(input_df_clean[,"CITY"] == "STATENISLE"),"CITY"] = "STATEN ISLAND"
input_df_clean[which(input_df_clean[,"CITY"] == "SI"),"CITY"] = "STATEN ISLAND"

input_df_clean[which(input_df_clean[,"CITY"] == "BKLYUN"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "BKLN"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "BKLNY"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "BKLY"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "BK"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "BKLYNM"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "BKLYNORK"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"CITY"] == "NEW YORK NY 100"),"CITY"] = "NEW YORK"
input_df_clean[which(input_df_clean[,"CITY"] == "JAMICIA"),"CITY"] = "JAMAICA"
input_df_clean[which(input_df_clean[,"CITY"] == "JAM"),"CITY"] = "JAMAICA"
input_df_clean[which(input_df_clean[,"CITY"] == "BROOKLYN NY 112"),"CITY"] = "BROOKLYN"

#input_df_clean[which(input_df_clean[,"CITY"] == ""),"CITY"] = ""

input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1299 GRAND CON"),"ADDRESS1"] = "1299 GRAND CONCOURSE"
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1299 GRAND CONC"),"ADDRESS1"] = "1299 GRAND CONCOURSE"
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "1670 SEWARS AVE"),"ADDRESS1"] = "1670 SEWARD AVE"
input_df_clean[which(input_df_clean[,"ADDRESS1"] == "206 DAIRYLANE"),"ADDRESS1"] = "206 DAIRY LN"
#input_df_clean[which(input_df_clean[,"ADDRESS1"] == "147 INGELWOOD AVE"),"ADDRESS1"] = "147 ENGELWOOD AVE"
input_df_clean[,"ADDRESS1"] <- as.data.frame(sapply(input_df_clean[,"ADDRESS1"], function(x) gsub("INGELWOOD", "ENGELWOOD", x)))

input_df_clean[which(input_df_clean[,"EnterpriseID"] == "14889094"),"ZIP"] = "10455"
input_df_clean[which(input_df_clean[,"EnterpriseID"] == "14330738"),"ZIP"] = "10432"
input_df_clean[which(input_df_clean[,"EnterpriseID"] == "12207151"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"EnterpriseID"] == "12239022"),"CITY"] = "JACKSON HTS"
#input_df_clean[which(input_df_clean[,"EnterpriseID"] == "13064832"),"ADDRESS1"] = "830 PASSIAC AVE"
input_df_clean[which(input_df_clean[,"EnterpriseID"] == "15261390"),"STATE"] = "NY"


input_df_clean[which(input_df_clean[,"CITY"] == "COPIAGE"),"CITY"] = "COPIAGUE"
input_df_clean[which(input_df_clean[,"CITY"] == "SWAKE,LAKE"),"CITY"] = "SWAN LAKE"
input_df_clean[which(input_df_clean[,"CITY"] == "SWANLAKE"),"CITY"] = "SWAN LAKE"
input_df_clean[which(input_df_clean[,"CITY"] == "ROCKAWAY"),"CITY"] = "FAR ROCKAWAY"
input_df_clean[which(input_df_clean[,"CITY"] == "BLOOMING"),"CITY"] = "BLOOMING GROVE"
input_df_clean[which(input_df_clean[,"CITY"] == "LIC"),"CITY"] = "LONG ISLAND CITY"
input_df_clean[which(input_df_clean[,"CITY"] == "L.I. CITY"),"CITY"] = "LONG ISLAND CITY"
#input_df_clean[which(input_df_clean[,"CITY"] == "INGELWOOD"),"CITY"] = "ENGELWOOD"
input_df_clean[,"CITY"] <- as.data.frame(sapply(input_df_clean[,"CITY"], function(x) gsub("INGELWOOD", "ENGELWOOD", x)))
input_df_clean[which(input_df_clean[,"CITY"] == "STOUDSBURG"),"CITY"] = "STROUDSBURG"
input_df_clean[which(input_df_clean[,"CITY"] == "DO NOT USE THIS ACCT"),"CITY"] = ""
input_df_clean[which(input_df_clean[,"CITY"] == "NOT GIVEN"),"CITY"] = ""

input_df_clean[which(input_df_clean[,"CITY"] == "SUNY"),"CITY"] = "STONYBROOK"
input_df_clean[which(input_df_clean[,"CITY"] == "SUNY @ S/B"),"CITY"] = "STONYBROOK"
input_df_clean[which(input_df_clean[,"CITY"] == "SUNY AT SB"),"CITY"] = "STONYBROOK"
input_df_clean[which((input_df_clean[,"CITY"] == "MAN") * (input_df_clean[,"STATE"] == "NH") == TRUE),"CITY"] = "MANCHESTER"
input_df_clean[which((input_df_clean[,"CITY"] == "MAN") * (input_df_clean[,"STATE"] == "NY") == TRUE),"CITY"] = "NEW YORK"
input_df_clean[which(input_df_clean[,"CITY"] == "CONNETICUT"),"CITY"] = "CONNECTICUT"

input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "NJ") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "N.J.") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "NEW JERSEY CITY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "NEW  JERSEY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "NEW JERESY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "NEW JERSESY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NJ") * (input_df_clean[,"CITY"] == "NEW JESEY") == TRUE),"CITY"] = "NEW JERSEY"

input_df_clean[which((input_df_clean[,"STATE"] == "NY") * (input_df_clean[,"CITY"] == "NEW JERCY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NY") * (input_df_clean[,"CITY"] == "NJ") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NY") * (input_df_clean[,"CITY"] == "NJ NEW YORK") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NY") * (input_df_clean[,"CITY"] == "NEWJERSY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NY") * (input_df_clean[,"CITY"] == "NEW,JERSY") == TRUE),"CITY"] = "NEW JERSEY"
input_df_clean[which((input_df_clean[,"STATE"] == "NY") * (input_df_clean[,"CITY"] == "N") == TRUE),"CITY"] = "NEW JERSEY"

############ Added 7.27.2017



input_df_clean[which(input_df_clean[,"STATE"] == "UN"),"STATE"] = input_df_clean[17,"STATE"]


input_df_clean[which(input_df_clean[,"STATE"] == "BROOKLYN"),"CITY"] = "BROOKLYN"
input_df_clean[which(input_df_clean[,"STATE"] == "BROOKLYN"),"ZIP"] = ""
input_df_clean[which(input_df_clean[,"STATE"] == "BROOKLYN"),"STATE"] = "NY"

input_df_clean[which(input_df_clean[,"STATE"] == "ELMHURST"),"CITY"] = "FLUSHING"
input_df_clean[which(input_df_clean[,"STATE"] == "ELMHURST"),"ZIP"] = ""
input_df_clean[which(input_df_clean[,"STATE"] == "ELMHURST"),"STATE"] = "NY"

input_df_clean[which(input_df_clean[,"STATE"] == "BRONX"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"STATE"] == "BRONX"),"ZIP"] = ""
input_df_clean[which(input_df_clean[,"STATE"] == "BRONX"),"STATE"] = "NY"

input_df_clean[which(input_df_clean[,"CITY"] == "000{0000000"),"CITY"] = ""
input_df_clean[which(input_df_clean[,"CITY"] == "1180006"),"MRN"] = "1180006"
input_df_clean[which(input_df_clean[,"CITY"] == "1180006"),"ADDRESS2"] = "2S"
input_df_clean[which(input_df_clean[,"CITY"] == "1180006"),"PHONE"] = "610-980-5624"
input_df_clean[which(input_df_clean[,"CITY"] == "1180006"),"ZIP"] = "10454"
input_df_clean[which(input_df_clean[,"CITY"] == "1180006"),"STATE"] = "NY"
input_df_clean[which(input_df_clean[,"CITY"] == "1180006"),"CITY"] = "BRONX"


input_df_clean[which(input_df_clean[,"CITY"] == "7RONX"),"CITY"] = "BRONX"
input_df_clean[which(input_df_clean[,"CITY"] == "11730"),"STATE"] = "NY"
input_df_clean[which(input_df_clean[,"CITY"] == "11730"),"CITY"] = "EAST ISLIP"
input_df_clean[which(input_df_clean[,"CITY"] == "0"),"CITY"] = ""
input_df_clean[which(input_df_clean[,"CITY"] == "252 WHITTIER DR"),"CITY"] = ""
input_df_clean[which(input_df_clean[,"CITY"] == "1.00E+15"),"CITY"] = ""


print("=== End of Normalization===")
print(Sys.time())
save(input_df_clean, file="meta4/uspsAddress_SSN_V4_Normalize.RData")


# Remove two useless columns
input_df_clean$uspsMinorAddress = NULL
input_df_clean$uspsZIP4 = NULL

#################################

write.table(input_df_clean, file = "/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_SSN_V4.csv", row.names=F, col.names=T, sep=",")

#input_df_clean = read.csv("/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_SSN_V4.csv", stringsAsFactors=TRUE)

# 13538540  Line 35726, with additional line for some reason...
input_df_clean_sub = input_df_clean[which(input_df_clean$uspsMainAddress == ""),]
write.table(input_df_clean_sub, file = "/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_clean_sub_V4.csv", row.names=F, col.names=T, sep=",")




