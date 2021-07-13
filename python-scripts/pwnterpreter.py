#!/usr/bin/env python3
#
# TODO:
#
# Memory related
# mprotect, mmap
# signal, sigaction
# socket, bind
# prctl, seccomp_init, seccomp_add
# setvbuf

import sys

def str_to_num(in_str):
    if in_str.startswith("0x"): return int(in_str, 16)
    else:                       return int(in_str)

def update_flags(cur_str, new_str):
    if cur_str != "": return cur_str + " | " + new_str
    else:             return new_str

if len(sys.argv) < 2:
    print("usage: pwnterpreter.py <function call>")

func_call = ''.join(sys.argv[1:])
print(func_call)

# TODO: handle something like:
# mmap((void *)0x0,0x4e,7,0x22,-1,0);
function = func_call.split("(")[0]
print("function: %s" % function)
args = func_call.strip(")").strip(";").split("(")[1].split(",")
for i in args:
    print(i)

if function == "mmap":
    print("void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);")
    prot = str_to_num(args[2])
    print("prot: 0x%x" % prot)
    prot_str = ""
    # From /usr/include/asm-generic/mman-common.h
    if prot == 0:
        prot_str = update_flags(prot_str, "PROT_NONE")
    if prot & 0x1:
        prot_str = update_flags(prot_str, "PROT_READ")
    if prot & 0x2:
        prot_str = update_flags(prot_str, "PROT_WRITE")
    if prot & 0x4:
        prot_str = update_flags(prot_str, "PROT_EXEC")
    if prot & 0x8:
        prot_str = update_flags(prot_str, "PROT_SEM")
    print("prot (0x%x): %s" % (prot, prot_str))

    flags = str_to_num(args[3])
    flags_str = ""
    if flags & 0x10:
        flags_str = update_flags(flags_str, "MAP_FIXED")

elif function == "mprotect":
    print("mprotect")
