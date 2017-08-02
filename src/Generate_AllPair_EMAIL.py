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
#from spellname import correction

def print_separator(title):
  print("\n=====[Time Now: %s]" % datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
  print("=====[%s]=====" % title)


def main():

  # Parse command line options.
  parser = argparse.ArgumentParser(description='Generate_AllPAir_EMAIL_3to63', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('input_fname', metavar='dataset-name', default='original-dataset/FInalDataset_1M.csv', type=str, help='Original data set name.')

  parser.add_argument('output_directory', metavar='output-directory', default='EMAILcsv', type=str,
                        help='Directory for merged data for furthur examination.')
  args = parser.parse_args()

  print_separator("Generate all possible pairs of patients with the same EMAIL")
  print("Current directory: %s" % os.getcwd() )
  print("Output directory: %s" % args.output_directory)

  if not os.path.exists(args.output_directory):
    os.makedirs(args.output_directory)    

  if os.path.isfile(args.input_fname) and os.path.isdir(args.output_directory):
    start_time = time.time()

    input_df = pd.read_csv(args.input_fname)
    input_df.fillna("", inplace=True)

    FREQ = input_df['EMAIL'].value_counts().values
    EMAIL = input_df['EMAIL'].value_counts().index.values

    print(input_df['EMAIL'].value_counts())
    print(len(FREQ))

    # remove 1st element with no EMAIL (Date of Birth) information
    if sum(EMAIL == "") == 1:
      idx_del = np.where(EMAIL == "")[0]
      FREQ = np.delete(FREQ, idx_del)
      EMAIL = np.delete(EMAIL, idx_del)

    # select thoese elements with frequenies >2  frequency == 2 has been solved
    idx_g2 = np.where(FREQ >= 2)
    FREQ = FREQ[idx_g2]
    EMAIL = EMAIL[idx_g2]

    print(len(FREQ))
    print(len(EMAIL))


    for N in range(51, max(FREQ)+1):
#    for N in range(min(FREQ), 50+1):
      idx = np.where(FREQ == N)[0]
      print_separator('Frequency = %d : %d EMAIL' % (N, len(idx)))
      if len(idx) > 0:
        for i in range(len(idx)):
          thisEMAIL = EMAIL[idx[i]]
          idx_EMAIL = np.where(input_df['EMAIL'] == thisEMAIL)[0]
          if i == 0:
            result_df = input_df.iloc[idx_EMAIL,]
          else:
            result_df = pd.concat([result_df, input_df.iloc[idx_EMAIL,]])
        result_df.to_csv('%s/sameEMAIL_checkFREQ%02d.csv' % (args.output_directory, N), index=False)

        output_fname = "%s/sameEMAIL_FREQ%02d.csv" % (args.output_directory, N)
        count = 0;
        with open(output_fname, 'w') as EMAILcsv:
          for i in range(len(idx)):
            thisEMAIL = EMAIL[idx[i]]
            idx_EMAIL = np.where(input_df['EMAIL'] == thisEMAIL)[0]
            result_df = input_df.iloc[idx_EMAIL,]
            for j in range(0,N-1):
              for k in range(j+1,N):
                EMAILcsv.write("%s,%s,1\n" % (result_df.iloc[j,0],result_df.iloc[k,0]))
                count = count + 1;
        print("%s created with %d pairs" % (output_fname, count))
      else:
        print("No output file was created because no EMAIL with Frequency = %d" % N)
      


#    print("2:",len(idx_2))
#    print("3:",len(idx_3))
#    print("4:",len(idx_4))
#    print("5:",len(idx_5))


    
#    print(idx_2[0:1])
#    print(EMAIL[idx_2[0:1]])
#    print(FREQ[idx_2[0:1]])



#    s.drop(s.index[0])



#    print(FREQ[0:5])
#    print(EMAIL[0:5])

#    counts = input_df['EMAIL'].value_counts().to_dict() 
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


