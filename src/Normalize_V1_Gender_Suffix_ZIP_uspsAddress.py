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

def print_separator(title):
  print("\n=====[Time Now: %s]" % datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
  print("=====[%s]=====" % title)


def main():

  # Parse command line options.
  parser = argparse.ArgumentParser(description='Normalize V1: Gender, Suffix, ZIP and usps Address',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('input_fname', metavar='dataset-name', default='original-dataset/FInalDataset_1M.csv', type=str, help='Original data set name.')
  parser.add_argument('output_directory', metavar='output-directory', default='meta2', type=str,
                        help='Directory to store output statistics.')
  args = parser.parse_args()

  print_separator("Normalize V1: Gender, Suffix, ZIP and usps Address")
  print("Current directory: %s" % os.getcwd() )
  print("Input dataset: %s" % args.input_fname)
  print("Output directory: %s" % args.output_directory)

  if not os.path.exists(args.output_directory):
    os.makedirs(args.output_directory)    

  if os.path.isfile(args.input_fname) and os.path.isdir(args.output_directory):
    start_time = time.time()

    # Read in dataset
#    input_df = pd.read_csv(args.input_fname)
    input_df = pd.read_csv(args.input_fname, index_col = 'EnterpriseID', dtype={'EnterpriseID': int})
    input_df.fillna("", inplace=True)
    # GENDER Normalization
    print_separator("GENDER: before normalization")
    print(input_df['GENDER'].value_counts().to_string())

    input_df['GENDER'].replace(['F'],'FEMALE', inplace=True)
    input_df['GENDER'].replace(['M'],'MALE', inplace=True)
    input_df['GENDER'].replace(['','U'],'Unknown', inplace=True)

    print_separator("GENDER: after normalization")
    print(input_df['GENDER'].value_counts().to_string())


    # SUFFIX Normalization
    print_separator("SUFFIX: before normalization")
    print(input_df['SUFFIX'].value_counts().to_string())

    input_df['SUFFIX'].replace(['SR.'],'SR', inplace=True)
    input_df['SUFFIX'].replace(['JR.'],'JR', inplace=True)

    print_separator("SUFFIX: after normalization")
    print(input_df['SUFFIX'].value_counts().to_string())


    # Examine ZIP field as Summary
    print_separator("Examine ZIP field")
    input_df['ZIPLen'] = input_df['ZIP'].str.len()
    input_df['Zip5'] = ""
    input_df['Zip4'] = ""
    print(input_df['ZIPLen'].value_counts(sort=True).to_string())

 
    # Examine ZIP field in detail
    input_df['NAME'] = input_df[['LAST','FIRST']].apply(lambda x: '_'.join(x), axis=1)
    idxZip5 = input_df['ZIP'].str.len() >= 5
    idxZip4 = input_df['ZIP'].str.len() < 5
    idxZip9 = input_df['ZIP'].str.len() == 9
    idxZip10= input_df['ZIP'].str.len() == 10

    # Take the first 5 digits as Zip5, and ignore all others
    input_df.loc[idxZip5,'Zip5'] = input_df.loc[idxZip5,'ZIP'].str[0:5]

    # Take the last 4 digits of 9 digits and 10 digits
    input_df.loc[idxZip9,'Zip4'] = input_df.loc[idxZip9,'ZIP'].str[5:9]
    input_df.loc[idxZip10,'Zip4'] = input_df.loc[idxZip10,'ZIP'].str[6:10]

    output_detail_fname = "%s/ZIPLengthDetail.csv" % args.output_directory
    print_separator("The detail file is saved as %s" % output_detail_fname)
    with open(output_detail_fname, 'w') as outDetail:
      mylist = [3,8,6,2,12,10,1,4,5,9]
      for i in range(0, len(mylist)):
        thisdf = input_df[input_df['ZIPLen'] == mylist[i]]
        print('%d records with Zip code length = %d' % (len(thisdf), mylist[i]))

        outDetail.write("\n###################\n")
        outDetail.write('%d records with Zip code length = %d\n' % (len(thisdf), mylist[i]))
#        outDetail.write(thisdf[['ZIP','ZIPLen','Zip5','Zip4','ADDRESS1','ADDRESS2','CITY','STATE','NAME']].to_string())
        outDetail.write(thisdf[['ZIP','Zip5','Zip4','CITY','STATE']].to_string()) 

  # https://answers.yahoo.com/question/index?qid=20100126064534AAEk56z
  # The highest is "99950" KETCHIKAN. 
       
  else:
    print_separator("Either dataset-name or output-directory is missing.  Please check again.")

  duration = time.time() - start_time
  print_separator("Bye bye")
  print("=====Total Elapsed Time: %.3f seconds" % duration)

  print("\n===== Summary =====")
  print("Input dataset: %s/%s" % (os.getcwd(), args.input_fname))
  print("Output directory: %s/%s" % (os.getcwd(), args.output_directory))
  print("Detail file created: %s" % output_detail_fname)



if __name__ == "__main__":
  main()

