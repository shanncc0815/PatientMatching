rm(list=ls())

source("Utility/Pair_Utility.r")
dir.create("tmp")

################################################
print("#####################")
print("Examine sets with at least one vote out of 200 votes")
Diff_Vote200g = diffPair("submit_sampc004/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv","submit_sampc004/pmc4_submit031_54672TP_0FP.csv","tmp/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv")

Combine_Vote200g = combinePair("submit_sampc004/pmc4_submit031_54672TP_0FP.csv","submit_sampc004/pmc4_submit035(submit034_diff_submit031)_3053Pairs_2434TP_619FP.csv","tmp/pmc4_submit034_Vote200g0_57725Pairs_57106TP_619FP.csv")

################################################
print("#####################")
print("Examine sets with consensus 200 votes")
Diff_Vote200 = diffPair("submit_sampc004/pmc4_submit036_Vote200_56275Pairs_56229TP_46FP.csv","submit_sampc004/pmc4_submit031_54672TP_0FP.csv","submit_sampc004/pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv")

Diff_Vote200 = combinePair("submit_sampc004/pmc4_submit031_54672TP_0FP.csv","submit_sampc004/pmc4_submit037(submit036_diff_submit031)_1603Pairs_1557TP_46FP.csv","tmp/pmc4_submit036_Vote200_56275Pairs_56229TP_46FP.csv")

