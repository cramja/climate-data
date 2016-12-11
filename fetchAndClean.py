#!/usr/local/bin/python
import datetime as dt
import os
import re
import sys
import subprocess as sp

def fetch(code, city):
  with open(os.devnull, 'w') as fnull:
    sp.call(["./getData.sh {} {}".format(code, city)], shell=True, stdout=fnull)
    out = "{}.out".format(city)
    if os.path.isfile(out):
      return out

def combine(fnames):
  args = "./cleanData.py"
  for name in fnames:
    args = args + " " + name
  sp.call(args, shell=True)


infile = sys.argv[1]
codes = open(infile, 'r').read().split('\n')
last_cities = []
for line in codes:
  if line.startswith("#") or line == "":
    continue

  ll = line.split(",")
  city = ll[0] 
  code = ll[1]
  outfile = fetch(code, city)
  if not outfile:
    print "failed to get {}, {}".format(code, city)
    continue

  if len(last_cities) == 0 or city.startswith(last_cities[0][0:5]):
    last_cities.append(outfile)
  else:
    combine(last_cities)
    last_cities = [outfile]

  print "finished {}".format(city)

combine(last_cities)