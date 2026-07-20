#!/usr/bin/env bash
# Output volume %, icon by level. Instant via the volume_change event.

volume=(
  icon="$VOL_HIGH"
  icon.color="$BLUE"
  script="$PLUGIN_DIR/volume.sh"
  click_script="$PLUGIN_DIR/volume_click.sh"
)

sketchybar --add item volume right \
           --set volume "${volume[@]}" \
           --subscribe volume volume_change
