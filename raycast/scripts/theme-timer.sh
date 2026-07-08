#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Theme Timer
# @raycast.mode compact

# @raycast.icon ⏱️
# @raycast.packageName Appearance

# @raycast.argument1 { "type": "text", "placeholder": "3h30m" }

# @raycast.description Flip the theme after a relative delay (e.g. 3h30m, 45m).
# @raycast.author Grim

exec "$HOME/.dotfiles/bin/os-mode.sh" -t "$1"
