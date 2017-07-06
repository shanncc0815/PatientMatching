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

# Step 2: Normalize V2: use usps webtool to normalize Address
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 0 1000000 meta2

## This step can be subdivided into smaller jobs.
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 0 250000 meta2 &
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 250000 500000 meta2 &
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 500000 750000 meta2 &
#python3 src/Normalize_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv 750000 1000000 meta2 &


# Step 3: Merge V3: combine Normalize V2 results and examine next steps
python3 src/Merge_V2_uspsWebtool.py original-dataset/FInalDataset_1M.csv meta2 meta3
python3 src/ExploratoryAnalysis.py meta3/uspsAddress_full_V2.csv meta3

