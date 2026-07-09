#!/bin/bash
# Catppuccin Mocha — matched to the ghostty/nvim/yazi sweep (base darkened to #181825).
# Sourced by sketchybarrc and the plugins. 0xAARRGGBB (AA = alpha).

export TRANSPARENT=0x00000000
export BAR_BG=0x00000000       # transparent bar; items carry their own background
export ITEM_BG=0xff181825      # mantle — default chip background
export TEXT=0xffcdd6f4         # text
export DIM=0xff6c7086          # overlay0 — inactive

export CHIP_BG=0xff313244      # surface0 — occupied (unfocused) workspace chip
export FOCUS_BG=0xffcba6f7     # mauve — focused workspace chip
export FOCUS_FG=0xff181825     # dark text on the mauve chip
