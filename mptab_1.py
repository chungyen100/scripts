# This script takes already tabularized mongo-perf output and
# process it into horizontal lines
from argparse import ArgumentParser
from subprocess import Popen, PIPE, call
import sys
import re
import math
import statistics

def parse_arguments():
    usage = "python skunk_tab.py -f file_to_parse" 
    parser = ArgumentParser(description="Parsing timing information from a mongo-perf run", usage=usage)

    parser.add_argument('-f', '--fname', dest='fname', 
                        help='Name of the text file from a mongo-perf to be parsed',
                        default=None)
    return parser.parse_known_args()

args, extra_args = parse_arguments()
if not args.fname:
    print("Must provide a file name. Run with --help for details.")
    sys.exit(1)

# scan through the file and build the list of test, max_med, max_mean
tname = ""
last_tname = ""
med_list = []
mean_list = []

with open(args.fname, "r") as f:
    for line in f:
        matchObj = re.match( r'(^\S+), (\d+), (\S+), (\S+),', line)
        if matchObj:   # this is a line that contains throughput data
            tname = matchObj.group(1)
            if (tname != last_tname):
                if (med_list != []):
                    print "%s, %f, %f" % (last_tname, max(med_list),max(mean_list))
                med_list = []
                med_list.append(float(matchObj.group(3))) 
                mean_list = []
                mean_list.append(float(matchObj.group(4)))
                last_tname = tname
            else:
                med_list.append(float(matchObj.group(3)))
                mean_list.append(float(matchObj.group(4)))
print "%s, %f, %f" % (tname, max(med_list),max(mean_list))
