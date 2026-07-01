#!/bin/bash

# Re-enable AeroSpace after a `cmd-alt-shift-d` (enable off).
# AeroSpace ignores all keys while disabled, so its own bindings can't bring it
# back — this Raycast hotkey can, because Raycast captures keys system-wide.
# Assign a hotkey to this command in Raycast and it becomes your "resume" key.

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Enable AeroSpace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🪟
# @raycast.packageName AeroSpace

# Documentation:
# @raycast.description Turn AeroSpace window management back on after it was disabled.
# @raycast.author Grim

# Cover both arches' brew bins so the `aerospace` CLI client resolves under
# Raycast's minimal PATH, without hardcoding a single prefix (Intel vs Apple Silicon).
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
exec aerospace enable on
