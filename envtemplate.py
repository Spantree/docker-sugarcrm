#!/usr/bin/env python
import os, sys, getopt
from string import Template

def main(argv):
  inputfile = ''
  outputfile = ''
  try:
    opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
  except getopt.GetoptError:
    print 'test.py -i <inputfile> -o <outputfile>'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'test.py -i <inputfile> -o <outputfile>'
      sys.exit()
    elif opt in ("-i", "--ifile"):
      inputfile = arg
    elif opt in ("-o", "--ofile"):
      outputfile = arg
  
  # Read all environment variables in and populate a case-insensitive
  # dictionary for replacement
  values = dict()
  for k in os.environ:
    v = os.environ.get(k)
    values[k] = v
    values[k.lower()] = v

  

  # Read the template
  ifile = open(inputfile)
  templatestr = open(inputfile).read()
  ifile.close()

  out = Template(templatestr).substitute(values)
  
  print "Writing output to {}".format(outputfile)
  print "==============================="
  print out

  ofile = open(outputfile, "w")
  ofile.write(out)
  ofile.close()

if __name__ == "__main__":
   main(sys.argv[1:])
