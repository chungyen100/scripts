from argparse import ArgumentParser
from subprocess import Popen, PIPE, call
import sys
import re
import math
import statistics

def parse_arguments():
    usage = "python skunk_tab.py -f file_to_parse" 
    parser = ArgumentParser(description="Parsing timing information from a mongo-perf run", usage=usage)
    parser.add_argument('-f', '--fname', dest='fname', action='store',
        help='Name of the text file from a mongo-perf to be parsed',
        default=None)
    return parser.parse_known_args()

args, extra_args = parse_arguments()
if not args.fname:
    print("Must provide a file name. Run with --help for details.")
    sys.exit(1)

jsf=""
# scan through the file to find the file name and the corresponding time
print args.fname
with open(args.fname, "r") as f:
    for line in f:
        matchObj = re.match( r'^load\S+/(.+js)', line)
        if matchObj:   # we found the file name     
            jsf = matchObj.group(1)
            time = {}
        else: 
            matchObj = re.match(r'^(real|user|sys)\s+(\S+)m(\S+)s', line)
            if matchObj: 
                time[matchObj.group(1)] = float(matchObj.group(2))*60.0 + float(matchObj.group(3))
                if matchObj.group(1) == 'sys':
                    print "%s, %s, %s, %s" % (jsf, time['real'], time['user'], time['sys'])
