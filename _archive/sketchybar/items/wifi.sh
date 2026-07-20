#!/usr/bin/env bash
# Wi-Fi SSID (blue when connected, dim "off" when not). Polled every 15s.

wifi=(
  update_freq=15
  icon="$WIFI_ON"
  icon.color="$BLUE"
  script="$PLUGIN_DIR/wifi.sh"
  click_script="$PLUGIN_DIR/wifi_click.sh"
  popup.background.color="$ITEM_BG"
  popup.background.corner_radius=8
  popup.background.border_width=0
  popup.background.border_color="$CHIP_BG"
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
           --subscribe wifi mouse.exited.global
