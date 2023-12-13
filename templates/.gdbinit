source ~/.gdb_pwn_funcs
source ~/dotfiles/python-scripts/gdb_python_cmds.py


# procb: set breakpoint via proc/<pid>/maps
# Arguments:
# pidof process, binary name
#
# qemu-aarch64, vuln
#PROC_MAP_BREAKPOINT_MARKER

define fb
#BREAKPOINT_INSERT_MARKER
end

define fbb
end

# TODO: insert command to f1 macro (this file or gdbfile)
define fa
  p/x $al
end

define f1
  f1q
  x/10gx $rbp-0x3d
#F1_INSERT_MARKER
end

define f2
  f2q
  x/50wx 0xffffd2cc
#F2_INSERT_MARKER
end

define f3
  f3q
  x/10gx 0x7fffffffe200
#F3_INSERT_MARKER
end

define fbc
  fb
  c
end

pwnn
