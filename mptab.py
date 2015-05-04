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


def processThroughputList(oname, tcnt, t_list):
    t_list.sort()
    median = statistics.median(t_list)
    mean = statistics.mean(t_list)
    stdev = statistics.stdev(t_list)
    print "%s, %s, %f, %f, %f, %f, - " % (oname, tcnt, median, mean, stdev, stdev/mean),
    for t in t_list:
        print ", %f" % (t),
    print


args, extra_args = parse_arguments()
if not args.fname:
    print("Must provide a file name. Run with --help for details.")
    sys.exit(1)


# scan through the entire file and build the following dictionaries
# opname.tcount : mean, stdev, array of per trail thpt
opname = ""
last_opname = ""
tcount = 0
last_tcount = 0
tput = 0.0
tput_list = []
with open(args.fname, "r") as f:
    for line in f:
	matchObj = re.match( r'(^\d+)\s+(\d+.\d+)', line)
	if matchObj:   # this is a line that contains throughput data
            tcount = matchObj.group(1) 
            tput = float(matchObj.group(2))
            if (tcount != last_tcount): # a new thread count is encountered; this could also mean a new test case
                if (last_tcount != 0): # new thread count started; process the last thread count 
                    processThroughputList(opname, last_tcount, tput_list)
                    tput_list = []
            tput_list.append(tput)
            last_tcount = tcount	
	else: 
            matchObj = re.match( r'(^\S+)', line)
            if matchObj:   # this line contains name of a new test case or non-critical info
                opname=matchObj.group(1)
                if (opname != last_opname): # entering new test
                    if (len(tput_list)>0): # this is not the very first case; process last thread count for last case
                        processThroughputList(last_opname, last_tcount, tput_list)
                        tput_list = []
                    # setting up the new test case
                    last_opname = opname
                    last_tcount=0
                
