#!/usr/bin/env bash
# Apple logo (far left) → click toggles a dropdown popup with power/session actions.
# Actions live in plugins/power.sh. Popup auto-closes after the action runs.

apple=(
  icon="$APPLE"
  icon.font="$FONT:Black:16.0"
  icon.color="$MAUVE"
  label.drawing=off
  background.drawing=off
  padding_left=8 padding_right=12
  click_script="$PLUGIN_DIR/apple_click.sh"
  popup.background.color="$ITEM_BG"
  popup.background.corner_radius=8
  popup.background.border_width=0
  popup.background.border_color="$CHIP_BG"
)

sketchybar --add item apple left \
           --set apple "${apple[@]}"

# Popup rows — icon + label, each wired to a power.sh action.
row=(
  background.drawing=off
  icon.padding_left=12 icon.padding_right=8
  label.padding_right=16
  icon.color="$TEXT" label.color="$TEXT"
)

sketchybar --add item apple.lock popup.apple \
           --set apple.lock "${row[@]}" icon="$I_LOCK" label="Lock Screen" \
                 click_script="$PLUGIN_DIR/power.sh lock" \
           --add item apple.sleep popup.apple \
           --set apple.sleep "${row[@]}" icon="$I_SLEEP" label="Sleep" \
                 click_script="$PLUGIN_DIR/power.sh sleep" \
           --add item apple.logout popup.apple \
           --set apple.logout "${row[@]}" icon="$I_LOGOUT" label="Log Out" \
                 click_script="$PLUGIN_DIR/power.sh logout" \
           --add item apple.restart popup.apple \
           --set apple.restart "${row[@]}" icon="$I_RESTART" label="Restart" \
                 click_script="$PLUGIN_DIR/power.sh restart" \
           --add item apple.shutdown popup.apple \
           --set apple.shutdown "${row[@]}" icon="$I_SHUTDOWN" icon.color="$RED" label="Shut Down" \
                 click_script="$PLUGIN_DIR/power.sh shutdown"
