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
  parser = argparse.ArgumentParser(description='Normalize V4: use usps webtool to normalize Address',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('input_fname', metavar='dataset-name', default='/home/chen/workspace/git_examples/PatientMatching/meta4/uspsAddress_clean_sub_V4.csv', type=str, help='Original data set name.')

  parser.add_argument('start_idx', metavar='start-idx', default='0', type=int, help='start index.')

  parser.add_argument('end_idx', metavar='end-idx', default='1000000', type=int, help='end index.')

  parser.add_argument('output_directory', metavar='output-directory', default='meta5', type=str,
                        help='Directory to store metadata from usps webtool.')
  args = parser.parse_args()

  print_separator("Normalize V4: use usps webtool to normalize Address")
  print("Current directory: %s" % os.getcwd() )
  print("Input dataset: %s" % args.input_fname)
  print("Output directory: %s" % args.output_directory)

  if not os.path.exists(args.output_directory):
    os.makedirs(args.output_directory)    

  if os.path.isfile(args.input_fname) and os.path.isdir(args.output_directory):
    start_time = time.time()

    # Read in dataset
    input_df = pd.read_csv(args.input_fname)
#    input_df = pd.read_csv(args.input_fname, index_col = 'EnterpriseID', dtype={'EnterpriseID': int})
    input_df.fillna("", inplace=True)
 
    # Examine ZIP field as Summary
    print_separator("Examine ZIP field")
    input_df['ZIPLen'] = input_df['ZIP'].str.len()
    input_df['Zip5'] = ""
    input_df['Zip4'] = ""
    print(input_df['ZIPLen'].value_counts(sort=True))
 
    # Examine ZIP field in detail
    idxZip5 = input_df['ZIP'].str.len() >= 5
    idxZip4 = tuple(np.where(input_df['ZIP'].str.len() == 4)[0])
    idxZip3 = tuple(np.where(input_df['ZIP'].str.len() == 3)[0])

    idxZip9 = input_df['ZIP'].str.len() == 9
    idxZip10= input_df['ZIP'].str.len() == 10

    # Take the first 5 digits as Zip5, and ignore all others
    input_df.loc[idxZip5,'Zip5'] = input_df.loc[idxZip5,'ZIP'].str[0:5]

    # add "0"  to the prefix of Zip4
    print(idxZip4[0:5])
    print(len(idxZip4))
    print(len(input_df.loc[idxZip4,'ZIP']))
    print(len(input_df.loc[idxZip4,'Zip5']))

    print(len(idxZip3))
    print(len(input_df.loc[idxZip3,'ZIP']))
    print(len(input_df.loc[idxZip3,'Zip5']))

    input_df.loc[idxZip4,'Zip5'] = pd.Series(['0'] * len(idxZip4)).str.cat(input_df.loc[idxZip4,'ZIP'])

    # add "00" to the prefix of Zip3
    input_df.loc[idxZip3,'Zip5'] = pd.Series(['00'] * len(idxZip3)).str.cat(input_df.loc[idxZip3,'ZIP'])

#    input_df.loc[idxZip3,'Zip5'] = ''.join(['0',input_df.loc[idxZip3,'ZIP']],)

    # Take the last 4 digits of 9 digits and 10 digits
#    input_df.loc[idxZip9,'Zip4'] = input_df.loc[idxZip9,'ZIP'].str[5:9]
#    input_df.loc[idxZip10,'Zip4'] = input_df.loc[idxZip10,'ZIP'].str[6:10]

#    input_df['Zip5Len'] = input_df['Zip5'].str.len()
#    print(input_df['Zip5Len'].value_counts(sort=True))

#    input_df['Zip4Len'] = input_df['Zip4'].str.len()
#    print(input_df['Zip4Len'].value_counts(sort=True))

    for i in range(args.start_idx, args.end_idx):
      if i % 50 == 0:
        print("Patient %d, [time:%s]" % (i,datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')))

      EID = int(input_df.iloc[i,0])
      xmlstring = "<AddressValidateRequest USERID=\"943NARET1574\"><Address ID=\"%s\"><Address1></Address1><Address2>%s</Address2><City>%s</City><State>%s</State><Zip5>%s</Zip5><Zip4></Zip4></Address></AddressValidateRequest>" % (EID, input_df.loc[i,'ADDRESS1'], input_df.loc[i,'CITY'], input_df.loc[i,'STATE'], input_df.loc[i,'Zip5'])

      url = ''.join(['http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=',xmlstring])
      r = requests.post(url)

      result = re.search('(?is)<Address2[^>]*>(.+?)</Address2>', r.text)
      MainAddress = result.group(1) if (result != None) else ""

      result=re.search('(?is)<City[^>]*>(.+?)</City>', r.text)
      City = result.group(1) if (result != None) else ""

      result=re.search('(?is)<State[^>]*>(.+?)</State>', r.text)
      State = result.group(1) if (result != None) else ""

      result=re.search('(?is)<Zip5[^>]*>(.+?)</Zip5>', r.text)
      Zip5 = result.group(1) if (result != None) else ""

      result=re.search('(?is)<Zip4[^>]*>(.+?)</Zip4>', r.text)
      Zip4 = result.group(1) if (result != None) else ""

      CleanAddress = "%s,%s,%s,%s%s,%s" % (MainAddress, City, State, Zip5, Zip4, Zip5)
      with open("%s/%s.address.txt" % (args.output_directory, EID) , "w") as text_file1:
        text_file1.write(CleanAddress)

      with open("%s/%s.inp.txt" % (args.output_directory, EID) , "w") as text_file2:
        text_file2.write(url)

      with open("%s/%s.out.txt" % (args.output_directory, EID) , "w") as text_file3:
        text_file3.write(r.text)

  else:
    print_separator("Either dataset-name or output-directory is missing.  Please check again.")

  duration = time.time() - start_time
  print_separator("Bye bye")
  print("=====Total Elapsed Time: %.3f seconds" % duration)

  print("\n===== Summary =====")
  print("Input dataset: %s/%s" % (os.getcwd(), args.input_fname))
  print("Output directory: %s/%s" % (os.getcwd(), args.output_directory))
#  print("Detail file created: %s" % output_detail_fname)

if __name__ == "__main__":
  main()

