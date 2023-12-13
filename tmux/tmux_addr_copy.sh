#!/bin/env bash

addr=$(cat "$@")
if [[ "$addr" =~ ^[a-fA-F0-9]+$ ]]; then
  addr="0x${addr}"
fi
default_dest="$(cat ~/.fastgdb/fastgdb_default_dest)"
default_bp="$(grep '^#BP_TYPE' ~/.gdbinit | cut -d',' -f2)"
linum=$(cat -n ~/.fastgdb/fastgdb_bp | sed -n "/g${default_dest}/,/end/p" | tail -n1 | tr -s ' ' | cut -f1)
sed -i "${linum}i ${default_bp} *${addr}" ~/.fastgdb/fastgdb_bp
