rm(list=ls())

library(RecordLinkage)
options(width=100)

input_df = read.csv("meta6/uspsAddress_Merge_V6_2.csv", stringsAsFactors=FALSE)
input_df = input_df[,-c(20,21)]
input_df$ADDRESS1[which(input_df$ADDRESS1 == "219E E 121ST ST")] = "219 E 121ST ST"

#write.csv(input_df, file = "meta6/cleanDataset_1M.csv", row.names=F, quote=F)

write.csv(input_df, file = "meta6/cleanDataset_1M_withQuote.csv", row.names=F, quote=T)

