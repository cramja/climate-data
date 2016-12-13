#!/usr/local/bin/python
import datetime as dt
import os
import re
import sys

capture_temp = r"^\d+\s*\d+\s*(\d+)\s*(-?\d+.?\d+).*$"
date_start = dt.datetime(1970, 1, 1)

def extract_date(line):
  year = int(line[0:4])
  month = int(line[4:6])
  day = int(line[6:8])
  if year < 1970 or year > 2030 or month > 12 or day > 31:
    print "invalid line {}, exiting".format(line)
    exit(-1)

  return dt.datetime(year, month, day)

def days_delta(dt_start, dt_end):
  diff = dt_end - dt_start
  return diff.days

# takes a raw NOAA file (or several NOAA files) and outputs a
# csv of the date since Jan 1, 1970 and the avg temp for that
# day.

files = sys.argv[1:]
data = []
days_vals = []

# go through each file, clean
for f in files:
  rawlines = []
  with open(f, 'r') as fn:
    rawlines = fn.read().split('\n')

  for line in rawlines:
    if line.startswith('STN-') or line == "":
      continue
    linesegs = line.split()
    if len(linesegs) > 3:
      days_since = days_delta(date_start, extract_date(linesegs[2]))
      days_vals.append(days_since)
      data.append("{},{}".format(days_since, linesegs[3]))


# sort the data by days since 1970
idx_sorted = [i[0] for i in sorted(enumerate(days_vals), key=lambda x:x[1])]
sorted_data = []
for idx in idx_sorted:
  sorted_data.append(data[idx])

# create output directory, place all output there
cleaned_dir = "clean_data"
if not os.path.exists(cleaned_dir):
  os.makedirs(cleaned_dir)


fname = files[0].split(".")[0]
while fname[-1].isdigit():
  fname = fname[:-1]

fpath = cleaned_dir + "/" + fname + ".csv"
with open(fpath, 'w') as f:
  f.write("\n".join(sorted_data))

print "wrote to {}".format(fpath)
