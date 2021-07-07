#!/usr/bin/env python3

import argparse
import subprocess
import os
import sys

parser = argparse.ArgumentParser()
parser.add_argument('hexstring')
parser.add_argument("-l", "--files_with_matches", help="only print paths",
                    action="store_true")
parser.add_argument("-r", "--reverse", help="reverse the hex string provided",
                    action="store_true")
parser.add_argument("-x", "--hex_offset", help="output offsets in hex",
                    action="store_true")
parser.add_argument('rest', nargs=argparse.REMAINDER)
args = parser.parse_args()

hexstring = args.hexstring
if hexstring.startswith("0x"):
    hexstring = hexstring[2:]

if args.reverse:
    hexstring = "".join(reversed([hexstring[i:i+2] for i in range(0, len(hexstring), 2)]))

if args.files_with_matches:
    rg_cmd = "rg -boal"
else:
    rg_cmd = "rg -boa"
extra_args = ' '.join(args.rest)

search_string = "\"(?-u)"
for i in range(0, len(hexstring), 2):
    search_string += "\\x" + hexstring[i:i+2]
search_string += "\""
cmd = rg_cmd + " " + search_string + " " + extra_args
print(cmd)
os.system(cmd)
ret = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT).decode('utf-8', 'ignore')

if args.hex_offset:
    for line in ret.splitlines():
        print("%s 0x%x " % (line, int(line.replace(":", "").replace("\x00", ""))))
