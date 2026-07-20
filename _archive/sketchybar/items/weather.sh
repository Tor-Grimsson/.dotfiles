#!/usr/bin/env bash
# Temperature (wttr.in, IP-geolocated, no API key). Refreshed every 30 min.

weather=(
  update_freq=1800
  icon="$WEATHER"
  icon.color="$YELLOW"
  script="$PLUGIN_DIR/weather.sh"
  click_script="$PLUGIN_DIR/weather_click.sh"
)

sketchybar --add item weather right \
           --set weather "${weather[@]}"
