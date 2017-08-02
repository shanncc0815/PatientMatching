# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA


# Step 0: Exploratory Analysis to examine basic statics of each field
#python3 src/ExploratoryAnalysis.py original-dataset/FInalDataset_1M.csv meta0

# Step 1: Normalize V1: Gender, Suffix, ZIP and usps Address.
#python3 src/Normalize_V1_Gender_Suffix_ZIP_uspsAddress.py original-dataset/FInalDataset_1M.csv meta1

# Step 2: Normalize V2: use usps webtool to normalize Address, results stored in meta2
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 0 1000000 meta2

## This step can be subdivided into smaller jobs.
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 0 250000 meta2 &
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 250000 500000 meta2 &
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 500000 750000 meta2 &
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 750000 1000000 meta2 &


# Step 3: Merge V2: combine Normalize V2 results and examine next steps, output meta3/uspsAddress_full_V2.csv
#python3 src/Merge_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv meta2 meta3
#python3 src/ExploratoryAnalysis.py meta3/uspsAddress_full_V2.csv meta3


# Step 4: Match V2: For each DOB group, find the same or similar FIRST, LAST NAME pair
# python3 src/Match_V2_DOBLASTFIRST.py meta3/uspsAddress_full_V2.csv submit

#python3 src/Match_V2_DOB345LASTFIRST.py meta3/uspsAddress_full_V2_normalizeName.csv submit
#python3 src/Generate_AllPAir_DOB_3to63.py meta3/uspsAddress_full_V2_normalizeName.csv DOBsubmitA
#python3 src/Generate_AllPair_SSN.py meta3/uspsAddress_full_V2_normalizeName.csv SSNsubmit
#python3 src/Generate_AllPair_EMAIL.py original-dataset/FInalDataset_1M.csv EMAILsubmit

#cp DOBsubmit/sameDOB_FREQ03.csv submit/submit017.csv
#cp DOBsubmit/sameDOB_FREQ04.csv submit/submit021.csv  # skip submit018.csv - something wrong there
#cp DOBsubmit/sameDOB_FREQ05.csv submit/submit022.csv
#cat DOBsubmit/*.csv > submit/submit023.csv  file too large
#cp DOBsubmit/sameDOB_FREQ06.csv submit/submit023.csv
#cp DOBsubmit/sameDOB_FREQ07.csv submit/submit024.csv
#cp DOBsubmit/sameDOB_FREQ08.csv submit/submit025.csv
#cp DOBsubmit/sameDOB_FREQ09.csv submit/submit026.csv
#cp DOBsubmit/sameDOB_FREQ10.csv submit/submit027.csv

# Normalize ADDRESS1, CITY, STATE and many other fields
# input: meta3/uspsAddress_full_V2.csv  output: meta4/uspsAddress_SSN_V3.csv
Rscript src/uspsAddress_V3_Normalize.r

# input: meta4/uspsAddress_SSN_V3.csv  output: meta4/uspsAddress_SSN_V4.csv   meta4/uspsAddress_clean_sub_V4.csv  meta4/uspsAddress_SSN_V4_Normalize.RData
Rscript src/uspsAddress_V4_Normalize.r

# Run uspsWebtool with updated information, results stored in meta5
# python3 src/Normalize_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv 0 5  meta5 &
python3 src/Normalize_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv 0 40000  meta5 &
python3 src/Normalize_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv 40000 80000  meta5 &
python3 src/Normalize_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv 80000 120000  meta5 &
python3 src/Normalize_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv 120000 160000  meta5 &
python3 src/Normalize_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv 160000 190000 meta5 &

# Merge V4: combine normalized results from usps webtool => output as meta6/uspsAddress_clean_sub_V6.csv
python3 src/Merge_V4_uspsWebtool.py meta4/uspsAddress_clean_sub_V4.csv meta5 meta6

# Create Identity matrix, 
Rscript src/RL_CreateIdentity_v1.r
Rscript src/RL_CreateIdentity_EMAIL_v2.r

# Merge V6: combine the full matrix meta4/uspsAddress_SSN_V4.csv with submatrix meta6/uspsAddress_clean_sub_V6.csv
# output: meta6/uspsAddress_Merge_V6_2.csv  meta6/uspsAddress_Merge_V6_2.RData
Rscript src/uspsAddress_Merge_V6_2.r

# Testeing different blocking strategy
Rscript src/RL_TestBlocking.r

