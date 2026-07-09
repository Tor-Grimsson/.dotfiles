#!/usr/bin/env bash
# Clock — DD/MM HH:MM, refreshed every 10s.

clock=(
  update_freq=10
  icon=""
  script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock right \
           --set clock "${clock[@]}"
