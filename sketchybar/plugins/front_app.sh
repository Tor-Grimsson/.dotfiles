#!/bin/sh
# On front_app_switched the app name arrives in $INFO. On the initial --update there's
# no event, so fall back to querying the current frontmost process once.

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
else
  app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
  [ -n "$app" ] && sketchybar --set "$NAME" label="$app"
fi
