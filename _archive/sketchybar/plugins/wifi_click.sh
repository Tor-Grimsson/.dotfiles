#!/usr/bin/env bash
# Click the wifi chip → toggle a popup of SSID / IP / router. Each row copies its value
# to the clipboard on click. Pure shell (no helper). Popup auto-closes on mouse.exited.global.
source "$HOME/.config/sketchybar/colors.sh"

[ "$MODIFIER" = "alt" ] && { sketchybar --set wifi popup.drawing=off; exit 0; }   # alt-click dismisses
# one popup at a time — close the others first
for it in apple cpu memory volume battery weather brew clock; do sketchybar --set "$it" popup.drawing=off 2>/dev/null; done

dev=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
ssid=$(ipconfig getsummary "$dev" 2>/dev/null | awk -F' : ' '/ SSID :/{print $2; exit}')
ip=$(ipconfig getifaddr "$dev" 2>/dev/null)
router=$(netstat -rn 2>/dev/null | awk '/^default/{print $2; exit}')

# Rebuild the rows fresh each open, then toggle the popup.
sketchybar --remove '/wifi.row\..*/' 2>/dev/null

row=(background.drawing=off label.padding_left=12 label.padding_right=16 label.color="$TEXT")

sketchybar --set wifi popup.drawing=toggle \
  --add item wifi.row.ssid popup.wifi \
  --set wifi.row.ssid "${row[@]}" icon.drawing=off label="  ${ssid:-—}" \
        click_script="printf '%s' '$ssid' | pbcopy; sketchybar --set wifi popup.drawing=off" \
  --add item wifi.row.ip popup.wifi \
  --set wifi.row.ip "${row[@]}" icon.drawing=off label="IP  ${ip:-—}" \
        click_script="printf '%s' '$ip' | pbcopy; sketchybar --set wifi popup.drawing=off" \
  --add item wifi.row.rtr popup.wifi \
  --set wifi.row.rtr "${row[@]}" icon.drawing=off label="RT  ${router:-—}" \
        click_script="printf '%s' '$router' | pbcopy; sketchybar --set wifi popup.drawing=off"
