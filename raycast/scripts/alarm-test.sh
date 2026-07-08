#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Run Wake-Up Alarm Now
# @raycast.mode silent

# @raycast.icon ⏰
# @raycast.packageName Appearance

# @raycast.description Fire the theme-alarm.sh bundle immediately, for testing.
# @raycast.author Grim

exec "$HOME/.dotfiles/bin/theme-alarm.sh" --test
