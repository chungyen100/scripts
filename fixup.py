from argparse import ArgumentParser
from subprocess import Popen, PIPE, call
import sys
import re

def parse_arguments():
    usage = "python skunk_tab.py -f file_to_parse" 
    parser = ArgumentParser(description="Parsing timing information from a mongo-perf run", usage=usage)

    parser.add_argument('-f', '--fname', dest='fname', 
                        help='Name of the text file from a mongo-perf to be parsed',
                        default=None)
    return parser.parse_known_args()

resetLine = "resetTheLineContentForMatching"
lastLine = resetLine

args, extra_args = parse_arguments()
if not args.fname:
    print("Must provide a file name. Run with --help for details.")
    sys.exit(1)

with open(args.fname, "r") as f:
    for line in f:
        if (line != lastLine): # new line; print it
            print line,
            lastLine = line
        else: # a repeated line; ignore it but we only ignore it once
            lastLine = resetLine
                
