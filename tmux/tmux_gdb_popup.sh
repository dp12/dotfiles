#!/usr/bin/env bash

# https://github.com/pl643/tmux-scripts/blob/main/tmux-popup-pane-manager.sh
realpath="$(realpath $0)"

if ! [ -f "$HOME/.tmux_gdb_popup" ]; then
  touch "$HOME/.tmux_gdb_popup"

  addr=$(cat "$@")
  if [[ "$addr" =~ ^[a-fA-F0-9]+$ ]]; then
    addr="0x${addr}"
  fi

  tmux popup -E -w 30 -h 22 -y S -x R "$realpath $addr"
  rm "$HOME/.tmux_gdb_popup"
  exit
fi

addr="$1"

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

show_menu() {
    printf "${RED}Input:${NORMAL} ${GREEN}[$addr]${NORMAL}

${RED}>>Common${NORMAL}
  ${GREEN}[p]${NORMAL}    p/x
  ${GREEN}[s]${NORMAL}    x/s
  ${GREEN}[y/Y]${NORMAL}  yank/insert

${RED}>>Examine${NORMAL}
  ${GREEN}[1]${NORMAL}    x/10gx
  ${GREEN}[2]${NORMAL}    x/20gx
  ${GREEN}[3]${NORMAL}    x/30gx
  ${GREEN}[5]${NORMAL}    x/50gx
  ${GREEN}[!]${NORMAL}    x/100gx
  ${GREEN}[@]${NORMAL}    x/200gx

${RED}>>Breakpoint${NORMAL}
  ${GREEN}[b]${NORMAL}    b *
  ${GREEN}[h]${NORMAL}    hb *
  ${GREEN}[S]${NORMAL}    stb
"
}

show_menu
MAXNUMLOOP=100
COUNTER=0
while [ $COUNTER -lt $MAXNUMLOOP ]; do
  # printf "addr is $addr"
  read -sn1 c || exit
  echo "[$c] was pressed"
  cmd=""
  case $c in
    1) cmd="x/10gx" ;;
    2) cmd="x/20gx" ;;
    3) cmd="x/30gx" ;;
    5) cmd="x/50gx" ;;
    !) cmd="x/100gx" ;;
    @) cmd="x/200gx" ;;
    s) cmd="x/s" ;;
    p) cmd="p/x" ;;
    b) cmd="b *" ;;
    h) cmd="hb *" ;;
    S) cmd="stb" ;;
    y) cmd="yank" ;;
    Y) cmd="yank-insert" ;;
    *) show_menu; echo -n "Invalid command [$c]"; ;;
  esac
  if [[ "$cmd" == "yank"* ]]; then
    echo -n "$addr" | xsel -b
    tmux set-buffer -- "$addr"

    if [ "$cmd" == "yank-insert" ]; then
      tmux send-keys "$addr"
    fi
    exit
  elif [ "$cmd" != "" ]; then
    echo "$cmd" > ~/.tmux_gdb_cmd; echo "$addr" | ~/dotfiles/tmux/tmux_gdb_helper.sh;
    exit
  fi
done
