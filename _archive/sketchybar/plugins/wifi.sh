#!/usr/bin/env bash
# Wi-Fi SSID. Device is detected dynamically (en0 on some Macs, en1 on others).
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Cursor left the bar → close the details popup.
if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set wifi popup.drawing=off
  exit 0
fi

dev=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
ssid=$(ipconfig getsummary "$dev" 2>/dev/null | awk -F' : ' '/ SSID :/{print $2; exit}')

if [ -n "$ssid" ]; then
  sketchybar --set "$NAME" icon="$WIFI_ON" icon.color="$BLUE" label="$ssid"
else
  sketchybar --set "$NAME" icon="$WIFI_OFF" icon.color="$DIM" label="off"
fi
