#!/usr/bin/env bash
# RAM used %, colour-graded, refreshed every 5s.

memory=(
  update_freq=5
  icon="$MEMORY"
  icon.color="$MAUVE"
  script="$PLUGIN_DIR/memory.sh"
  click_script="$PLUGIN_DIR/memory_click.sh"
)

sketchybar --add item memory right \
           --set memory "${memory[@]}"
