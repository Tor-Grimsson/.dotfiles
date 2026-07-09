#!/usr/bin/env bash
# tmux windows across all sessions (the plugin renders the label every 2s).

tmux_item=(
  update_freq=2
  icon=""
  script="$PLUGIN_DIR/tmux.sh"
)

sketchybar --add item tmux right \
           --set tmux "${tmux_item[@]}"
