#!/usr/bin/env bash
# Battery %, icon+colour by charge, bolt on AC. Self-hides on desktops (no battery).
# Reacts to plug/unplug (power_source_change) and wake (system_woke); polls every 30s.

battery=(
  update_freq=30
  icon="$BATT_100"
  script="$PLUGIN_DIR/battery.sh"
  click_script="$PLUGIN_DIR/battery_click.sh"
)

sketchybar --add item battery right \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke
