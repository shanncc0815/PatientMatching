rm(list=ls())

source("/home/chen/workspace/git_examples/PatientMatching/src/Pair_Utility.r")

################################################
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit057_3139_2511TP_628FP.csv", "/home/chen/workspace/PatientMatching/submit_sampc004/pmc5_submit172_628FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc5_submit173_2511TP.csv")

tmp2 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit031_54672TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004//pmc5_submit173_2511TP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc5_submitxxx_57183TP_0FP.csv")

tmp3 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc5_submitxxx_57183TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submitxxx_Jimmy_blacklist_14TP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit278_57197TP_0FP.csv")

# python3 src/n_way_match.py --input_path submit_sampc004//pmc4_submit278_57194TP_0FP.csv --output_path submit_sampc004/pmc4_submit279_check_n_pair.csv

tmp4 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit278_57197TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit279_check_n_pair.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv")


tmp5 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc001/submit079.28_additionalPairs_Batch2_CBA_2001to2025_1TP_attempt1_15430336_15881893.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submitxxx_57256TP_0FP.csv")

tmp6 = combinePair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submitxxx_57256TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc001//submit089.28_additionalPairs_Batch2_CCA_attempt1_15622465_15900506.csv","/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submitxxx_57257TP_0FP.csv")







tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit011_Vote1000g0_V7F1_55530.csv","tmp.csv")

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit012_Vote1000_noVote_V7F1_Batch1.csv","tmp.csv")
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit013_Vote1000_noVote_V7F1_Batch2.csv","tmp.csv")

tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit014_Vote1000_noVote_V7F1_Batch3.csv","tmp.csv")
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit015_Vote1000_noVote_V7F1_Batch4.csv","tmp.csv")
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit016_Vote1000_noVote_V7F1_Batch5.csv","tmp.csv")
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit017_Vote1000_noVote_V7F1_Batch6.csv","tmp.csv")
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit018_Vote1000_noVote_V7F1_Batch7.csv","tmp.csv")
tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","submit_sampc001/submit012_examine_FN/submit019_Vote1000_noVote_V7F1_Batch8.csv","tmp.csv")


tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc001/submit079.28_additionalPairs_Batch2_CBA_2001to2025_1TP_attempt1_15430336_15881893.csv","tmp.csv")


tmp = diffPair("/home/chen/workspace/PatientMatching/submit_sampc004/pmc4_submit280_57255TP_0FP.csv","/home/chen/workspace/PatientMatching/submit_sampc001/submit089.28_additionalPairs_Batch2_CCA_attempt1_15622465_15900506.csv","tmp.csv")


100%|#############################################################################################################################| 57197/57197 [03:03<00:00, 311.86it/s]
nway matches #:  1771
all pairs # of nway matches:  5313
Pair  (15383637, 15835305) not exist!!!
Pair  (15390207, 15451938) not exist!!!
Pair  (15675195, 15959689) not exist!!!
Pair  (15391205, 15836977) not exist!!!
Pair  (15392564, 15411695) not exist!!!
Pair  (15394221, 15735913) not exist!!!
Pair  (15503394, 15642450) not exist!!!
Pair  (15397964, 15544784) not exist!!!
Pair  (15506416, 15630567) not exist!!!
Pair  (15530613, 15613924) not exist!!!
Pair  (15572662, 15887981) not exist!!!
Pair  (15424079, 15451092) not exist!!!
Pair  (15425029, 15456027) not exist!!!
Pair  (15425755, 16023558) not exist!!!
Pair  (15430063, 15770632) not exist!!!
Pair  (15716734, 15805164) not exist!!!
Pair  (15826511, 15918143) not exist!!!
Pair  (15439242, 15921093) not exist!!!
Pair  (15734951, 15990252) not exist!!!
Pair  (15897378, 15941823) not exist!!!
Pair  (15463332, 15877009) not exist!!!
Pair  (15465858, 16014744) not exist!!!
Pair  (15467402, 15481204) not exist!!!
Pair  (15468097, 15850645) not exist!!!
Pair  (15474271, 15773946) not exist!!!
Pair  (15475511, 15712995) not exist!!!
Pair  (15530514, 15689682) not exist!!!
Pair  (15486115, 16003346) not exist!!!
Pair  (15664284, 16024723) not exist!!!
Pair  (15489382, 15577987) not exist!!!
Pair  (15798408, 15895819) not exist!!!
Pair  (15502851, 15677115) not exist!!!
Pair  (15700737, 15923001) not exist!!!
Pair  (15512498, 15677022) not exist!!!
Pair  (15591251, 15835280) not exist!!!
Pair  (15521531, 15936113) not exist!!!
Pair  (15523092, 15620176) not exist!!!
Pair  (15526019, 15583884) not exist!!!
Pair  (15532624, 15839286) not exist!!!
Pair  (15541501, 15751973) not exist!!!
Pair  (15543065, 15582677) not exist!!!
Pair  (15553566, 15714346) not exist!!!
Pair  (15658301, 15806848) not exist!!!
Pair  (15748555, 15987626) not exist!!!
Pair  (15619684, 15924434) not exist!!!
Pair  (15584615, 15716967) not exist!!!
Pair  (15590810, 15614930) not exist!!!
Pair  (15599316, 15608288) not exist!!!
Pair  (15624938, 15729496) not exist!!!
Pair  (15633032, 15638462) not exist!!!
Pair  (15638467, 15857298) not exist!!!
Pair  (15650737, 15937637) not exist!!!
Pair  (15694014, 15889591) not exist!!!
Pair  (15702742, 15739790) not exist!!!
Pair  (15706202, 15803009) not exist!!!
Pair  (15749512, 15831380) not exist!!!
Pair  (15794663, 15967612) not exist!!!
Pair  (15963384, 15968976) not exist!!!
[[15383637, 15835305], [15390207, 15451938], [15675195, 15959689], [15391205, 15836977], [15392564, 15411695], [15394221, 15735913], [15503394, 15642450], [15397964, 15544784], [15506416, 15630567], [15530613, 15613924], [15572662, 15887981], [15424079, 15451092], [15425029, 15456027], [15425755, 16023558], [15430063, 15770632], [15716734, 15805164], [15826511, 15918143], [15439242, 15921093], [15734951, 15990252], [15897378, 15941823], [15463332, 15877009], [15465858, 16014744], [15467402, 15481204], [15468097, 15850645], [15474271, 15773946], [15475511, 15712995], [15530514, 15689682], [15486115, 16003346], [15664284, 16024723], [15489382, 15577987], [15798408, 15895819], [15502851, 15677115], [15700737, 15923001], [15512498, 15677022], [15591251, 15835280], [15521531, 15936113], [15523092, 15620176], [15526019, 15583884], [15532624, 15839286], [15541501, 15751973], [15543065, 15582677], [15553566, 15714346], [15658301, 15806848], [15748555, 15987626], [15619684, 15924434], [15584615, 15716967], [15590810, 15614930], [15599316, 15608288], [15624938, 15729496], [15633032, 15638462], [15638467, 15857298], [15650737, 15937637], [15694014, 15889591], [15702742, 15739790], [15706202, 15803009], [15749512, 15831380], [15794663, 15967612], [15963384, 15968976]]
Done!

