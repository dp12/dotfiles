#!/usr/bin/env python3

import fileinput
import os
import sys

# https://blog.finxter.com/how-to-search-and-replace-a-line-in-a-file-in-python/
# Does a list of files, and
# redirects STDOUT to the file in question

if len(sys.argv) < 3:
    print("Too few arguments")
    sys.exit()

key = sys.argv[1]
new_cmd = ' '.join(sys.argv[2:])
for line in fileinput.input(os.path.expanduser("~") + "/fastactions", inplace = 1):
    if key in line:
        line = key + " = " + new_cmd + "\n"
    sys.stdout.write(line)
