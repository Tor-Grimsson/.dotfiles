#!/usr/bin/env bash
# Clock — DD/MM HH:MM, refreshed every 10s.

clock=(
  update_freq=10
  icon="$CLOCK"
  script="$PLUGIN_DIR/clock.sh"
  click_script="$PLUGIN_DIR/clock_click.sh"
)

sketchybar --add item clock right \
           --set clock "${clock[@]}"
