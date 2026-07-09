#!/usr/bin/env bash
# Renders tmux windows (across all sessions) into the bar item; active window gets a *.
# Matches the tabs in tmux's own status line. Called by sketchybar on update_freq.

windows=$(tmux list-windows -a -F '#{window_index}:#{window_name}#{?window_active,*,}' 2>/dev/null | paste -sd ' ' -)
sketchybar --set "$NAME" label="${windows:-none}"
