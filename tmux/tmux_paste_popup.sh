#!/usr/bin/env bash

# https://github.com/pl643/tmux-scripts/blob/main/tmux-popup-pane-manager.sh
realpath="$(realpath $0)"

if ! [ -f "$HOME/.tmux_paste_popup" ]; then
  touch "$HOME/.tmux_paste_popup"

  tmux popup -E -w 50 -h 25 -y S -x R "$realpath"
  rm "$HOME/.tmux_paste_popup"
  exit
fi

# Create tmux pastebuf structures if they do not exist
if ! [ -d "$HOME"/.tmux/pastebuf ]; then
  mkdir -p "$HOME"/.tmux/pastebuf
  for i in {0..9}; do
    touch "$HOME"/.tmux/pastebuf/b${i}
  done
fi

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

TMUX_PASTEBUF_PREVIEW_CHARS=35

get_user_pastebuf() {
  reply=$(bash -c "read -n 1 c; echo \$c")
  if [[ "$reply" =~ [0-9] ]]; then
    echo "~/.tmux/.pastebuf/b${reply}"
  fi
}

show_menu() {
  local b0="$(cat ~/.tmux/pastebuf/b0 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b1="$(cat ~/.tmux/pastebuf/b1 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b2="$(cat ~/.tmux/pastebuf/b2 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b3="$(cat ~/.tmux/pastebuf/b3 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b4="$(cat ~/.tmux/pastebuf/b4 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b5="$(cat ~/.tmux/pastebuf/b5 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b6="$(cat ~/.tmux/pastebuf/b6 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b7="$(cat ~/.tmux/pastebuf/b7 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b8="$(cat ~/.tmux/pastebuf/b8 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"
  local b9="$(cat ~/.tmux/pastebuf/b9 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"

  # Truncate preview to one line and <= max preview chars
  local tmux_pastebuf="$(tmux show-buffer 2>&1)"
  local tmux_pastebuf_preview="$(echo $tmux_pastebuf | head -n1 | head -c${TMUX_PASTEBUF_PREVIEW_CHARS})"

  printf "${RED}>>Paste Buffers${NORMAL}
  ${GREEN}[0]${NORMAL}  ${b0}...
  ${GREEN}[1]${NORMAL}  ${b1}...
  ${GREEN}[2]${NORMAL}  ${b2}...
  ${GREEN}[3]${NORMAL}  ${b3}...
  ${GREEN}[4]${NORMAL}  ${b4}...
  ${GREEN}[5]${NORMAL}  ${b5}...
  ${GREEN}[6]${NORMAL}  ${b6}...
  ${GREEN}[7]${NORMAL}  ${b7}...
  ${GREEN}[8]${NORMAL}  ${b8}...
  ${GREEN}[9]${NORMAL}  ${b9}...

${RED}>>Commands${NORMAL}
  ${GREEN}[a]${NORMAL}  add from clipboard
       (${tmux_pastebuf_preview}...)
  ${GREEN}[s]${NORMAL}  add from selection
  ${GREEN}[h]${NORMAL}  add from history
  ${GREEN}[e]${NORMAL}  edit pastebuf
  ${GREEN}[x]${NORMAL}  swap pastebufs
  ${GREEN}[q]${NORMAL}  quit
"
}

show_menu
while : ; do
  read -sn1 c || exit
  echo "[$c] was pressed"

  cmd=""
  case $c in
    [0-9]) tmux send-keys "$(cat ~/.tmux/pastebuf/b${c})"; exit ;;
    a)
      if [ "$tmux_pastebuf" = "" ]; then
        clear
        show_menu
        echo -n "nothing in tmux paste buffer"
      else
        while : ; do
          echo -n "pastebuf (0-9): "
          reply=$(bash -c "read -n 1 c; echo \$c")
          if [[ "$reply" =~ [0-9] ]]; then
            echo "$(tmux show-buffer 2>&1)" > ~/.tmux/pastebuf/"b${reply}"
            clear
            show_menu
            break
          fi
        done
      fi ;;
    s)
      while : ; do
        echo -n "pastebuf (0-9): "
        reply=$(bash -c "read -n 1 c; echo \$c")
        if [[ "$reply" =~ [0-9] ]]; then
          tmux send -X copy-pipe 'read inp; echo $inp > '"~/.tmux/pastebuf/b${reply}"''
          clear
          show_menu
          break
        fi
      done ;;
    h)
      while : ; do
        echo -n "pastebuf (0-9): "
        reply=$(bash -c "read -n 1 c; echo \$c")
        if [[ "$reply" =~ [0-9] ]]; then
          histitem=$(cat ~/.zhistory | cut -d';' -f2- | tac | awk '!x[$0]++' | tac | fzf --no-sort --tac)
          if [ ! -z "$histitem" ]; then
              echo -n "$histitem" > ~/.tmux/pastebuf/b${reply}
          fi
          clear
          show_menu
          break
        fi
      done ;;
    e|v)
      while : ; do
        echo -n "pastebuf (0-9): "
        reply=$(bash -c "read -n 1 c; echo \$c")
        if [[ "$reply" =~ [0-9] ]]; then
          vim ~/.tmux/pastebuf/"b${reply}"
          clear
          show_menu
          break
        fi
      done ;;
    x)
      echo -n "Swap pastebufs: >"
      pb1=$(bash -c "read -n 1 c; echo \$c")
      if [[ $pb1 =~ [0-9] ]]; then
        echo -n " >"
        pb2=$(bash -c "read -n 1 c; echo \$c")
        if [[ $pb2 =~ [0-9] ]]; then
          TMPFILE=$(mktemp ~/.tmux/pastebuf/XXXXXX)
          mv ~/.tmux/pastebuf/"b${pb1}" $TMPFILE
          mv ~/.tmux/pastebuf/"b${pb2}" ~/.tmux/pastebuf/"b${pb1}"
          mv $TMPFILE ~/.tmux/pastebuf/"b${pb2}"
        fi
      fi
      clear
      show_menu
      ;;
    q) exit ;;
    *) clear; show_menu; echo -n "Invalid command [$c]"; ;;
  esac
done
