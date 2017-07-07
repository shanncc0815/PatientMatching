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

def print_separator(title):
  print("\n=====[Time Now: %s]" % datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
  print("=====[%s]=====" % title)


def main():

  # Parse command line options.
  parser = argparse.ArgumentParser(description='Merge V2: combine normalized results from usps webtool', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('input_fname', metavar='dataset-name', default='original-dataset/FInalDataset_1M.csv', type=str, help='Original data set name.')

  parser.add_argument('input_directory', metavar='input-directory', default='meta2', type=str,
                        help='Directory for usps webtool metadata.')

  parser.add_argument('output_directory', metavar='output-directory', default='meta3', type=str,
                        help='Directory for merged data for furthur examination.')
  args = parser.parse_args()

  print_separator("Merge V2: combine normalized results from usps webtool")
  print("Current directory: %s" % os.getcwd() )
  print("Input dataset: %s" % args.input_fname)
  print("Input directory: %s" % args.input_directory)
  print("Output directory: %s" % args.output_directory)

  if not os.path.exists(args.output_directory):
    os.makedirs(args.output_directory)    

  if os.path.isfile(args.input_fname) and os.path.isdir(args.output_directory):
    start_time = time.time()

    input_df = pd.read_csv(args.input_fname)
    input_df.fillna("", inplace=True)
    input_df['ReturnText'] = ""
    input_df['Description'] = ""

    # Parse Error Message in <ReturnText> and <Description> in [EnterpriseID.out.txt] file.  
    # As regular expression was used for each row, it took a whlie (~6 hours).
    print_separator("Parse Error Message in <ReturnText> and <Description>")

    for i in range(len(input_df)):
      if i % 10000 == 0:
        print("Merging %dth Patient:[%s]" % (i,datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')))

#      usps_input_fname = '%s/%s.inp.txt' % (input_df.iloc[i,'EnterpriseID'], args.input_directory)
#      itext = pd.read_table(usps_input_fname,header=None).iloc[0,0]

      usps_output_fname = '%s/%s.out.txt' % (args.input_directory, input_df.loc[i,'EnterpriseID'])
      rtext = pd.read_table(usps_output_fname,header=None).iloc[1,0]

      result=re.search('(?is)<ReturnText[^>]*>(.+?)</ReturnText>', rtext)
      input_df.loc[i,'ReturnText'] = result.group(1) if (result != None) else  ""

      result=re.search('(?is)<Description[^>]*>(.+?)</Description>', rtext)
      input_df.loc[i,'Description'] = result.group(1) if (result != None) else  ""

    input_df.to_csv('%s/input_df.csv' % args.output_directory, index = False)

    # Parse usps Address information, including main address, City, State, and Zip codes.
    # It was relatively fast - only took several minutes.
    print_separator("Parse usps Address information, including main address, City, State, and Zip codes")
    output_fname = '%s/Merged_uspsAddress.csv' % args.output_directory

    with open(output_fname, "w") as myfile:
      myfile.write("EnterpriseID,uspsMainAddress,uspsMinorAddress,uspsCity,uspsState,uspsZIP\n")

    with open(output_fname, "a") as myfile:
      for i in range(len(input_df)):
        if i % 10000 == 0:
          print("Merging %dth Patient:[%s]" % (i,datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')))

        this_address = '%s/%s.address.txt' % (args.input_directory, input_df.iloc[i,0])
        text = pd.read_table(this_address,header=None).iloc[0,0]
        myfile.write('%d,%s\n' % (input_df.iloc[i,0], text))

    # Combine the two data frames, and output the full matrix as well as a slim version containing key info    
    merge_address_df = pd.read_csv(output_fname, dtype={'uspsZIP':object})
    merge_df = pd.merge(left = input_df, right = merge_address_df, left_on='EnterpriseID', right_on='EnterpriseID')
    merge_df['uspsZIP5'] = merge_df['uspsZIP'].str[0:5]
    merge_df['uspsZIP4'] = merge_df['uspsZIP'].str[5:9]

    merged_filename = '%s/uspsAddress_full_V2.csv' % args.output_directory
    merge_df.to_csv(merged_filename, index = False)
    merge_df_OnlyAddress = merge_df[['EnterpriseID','MRN','SSN','LAST','FIRST','ADDRESS1','CITY','STATE','ZIP','uspsMainAddress','ReturnText','Description']]

#    merge_df_OnlyAddress.sort_values(by = 'Description', inplace = True)
#    merge_df_OnlyAddress.sort_values(by = 'uspsMainAddress', ascending=True, inplace=True)
#    merge_df_OnlyAddress.sort_values(by = 'MRN', ascending=True, inplace=True)
#    merge_df_OnlyAddress.sort_values(by = 'MRN', ascending=True, inplace=True)
    merge_df_OnlyAddress.to_csv('%s/uspsAddress_slim_V2.csv' % args.output_directory, index = False)

  else:
    print_separator("Either dataset-name or output-directory is missing.  Please check again.")


  duration = time.time() - start_time
  print_separator("Bye bye")
  print("=====Total Elapsed Time: %.3f seconds" % duration)

  print("\n===== Summary =====")
  print("Input dataset: %s/%s" % (os.getcwd(), args.input_fname))
  print("Output directory: %s/%s" % (os.getcwd(), args.output_directory))
  print("Merged file created: %s" % merged_filename)

if __name__ == "__main__":
  main()


