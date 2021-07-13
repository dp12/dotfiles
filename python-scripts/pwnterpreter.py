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
args = func_call.strip(";").strip(")").split("(")[1].split(",")
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
    print("int mprotect(void *addr, size_t len, int prot);")
    prot = str_to_num(args[2])
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

elif function == "prctl":
    # /usr/include/linux/prctl.h
    print("int prctl(int option, unsigned long arg2, unsigned long arg3, unsigned long arg4, unsigned long arg5);")
    # Allow options like PR_SET_SECCOMP or 22
    if "PR" in args[0]:
        option = args[0]
    else:
        option = str_to_num(args[0])

    if option == "PR_SET_PDEATHSIG" or option == 1:
        print("option (0x%x): %s" % (1, "PR_SET_PDEATHSIG"))
    if option == "PR_GET_PDEATHSIG" or option == 2:
        print("option (0x%x): %s" % (2, "PR_GET_PDEATHSIG"))
    if option == "PR_GET_DUMPABLE" or option == 3:
        print("option (0x%x): %s" % (3, "PR_GET_DUMPABLE"))
    if option == "PR_SET_DUMPABLE" or option == 4:
        print("option (0x%x): %s" % (4, "PR_SET_DUMPABLE"))
    if option == "PR_GET_UNALIGN" or option == 5:
        print("option (0x%x): %s" % (5, "PR_GET_UNALIGN"))
    if option == "PR_SET_UNALIGN" or option == 6:
        print("option (0x%x): %s" % (6, "PR_SET_UNALIGN"))
    if option == "PR_GET_KEEPCAPS" or option == 7:
        print("option (0x%x): %s" % (7, "PR_GET_KEEPCAPS"))
    if option == "PR_SET_KEEPCAPS" or option == 8:
        print("option (0x%x): %s" % (8, "PR_SET_KEEPCAPS"))
    if option == "PR_GET_FPEMU" or option == 9:
        print("option (0x%x): %s" % (9, "PR_GET_FPEMU"))
    if option == "PR_SET_FPEMU" or option == 10:
        print("option (0x%x): %s" % (10, "PR_SET_FPEMU"))
    if option == "PR_GET_FPEXC" or option == 11:
        print("option (0x%x): %s" % (11, "PR_GET_FPEXC"))
    if option == "PR_SET_FPEXC" or option == 12:
        print("option (0x%x): %s" % (12, "PR_SET_FPEXC"))
    if option == "PR_GET_TIMING" or option == 13:
        print("option (0x%x): %s" % (13, "PR_GET_TIMING"))
    if option == "PR_SET_TIMING" or option == 14:
        print("option (0x%x): %s" % (14, "PR_SET_TIMING"))
    if option == "PR_SET_NAME" or option == 15:
        print("option (0x%x): %s" % (15, "PR_SET_NAME"))
    if option == "PR_GET_NAME" or option == 16:
        print("option (0x%x): %s" % (16, "PR_GET_NAME"))
    if option == "PR_GET_ENDIAN" or option == 19:
        print("option (0x%x): %s" % (19, "PR_GET_ENDIAN"))
    if option == "PR_SET_ENDIAN" or option == 20:
        print("option (0x%x): %s" % (20, "PR_SET_ENDIAN"))
    if option == "PR_GET_SECCOMP" or option == 21:
        print("option (0x%x): %s" % (21, "PR_GET_SECCOMP"))
    if option == "PR_SET_SECCOMP" or option == 22:
        print("option (0x%x): %s" % (22, "PR_SET_SECCOMP"))
    if option == "PR_CAPBSET_READ" or option == 23:
        print("option (0x%x): %s" % (23, "PR_CAPBSET_READ"))
    if option == "PR_CAPBSET_DROP" or option == 24:
        print("option (0x%x): %s" % (24, "PR_CAPBSET_DROP"))
    if option == "PR_GET_TSC" or option == 25:
        print("option (0x%x): %s" % (25, "PR_GET_TSC"))
    if option == "PR_SET_TSC" or option == 26:
        print("option (0x%x): %s" % (26, "PR_SET_TSC"))
    if option == "PR_GET_SECUREBITS" or option == 27:
        print("option (0x%x): %s" % (27, "PR_GET_SECUREBITS"))
    if option == "PR_SET_SECUREBITS" or option == 28:
        print("option (0x%x): %s" % (28, "PR_SET_SECUREBITS"))
    if option == "PR_SET_TIMERSLACK" or option == 29:
        print("option (0x%x): %s" % (29, "PR_SET_TIMERSLACK"))
    if option == "PR_GET_TIMERSLACK" or option == 30:
        print("option (0x%x): %s" % (30, "PR_GET_TIMERSLACK"))
    if option == "PR_TASK_PERF_EVENTS_DISABLE" or option == 31:
        print("option (0x%x): %s" % (31, "PR_TASK_PERF_EVENTS_DISABLE"))
    if option == "PR_TASK_PERF_EVENTS_ENABLE" or option == 32:
        print("option (0x%x): %s" % (32, "PR_TASK_PERF_EVENTS_ENABLE"))
    if option == "PR_MCE_KILL" or option == 33:
        print("option (0x%x): %s" % (33, "PR_MCE_KILL"))
    if option == "PR_MCE_KILL_GET" or option == 34:
        print("option (0x%x): %s" % (34, "PR_MCE_KILL_GET"))
    if option == "PR_SET_MM" or option == 35:
        print("option (0x%x): %s" % (35, "PR_SET_MM"))
    if option == "PR_SET_CHILD_SUBREAPER" or option == 36:
        print("option (0x%x): %s" % (36, "PR_SET_CHILD_SUBREAPER"))
    if option == "PR_GET_CHILD_SUBREAPER" or option == 37:
        print("option (0x%x): %s" % (37, "PR_GET_CHILD_SUBREAPER"))
    if option == "PR_SET_NO_NEW_PRIVS" or option == 38:
        print("option (0x%x): %s" % (38, "PR_SET_NO_NEW_PRIVS"))
    if option == "PR_GET_NO_NEW_PRIVS" or option == 39:
        print("option (0x%x): %s" % (39, "PR_GET_NO_NEW_PRIVS"))
    if option == "PR_GET_TID_ADDRESS" or option == 40:
        print("option (0x%x): %s" % (40, "PR_GET_TID_ADDRESS"))
    if option == "PR_SET_THP_DISABLE" or option == 41:
        print("option (0x%x): %s" % (41, "PR_SET_THP_DISABLE"))
    if option == "PR_GET_THP_DISABLE" or option == 42:
        print("option (0x%x): %s" % (42, "PR_GET_THP_DISABLE"))
    if option == "PR_MPX_ENABLE_MANAGEMENT" or option == 43:
        print("option (0x%x): %s" % (43, "PR_MPX_ENABLE_MANAGEMENT"))
    if option == "PR_MPX_DISABLE_MANAGEMENT" or option == 44:
        print("option (0x%x): %s" % (44, "PR_MPX_DISABLE_MANAGEMENT"))
    if option == "PR_SET_FP_MODE" or option == 45:
        print("option (0x%x): %s" % (45, "PR_SET_FP_MODE"))
    if option == "PR_GET_FP_MODE" or option == 46:
        print("option (0x%x): %s" % (46, "PR_GET_FP_MODE"))
    if option == "PR_CAP_AMBIENT" or option == 47:
        print("option (0x%x): %s" % (47, "PR_CAP_AMBIENT"))
    if option == "PR_SVE_SET_VL" or option == 50:
        print("option (0x%x): %s" % (50, "PR_SVE_SET_VL"))
    if option == "PR_SVE_GET_VL" or option == 51:
        print("option (0x%x): %s" % (51, "PR_SVE_GET_VL"))
    if option == "PR_GET_SPECULATION_CTRL" or option == 52:
        print("option (0x%x): %s" % (52, "PR_GET_SPECULATION_CTRL"))
    if option == "PR_SET_SPECULATION_CTRL" or option == 53:
        print("option (0x%x): %s" % (53, "PR_SET_SPECULATION_CTRL"))
    if option == "PR_PAC_RESET_KEYS" or option == 54:
        print("option (0x%x): %s" % (54, "PR_PAC_RESET_KEYS"))
    if option == "PR_SET_TAGGED_ADDR_CTRL" or option == 55:
        print("option (0x%x): %s" % (55, "PR_SET_TAGGED_ADDR_CTRL"))
    if option == "PR_GET_TAGGED_ADDR_CTRL" or option == 56:
        print("option (0x%x): %s" % (56, "PR_GET_TAGGED_ADDR_CTRL"))
