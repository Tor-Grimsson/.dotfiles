#!/usr/bin/env bash
# Generic popup builder. Usage: <command> | popup.sh <parent_item>
# Reads rows from stdin (one label per line), styles + toggles the parent's popup.
# Rows are plain monospaced labels — CLI output drops straight in. Click the chip
# again to close. No app is launched; this is the preview.
source "$HOME/.config/sketchybar/colors.sh"
parent="$1"
FONT="MesloLGS Nerd Font Mono"

# one popup at a time — close every other chip's popup before opening this one
for it in apple cpu memory volume wifi battery weather brew clock; do
  [ "$it" != "$parent" ] && sketchybar --set "$it" popup.drawing=off 2>/dev/null
done

# clear any previous rows for this parent
sketchybar --remove "/${parent}\.pop\..*/" 2>/dev/null

args=(--set "$parent"
  popup.background.color="$ITEM_BG"
  popup.background.corner_radius=8
  popup.background.border_width=0
  popup.background.border_color="$CHIP_BG"
  popup.drawing=toggle)

i=0
while IFS= read -r line; do
  args+=(--add item "${parent}.pop.$i" "popup.$parent"
         --set "${parent}.pop.$i" icon.drawing=off background.drawing=off
               label="$line" label.font="$FONT:Regular:11.0"
               label.color="$TEXT" label.padding_left=8 label.padding_right=10
               background.height=18)
  i=$((i+1))
done

sketchybar "${args[@]}" >/dev/null
