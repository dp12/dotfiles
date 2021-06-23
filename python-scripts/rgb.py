#!/usr/bin/env python3

import os
import sys

if len(sys.argv) < 2:
    print("usage: rgb <hexstring>")

hexstring = sys.argv[1]
extra_args = ' '.join(sys.argv[2:])
rg_cmd = "rg -boa"
search_string = "\"(?-u)"
for i in range(0, len(hexstring), 2):
    search_string += "\\x" + hexstring[i:i+2]
search_string += "\""
cmd = rg_cmd + " " + search_string + " " + extra_args
print(cmd)
os.system(cmd)
