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


from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import numpy as np
import pandas as pd

import math
import os
import random
import sys
import time
import datetime
import argparse
import sklearn
import requests
import re
from spellname import correction

def print_separator(title):
  print("\n=====[Time Now: %s]" % datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
  print("=====[%s]=====" % title)


def main():

  # Parse command line options.
  parser = argparse.ArgumentParser(description='Match V2: For each DOB group, find the same or similar FIRST, LAST NAME pair', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('input_fname', metavar='dataset-name', default='original-dataset/FInalDataset_1M.csv', type=str, help='Original data set name.')

  parser.add_argument('output_directory', metavar='output-directory', default='meta3', type=str,
                        help='Directory for merged data for furthur examination.')
  args = parser.parse_args()

  print_separator("Match V2: For each DOB group, find the same or similar FIRST, LAST NAME pair")
  print("Current directory: %s" % os.getcwd() )
  print("Input dataset: %s" % args.input_fname)
  print("Output directory: %s" % args.output_directory)

  if not os.path.exists(args.output_directory):
    os.makedirs(args.output_directory)    

  if os.path.isfile(args.input_fname) and os.path.isdir(args.output_directory):
    start_time = time.time()

    input_df = pd.read_csv(args.input_fname)
    input_df.fillna("", inplace=True)

    FREQ = input_df['DOB'].value_counts().values
    DOBs = input_df['DOB'].value_counts().index.values
    input_df['LAST_correct'] = input_df['LAST'].apply(correction)
    input_df['FIRST_correct'] = input_df['FIRST'].apply(correction)
    input_df.to_csv('meta3/uspsAddress_full_V2_normalizeName.csv', index=False)

    # remove 1st element with no DOB (Date of Birth) information
    if sum(DOBs == "") == 1:
      idx_del = np.where(DOBs == "")[0]
      FREQ = np.delete(FREQ, idx_del)
      DOBs = np.delete(DOBs, idx_del)

    # select thoese elements with frequenies >=2
    idx_g1 = np.where(FREQ > 1)
    FREQ = FREQ[idx_g1]
    DOBs = DOBs[idx_g1]

#    for i in range(len(DOBs)):
#    thisDOB = np.where(input_df['DOB'] == DOBs[0])
    idx_2 = np.where(FREQ == 2)[0]
    for i in range(len(idx_2)): 
#    for i in range(5):
      thisDOB = DOBs[idx_2[i]]
      idx_DOB = np.where(input_df['DOB'] == thisDOB)[0]
#      print("%d,%d,1" % (input_df.loc[idx_DOB[0],'EnterpriseID'],input_df.loc[idx_DOB[1],'EnterpriseID']))
#      print(input_df.iloc[idx_DOB,])
      if i == 0:
        result_df = input_df.iloc[idx_DOB,]
      else:
        result_df = pd.concat([result_df, input_df.iloc[idx_DOB,]])     

    print(result_df)
#    result_df.to_csv('meta3/sameDOB2.csv', index=False)
    result_df.to_csv('meta3/sameDOB2_normalizeName.csv', index=False)
    
#    print(idx_2[0:1])
#    print(DOBs[idx_2[0:1]])
#    print(FREQ[idx_2[0:1]])



#    s.drop(s.index[0])



#    print(FREQ[0:5])
#    print(DOBs[0:5])

#    counts = input_df['DOB'].value_counts().to_dict() 
#    print(counts.items())
#    print(counts.keys()[1:5])  
#    print(counts.values()[1:5])


#    print_separator("Parse Error Message in <ReturnText> and <Description>")

#    for i in range(len(input_df)):

#    with open(output_fname, "w") as myfile:
#      myfile.write("EnterpriseID,uspsMainAddress,uspsMinorAddress,uspsCity,uspsState,uspsZIP\n")

#    merge_df_OnlyAddress.sort_values(by = 'Description', inplace = True)
#    merge_df_OnlyAddress.sort_values(by = 'uspsMainAddress', ascending=True, inplace=True)
#    merge_df_OnlyAddress.sort_values(by = 'MRN', ascending=True, inplace=True)
#    merge_df_OnlyAddress.sort_values(by = 'MRN', ascending=True, inplace=True)
#    merge_df_OnlyAddress.to_csv('%s/uspsAddress_slim_V2.csv' % args.output_directory, index = False)

  else:
    print_separator("Either dataset-name or output-directory is missing.  Please check again.")


  duration = time.time() - start_time
  print_separator("Bye bye")
  print("=====Total Elapsed Time: %.3f seconds" % duration)

  print("\n===== Summary =====")
  print("Input dataset: %s/%s" % (os.getcwd(), args.input_fname))
#  print("Merged file created: %s" % merged_filename)

if __name__ == "__main__":
  main()


