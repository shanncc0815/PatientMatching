rm(list=ls())

library(RecordLinkage)
options(width=100)

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

library(RecordLinkage)
options(width=100)
#load("/media/chen/4TB1/PatientMatching/meta9/RL_myPairs_jarowinkler_V9.RData")


input_df = read.csv("meta6/cleanDataset_1M.csv", stringsAsFactors=FALSE)



#input_df = input_df[,-c(20,21)]
input_df$PHONE2 = NULL
input_df$MIDINIT = substr(input_df$MIDDLE,1,1)  # FIELD 19
input_df$M = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[1]) # FIELD 20
input_df$D = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[2]) # FIELD 21
input_df$Y = sapply(strsplit(input_df$DOB, split = "/"), function(X) X[3]) # FIELD 22


#tmp1 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit029_Vote200.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","tmp.csv")

## [1] "allPair file /home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit029_Vote200.csv (56306 pairs), set1Pair file /home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit028_AllPos_54672TP.csv (54672 pairs), common 54672 pairs, additional 1604 pairs are stored in tmp.csv"

#tmp1 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit029_Vote200.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit033(submit032_diff_submit031)_1604Pairs_1557TP_47FP.csv")

#tmp1 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit033(submit032_diff_submit031)_1604Pairs_1557TP_47FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit032_Vote200_56276Pairs_56229TP_47FP.csv")

################################################
tmp2 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit030_Vote200g0.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","tmp.csv")

#[1] "allPair file /home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit030_Vote200g0.csv (57758 pairs), set1Pair file /home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit028_AllPos_54672TP.csv (54672 pairs), common 54672 pairs, additional 3053 pairs are stored in tmp.csv"

tmp2 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit030_Vote200g0.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv")

tmp2 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv")

################################################

tmp3 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit029_Vote200_clean.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","tmp.csv")

# [1] "allPair file /home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit029_Vote200.csv (56306 pairs), set1Pair file /home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit028_AllPos_54672TP.csv (54672 pairs), common 54672 pairs, additional 1604 pairs are stored in tmp.csv"

tmp3 = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit029_Vote200_clean.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv")

tmp3 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit036_Vote200_56275Pairs_56229TP_46FP.csv")

