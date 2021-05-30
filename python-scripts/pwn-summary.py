#!/usr/bin/env python3

import pyperclip
import re
import subprocess
import sys

def usage():
    print("pwn-summary.py <file>")

if len(sys.argv) < 2:
    usage()
    sys.exit()

summary = ""
output = subprocess.check_output("file " + sys.argv[1], shell=True)
if b"x86-64" in output:
    summary += "64-bit executable\n"
elif b"i386" in output:
    summary += "32-bit executable\n"
else:
    summary += "unknown executable\n"

output = subprocess.check_output("pwn checksec " + sys.argv[1], shell=True)
vuln = ""
secure = ""
if b"Partial RELRO" in output:
    vuln += "Partial RELRO, "
elif b"Full RELRO" in output:
    secure += "Full RELRO, "
else:
    vuln += "No RELRO, "

if b"No canary found" in output:
    vuln += "no canary, "
else:
    secure += "has canary, "

if b"NX enabled" in output:
    secure += "NX enabled, "
else:
    vuln += "no NX enabled, "

if b"No PIE" in output:
    vuln += "no PIE"
else:
    secure += "PIE enabled"

vuln = vuln.rstrip().strip(",")
secure = secure.rstrip().strip(",")
summary += vuln + "\n" + secure + "\n"

output = subprocess.check_output("strings libc* 2>/dev/null | grep version | grep -i glibc | head -n1", shell=True)
if b"glibc" in output.lower():
    match = re.search(b"2\.[0-9][0-9].*\)", output)
    summary += "glibc " + match[0].strip(b")").decode()
print("\n" + summary)
pyperclip.copy(summary)
