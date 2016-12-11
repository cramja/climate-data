#!/usr/local/bin/python

import sys
import datetime as dt
import os

date_start = dt.datetime(1970, 1, 1)

files = sys.argv[1:]
data = []

for f in files:
  
  with open(f, 'r') as fn:
    r = fn.read().split('\n')
    for line in r:
      if line.strip() == "":
        continue
      date_end = 0
      date_end = dt.datetime(int(line[0:4]), int(line[4:6]), int(line[6:8]))
      delta = date_end - date_start
      s = str(delta.days) + "," + line.split(',')[1]
      data.append(s)

# create output directory, place all output there
cleaned_dir = "clean_data"
if not os.path.exists(cleaned_dir):
  os.makedirs(cleaned_dir)

fname = files[0].split(".")[0]
while fname[-1].isdigit():
  fname = fname[:-1]

fpath = cleaned_dir + "/" + fname + ".csv"
with open(fpath, 'w') as f:
  f.write("\n".join(data))

print "wrote to {}".format(fpath)