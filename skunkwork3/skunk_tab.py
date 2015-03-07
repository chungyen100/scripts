from argparse import ArgumentParser
from subprocess import Popen, PIPE, call
import sys
import re
import math

def parse_arguments():
    usage = "python skunk_tab.py -f file_to_parse" 
    parser = ArgumentParser(description="Parsing timing information from a mongo-perf run", usage=usage)

    parser.add_argument('-f', '--fname', dest='fname', 
                        help='Name of the text file from a mongo-perf to be parsed',
                        default=None)
    return parser.parse_known_args()

def find_mean_and_stdev(t_list):
    num_trial = len(t_list)
    mean = 0.0
    tmp = 0.0
    for t in t_list:
        mean += t/num_trial
    for t in t_list:
        tmp += (t-mean)**2
    stdev = math.sqrt(tmp/num_trial-1)
    # print "thread=" + str(last_tcount) + "   mean=" + str(mean) + "   stdev=" + str(stdev) + "tc=" + str(num_trial)
    print "thread=%s,   mean=%f,   stdev=%f,   tcount=%d, " % (last_tcount, mean, stdev, num_trial),
    for t in t_list:
        print t,
    print
    #print str(t_list[0:num_trial])
    #print t_list

args, extra_args = parse_arguments()
if not args.fname:
    print("Must provide a file name. Run with --help for details.")
    sys.exit(1)


# scan through the entire file and build the following dictionaries
# opname.tcount : mean, stdev, array of per trail thpt
opname = ""
op_thread = ""
tcount = 0
last_tcount = 0
tput = 0.0
trial_index = 0
tput_list = []
with open(args.fname, "r") as f:
    for line in f:
	matchObj = re.match( r'(^\d+)\s+(\d+.\d+)', line)
	if matchObj:   # this is a line that contains throughput data
            tcount = matchObj.group(1) 
            tput = float(matchObj.group(2))
            if (tcount == last_tcount):   # this line has the same thread count as the last one
                trial_index += 1
            else:   # a new thread count is encountered; this could also mean a new test case
                trial_index = 0
                if (last_tcount != 0): # new thread count started; not new test
                    find_mean_and_stdev(tput_list)
                    tput_list = []
                op_thread = opname + "." + tcount
            tput_list.append(tput)
            last_tcount = tcount	
	else: 
            matchObj = re.match( r'(^\S+)', line)
            if matchObj:   # this line contains name of a new test case or non-critical info
                if (len(tput_list)>0):   # this is not the very first case; print last thread count for last case
                    find_mean_and_stdev(tput_list)
                # setting up for the new test case
                opname=matchObj.group(1)
                print opname
                last_tcount=0
                
