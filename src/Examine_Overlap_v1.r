rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

input_df = read.csv("/home/chen/workspace/git_examples/PatientMatching/original-dataset/FInalDataset_1M.csv", stringsAsFactors=FALSE)
rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")
input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22

input_df$FIRST2 = substr(input_df$FIRST,1,2)
input_df$LAST2 = substr(input_df$LAST,1,2)

rbind(1:dim(input_df)[2],colnames(input_df))
format(Sys.time(), "%H-%M-%S")

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc002/submit019_Vote1000_V7F1_52592_TP.csv","/home/chen/workspace/PatientMatching/submit_sampc003/FP_Total_FP140(submit019_Vote1000_V7F1_52592_TP).csv","All_Pos_52452TP.csv")

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc002/submit020_Vote1000g0_V7F1_55553_TP.csv","All_Pos_52452TP.csv","3101_184FP.csv")

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","submit034_All_Pos_52452TP.csv","submit035_3101_324FP.csv")

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","submit034_All_Pos_52452TP.csv","submit035_3101_324FP.csv")

tmp = diffPair("submit035_3101_324FP.csv","FP_Total_FP140(submit019_Vote1000_V7F1_52592_TP).csv","submit036_2961_184FP.csv")

