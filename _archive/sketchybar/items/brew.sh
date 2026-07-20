#!/usr/bin/env bash
# Outdated Homebrew package count (hidden when up to date). Checked every 30 min.
# Click runs `brew upgrade` in a Ghostty window.

brew_item=(
  update_freq=1800
  icon="$BREW"
  icon.color="$PEACH"
  drawing=off
  script="$PLUGIN_DIR/brew.sh"
  click_script="$PLUGIN_DIR/brew_click.sh"
)

sketchybar --add item brew right \
           --set brew "${brew_item[@]}"
