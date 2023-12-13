#!/usr/bin/env bash

pwd0="$(tmux display-message -p -F '#{pane_current_path}' -t 0)"
pwd1="$(tmux display-message -p -F '#{pane_current_path}' -t 1)"
id_cur="$(tmux display-message -p -F '#{pane_id}')"
id0="$(tmux display-message -p -F '#D' -t 0)"

if [[ "$id_cur" == "$id0" ]]; then
    echo "$pwd1" | tr -d '\n' > ~/.tmux_buffer_tmp
else
    echo "$pwd0" | tr -d '\n' > ~/.tmux_buffer_tmp
fi
