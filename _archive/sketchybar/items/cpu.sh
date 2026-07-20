#!/usr/bin/env bash
# CPU load %, colour-graded (green → peach → red), refreshed every 2s.

cpu=(
  update_freq=2
  icon="$CPU"
  icon.color="$TEAL"
  script="$PLUGIN_DIR/cpu.sh"
  click_script="$PLUGIN_DIR/cpu_click.sh"
)

sketchybar --add item cpu right \
           --set cpu "${cpu[@]}"
