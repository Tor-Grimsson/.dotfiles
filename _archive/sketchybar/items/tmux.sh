#!/usr/bin/env bash
# tmux sessions (the plugin renders the label every 2s; attached session marked *).

tmux_item=(
  update_freq=2
  icon="$TMUX"
  icon.color="$GREEN"
  script="$PLUGIN_DIR/tmux.sh"
)

sketchybar --add item tmux right \
           --set tmux "${tmux_item[@]}"
