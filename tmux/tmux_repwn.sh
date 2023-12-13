#!/usr/bin/env bash
# 1. run strings *.py | grep qemu
# NON-QEMU (want only one pane)
# tmux list-panes | wc -l to get number of panes
# if two panes, kill right pane by sending C-c C-c C-c C-d
# run C-c C-c C-c
# run up and enter

# QEMU PATH
# tmux list-panes | wc -l to get number of panes
# if one pane, cancel out existing pane with C-c C-c C-c and create new pane
# if two panes, cancel out right pane with C-c C-c C-c C-d; then cancel out left pane with C-c C-c C-c
# then, run up and enter
#
# echo "Hello from repwn!"
# TODO: handle case where nkp is dead, but pwndbg is alive

# Kill any stray gdb processes
pkill -9 -f ./gdb

echo "tmux_repwn log start at $(date)" > ~/.tmux_repwn_log
pwd0="$(tmux display-message -p -F '#{pane_current_path}' -t 0)"

# if strings *.py | grep -q qemu; then
# echo "$pwd0"

leftcmd="nka"
rightcmd="gmul"
qemu="None"
leftcmd="$(grep '^#REPWN' ~/.gdbinit | cut -d',' -f2)"
rightcmd="$(grep '^#REPWN' ~/.gdbinit | cut -d',' -f3)"
qemu="$(grep '^#REPWN' ~/.gdbinit | cut -d',' -f4)"
if ! [[ "$qemu" == qemu* ]]; then
  echo "No qemu [$qemu] in repwn file" >> ~/.tmux_repwn_log
  qemu="None"
fi

#if strings ${pwd0}/*.py | grep -q qemu; then
if ! [ $qemu == "None" ]; then
  echo "Got qemu! # panes is $(tmux list-panes | wc -l)" >> ~/.tmux_repwn_log
  if [ "$(tmux list-panes | wc -l)" -eq 2 ]; then
     echo "Two panes" >> ~/.tmux_repwn_log
     tmux respawn-pane -c $pwd0 -k -t right
     tmux respawn-pane -c $pwd0 -k -t left
     tmux send-keys -t left "$leftcmd" Enter
     tmux send-keys -t right "$rightcmd" Enter
  else
     echo "One pane" >> ~/.tmux_repwn_log
     tmux respawn-pane -c $pwd0 -k -t left
     tmux send-keys -t left "$leftcmd" Enter
     tmux split-window -h
     tmux send-keys -t right "$rightcmd" Enter
  fi
else
  echo "No qemu! # panes is $(tmux list-panes | wc -l)" >> ~/.tmux_repwn_log
  echo "Respawning left pane" >> ~/.tmux_repwn_log
  tmux respawn-pane -c $pwd0 -k -t left
  if [ "$(tmux list-panes | wc -l)" -eq 2 ]; then
    echo "No qemu; two panes --> killing right pane" >> ~/.tmux_repwn_log
    tmux kill-pane -t right
  fi
  echo "Sending $leftcmd to left pane" >> ~/.tmux_repwn_log
  tmux send-keys -t left "$leftcmd" Enter
fi
tmux select-pane -t right
