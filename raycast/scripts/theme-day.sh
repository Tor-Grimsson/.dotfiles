#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Set Theme: Day
# @raycast.mode silent

# @raycast.icon ☀️
# @raycast.packageName Appearance

# @raycast.description Force macOS Light mode now.
# @raycast.author Grim

exec "$HOME/.dotfiles/bin/os-mode.sh" -d
