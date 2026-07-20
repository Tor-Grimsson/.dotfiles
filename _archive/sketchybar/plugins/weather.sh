#!/usr/bin/env bash
# Temperature via wttr.in (IP-geolocated, no API key). Fails soft when offline.
temp=$(curl -s --max-time 4 "wttr.in/?format=%t" 2>/dev/null | tr -d '+ ')
[ -z "$temp" ] && { sketchybar --set "$NAME" label="—"; exit 0; }
sketchybar --set "$NAME" label="$temp"
