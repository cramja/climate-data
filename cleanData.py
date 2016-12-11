#!/usr/local/bin/python

import sys
import re

capture_temp = r"^\d+\s*\d+\s*(\d+)\s*(-?\d+.?\d+).*$"

with open(sys.argv[1], 'r') as f:
  lines = f.read()
  cleaned = []
  for line in lines.split('\n'):
    if line.startswith('STN-'):
       continue
    p = line.split()
    if len(p) > 3:
       cleaned.append(p[2] + "," + p[3])

print "\n".join(cleaned)     
