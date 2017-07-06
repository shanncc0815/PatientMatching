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
  parser = argparse.ArgumentParser(description='Perform Exploratory Analysis.',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('input_fname', metavar='dataset-name', default='original-dataset/FInalDataset_1M.csv', type=str, help='Original data set name.')
  parser.add_argument('output_directory', metavar='output-directory', default='meta1', type=str,
                        help='Directory to store output statistics.')
  args = parser.parse_args()

  print_separator("Perform Exploratory Analysis")
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
    output_summary_fname = "%s/ExploratorySummary.csv" % args.output_directory
    print_separator("Number of non-blank entries in each field - summary saved as %s" % output_summary_fname)
    print("FIELD\t\t\tnum_nonblank")
    print(input_df.count())

    # Perform basic statistics before any preprocessing
    fields = list(input_df)
    print_separator("Breakdown of number of entries")

    with open(output_summary_fname, 'w') as outSummary:
      outSummary.write("FIELD,num_blank,num_nonblank,num_unique,total\n")

      print("FIELD,num_blank,num_nonblank,num_unique,total")
      for i in range(len(fields)):
        df_counts = input_df[fields[i]].value_counts()
        num_unique = len(df_counts)
        num_blank = pd.isnull(input_df[fields[i]]).sum()
        num_nonblank = df_counts.sum()
        total = num_blank + num_nonblank
        stdoutStr = '%s,%d,%d,%d,%d' % (fields[i], num_blank, num_nonblank, num_unique,total)
        print(stdoutStr)
        outSummary.write(stdoutStr + '\n')
 
    output_detail_fname = "%s/ExploratoryDetail.csv" % args.output_directory
    print_separator("The details are saved as %s" % output_detail_fname)
    with open(output_detail_fname, 'w') as outDetail:
      for i in range(1,len(fields)):
        this_counts = input_df[fields[i]].value_counts()
        outDetail.write("\n###################\n")
        outDetail.write("FIELD:%s (%d unique entries)\n" % (fields[i] , len(this_counts)))
        outDetail.write("-------------------\n")
        outDetail.write(this_counts.to_string())
        
  else:
    print_separator("Either dataset-name or output-directory is missing.  Please check again.")

  duration = time.time() - start_time
  print_separator("Bye bye")
  print("=====Total Elapsed Time: %.3f seconds" % duration)

  print("\n===== Summary =====")
  print("Input dataset: %s/%s" % (os.getcwd(), args.input_fname))
  print("Output directory: %s/%s" % (os.getcwd(), args.output_directory))
  print("Summary file created: %s" % output_summary_fname)
  print("Detail file created: %s" % output_detail_fname)
  



if __name__ == "__main__":
  main()

