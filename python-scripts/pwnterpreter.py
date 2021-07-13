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
    # /usr/include/linux/mman.h
    # /usr/include/asm-generic/mman.h
    # /usr/include/asm-generic/mman-common.h
    # /usr/include/x86_64-linux-gnu/asm/mman.h
    if flags & 0x1:
        flags_str = update_flags(flags_str, "MAP_SHARED")
    if flags & 0x2:
        flags_str = update_flags(flags_str, "MAP_PRIVATE")
    if flags & 0x10:
        flags_str = update_flags(flags_str, "MAP_FIXED")
    if flags & 0x20:
        flags_str = update_flags(flags_str, "MAP_ANONYMOUS")
    if flags & 0x40:
        flags_str = update_flags(flags_str, "MAP_32BIT")
    if flags & 0x100:
        # /* stack-like segment */
        flags_str = update_flags(flags_str, "MAP_GROWSDOWN")
    if flags & 0x800:
        # /* ETXTBSY */
        flags_str = update_flags(flags_str, "MAP_DENYWRITE")
    if flags & 0x1000:
        # /* mark it as an executable */
        flags_str = update_flags(flags_str, "MAP_EXECUTABLE")
    if flags & 0x2000:
        # /* pages are locked */
        flags_str = update_flags(flags_str, "MAP_LOCKED")
    if flags & 0x4000:
        # /* don't check for reservations */
        flags_str = update_flags(flags_str, "MAP_NORESERVE")
    if flags & 0x8000:
        flags_str = update_flags(flags_str, "MAP_POPULATE")
    if flags & 0x10000:
        flags_str = update_flags(flags_str, "MAP_NONBLOCK")
    if flags & 0x20000:
        flags_str = update_flags(flags_str, "MAP_STACK")
    if flags & 0x40000:
        flags_str = update_flags(flags_str, "MAP_HUGETLB")
    if flags & 0x80000:
        flags_str = update_flags(flags_str, "MAP_SYNC")
    if flags & 0x100000:
        flags_str = update_flags(flags_str, "MAP_FIXED_NOREPLACE")
    if flags & 0x4000000:
        flags_str = update_flags(flags_str, "MAP_UNINITIALIZED")
    print("flags (0x%x): %s" % (flags, flags_str))

elif function == "mprotect":
    print("mprotect")
