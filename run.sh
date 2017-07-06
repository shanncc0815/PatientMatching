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
python3 src/ExploratoryAnalysis.py original-dataset/FInalDataset_1M.csv meta1

# Step 1: Normalize V1: Gender, Suffix, ZIP and usps Address.
python3 src/Normalize_V1_Gender_Suffix_ZIP_uspsAddress.py original-dataset/FInalDataset_1M.csv meta2


