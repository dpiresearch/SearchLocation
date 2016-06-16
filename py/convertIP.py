import sys
import csv

#
# This reads in a file and writes out
# the same information except the ip address
# in the second column is converted to an integer
# to be derived into a latlng by maxmind in a 
# later process
#

# The input file is assumed to be tab delimited and of the form
# code (int)  ip address (string)  keyword (string)  count (int)
def from_string(s):
  "Convert dotted IPv4 address to integer."
  return reduce(lambda a,b: a<<8 | b, map(int, s.split(".")))

def processFile():
  print 'processing file'
  with open('swip.txt', 'rb') as csvfile:
    oneline=csv.reader(csvfile, delimiter='\t')
    print type(oneline)
    print oneline

    for row in oneline:
      
      print row[0]+'\t',from_string(row[1]),'\t'+row[2]+'\t'+row[3]
#      print ', '.join(row)
    
if __name__ == "__main__":
  if len(sys.argv) <= 1:
    sys.exit(0)

  for arg in sys.argv[1:]:
      processFile();
      sys.exit(1)
