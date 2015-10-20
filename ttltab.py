from argparse import ArgumentParser
from subprocess import Popen, PIPE, call
import sys
import re
import math
import statistics
from subprocess import call
import os

def processThroughputList(oname, tcnt, t_list):
    t_list.sort()
    median = statistics.median(t_list)
    mean = statistics.mean(t_list)
    stdev = statistics.stdev(t_list)
    print "%s, %s, %f, %f, %f, %f, - " % (oname, tcnt, median, mean, stdev, stdev/mean),
    for t in t_list:
        print ", %f" % (t),
    print


def process_one_file(fname):
    thpt = {}
    with open(fname, "r") as f:
        for line in f:
            matchObj = re.match(r'\| "(.+)".*\|\s*(\d+).*\|\s*(\d+.\d+)', line)
            if matchObj:
                print matchObj.group(1), matchObj.group(2), matchObj.group(3);
                thpt[matchObj.group(2)] = matchObj.group(3);
    max_thread = max(thpt, key = lambda k: thpt[k]);
    thpt["max"] = thpt[max_thread];
    print thpt;
    return thpt;

results = {};
                
for root, _, files in os.walk(os.getcwd()):
    for f in files:
        matchObj = re.match(r'ttl_3min_(\d).out', f);
        if matchObj:
            print matchObj.group(1);
            results[matchObj.group(1)] = process_one_file(f);

total = {};
max_t = {};
for tcnt in results["1"]:
    total[tcnt] = 0;
    max_t[tcnt] = 0;

for i in sorted(results.iterkeys()):
    print i, results[i];
    for tcnt in results[i]:
        r = float(results[i][tcnt]);
        total[tcnt] += r;
        if (r > max_t[tcnt]):
            max_t[tcnt] = r;

for tcnt in results["1"]:
    avg = float(total[tcnt])/9;
    print tcnt, avg, 200*(max_t[tcnt]-avg)/avg;
            
