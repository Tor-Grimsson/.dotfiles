#!/usr/bin/env bash
# Renders tmux SESSIONS into the bar item; the attached session is marked with *.
# Called by sketchybar on update_freq.

sessions=$(tmux list-sessions -F '#{session_name}#{?session_attached,*,}' 2>/dev/null | paste -sd ' ' -)
sketchybar --set "$NAME" label="${sessions:-none}"
