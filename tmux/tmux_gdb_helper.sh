#!/bin/env bash

target=$(cat "$@")
if [[ "$target" =~ ^[a-fA-F0-9]+$ ]]; then
  target="0x${target}"
elif [[ "$target" =~ ^[a-z]+$ ]]; then
  target="\$${target}"
fi

cmd="$(cat ~/.tmux_gdb_cmd)"
if [[ $cmd == *'*' ]]; then
  # for breakpoints, don't add space after the asterisk, e.g. b *0xdeadbeef
  send_str="${cmd}${target}"
else
  send_str="${cmd} ${target}"
fi

tmux send-keys "$send_str" Enter
