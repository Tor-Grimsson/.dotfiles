#!/usr/bin/env bash
# Focused application name (icon off — label carries the app name).

front_app=(
  icon.drawing=off
  label.padding_left=8 label.padding_right=8
  script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item front_app left \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
