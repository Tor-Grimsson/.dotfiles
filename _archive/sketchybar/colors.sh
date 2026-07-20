#!/bin/bash
# Gruvbox Dark — warm, less purple, lighter than the old Catppuccin Mocha. Matches the
# ghostty/tmux/nvim/yazi Gruvbox stack. Sourced by sketchybarrc and the plugins. 0xAARRGGBB.

export TRANSPARENT=0x00000000
export BAR_BG=0x00000000       # transparent bar; items carry their own background
export ITEM_BG=0xff282828      # bg0 — default chip background (warm, not near-black)
export TEXT=0xffebdbb2         # fg — cream
export DIM=0xff928374          # gray — inactive

export CHIP_BG=0xff3c3836      # bg1 — occupied (unfocused) workspace chip
export FOCUS_BG=0xfffe8019     # orange — focused workspace chip (matches tmux active border)
export FOCUS_FG=0xff282828     # dark text on the orange chip

# ── accent palette (status colours + icon tints, Gruvbox) ──
export GREEN=0xffb8bb26        # ok / low load
export YELLOW=0xfffabd2f       # mid
export PEACH=0xfffe8019        # warn (orange)
export RED=0xfffb4934          # critical
export BLUE=0xff83a598         # wifi / volume
export TEAL=0xff8ec07c         # cpu (aqua)
export MAUVE=0xffd3869b        # memory / apple (gruvbox's muted purple — warm, not cold)
