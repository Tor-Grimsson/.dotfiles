#!/usr/bin/env bash
# macOS defaults — sane baseline for this setup.
# Idempotent and safe to re-run. Some changes need a logout/restart; the killall
# at the end restarts Finder/Dock/SystemUIServer to apply the rest immediately.
set -euo pipefail

echo "Applying macOS defaults…"

# ── Finder ────────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true            # always show file extensions
defaults write com.apple.finder AppleShowAllFiles -bool true               # show hidden / dotfiles
defaults write com.apple.finder ShowPathbar -bool true                     # bottom path bar
defaults write com.apple.finder ShowStatusBar -bool true                   # status bar (item count, free space)
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true         # full POSIX path in window title
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"        # default to list view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"        # search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # no nag when changing an extension
defaults write com.apple.finder _FXSortFoldersFirst -bool true             # keep folders on top
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # no .DS_Store on network shares
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true      # no .DS_Store on USB volumes
chflags nohidden "$HOME/Library" 2>/dev/null || true                       # unhide ~/Library

# ── Keyboard & text ─────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2                             # fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15                     # short delay before repeat kicks in
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false         # repeat held keys instead of accent popup
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false      # dev-friendly: no auto-capitalize
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # no auto-correct
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false   # no smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false    # no smart dashes
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false  # no double-space → period

# ── Screenshots ───────────────────────────────────────────────────────────────
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots" # save to ~/Screenshots, not Desktop
defaults write com.apple.screencapture type -string "png"                   # PNG format
defaults write com.apple.screencapture disable-shadow -bool true            # no window drop-shadow border

# ── Dock ────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true                          # auto-hide the Dock
defaults write com.apple.dock autohide-delay -float 0                      # show instantly on hover
defaults write com.apple.dock autohide-time-modifier -float 0.15           # faster show/hide animation
defaults write com.apple.dock show-recents -bool false                     # no recent-apps section
defaults write com.apple.dock minimize-to-application -bool true           # minimize windows into the app icon
defaults write com.apple.dock mru-spaces -bool false                       # don't auto-reorder Spaces
defaults write com.apple.dock tilesize -int 48                             # icon size
defaults write com.apple.dock appswitcher-all-displays -bool true          # cmd-tab switcher on EVERY display, not just the main one

# ── Rectangle (window snapping) ─────────────────────────────────────────────
# Replaced Magnet 2026-08-01. Magnet had NO gap or margin setting at all and its
# whole keymap lived in an opaque plist blob; Rectangle exposes every setting as
# a `defaults` key, which is the only reason the geometry can live here.
#
# The numbers MIRROR aerospace's [gaps] so a floating window and a tiled one sit
# on the same grid: 304 right clears the Übersicht widget column (280 + 12 + 12),
# 48 top clears the bar. screenEdgeGapsOnMainScreenOnly confines those two to the
# iMac, matching aerospace's `[{ monitor.main = N }, 10]` arrays — Rectangle has
# no true per-display values, main-vs-rest is as fine as it gets.
defaults write com.knollsoft.Rectangle gapSize -float 24                   # gutter BETWEEN windows
defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 48            # = aerospace outer.top (bar strip)
defaults write com.knollsoft.Rectangle screenEdgeGapRight -int 304         # = aerospace outer.right (widget column)
defaults write com.knollsoft.Rectangle screenEdgeGapLeft -int 10           # = aerospace outer.left
defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int 10         # = aerospace outer.bottom
defaults write com.knollsoft.Rectangle screenEdgeGapsOnMainScreenOnly -bool true  # 304/48 apply to the iMac only
defaults write com.knollsoft.Rectangle applyGapsToMaximize -int 2          # Maximize honours the gaps instead of filling the screen
defaults write com.knollsoft.Rectangle launchOnLogin -bool true

# Shortcuts — Magnet's keymap, rehomed. modifierFlags are COCOA masks, not Carbon:
#   ctrl 262144 · alt 524288 · cmd 1048576 · shift 131072
#   786432  = ctrl+alt   (Magnet's band — kept ONLY where aerospace doesn't use it)
#   1310720 = cmd+ctrl   (free: aerospace has zero cmd-ctrl binds)
# The four arrows, enter and backspace were never contested, so they stay exactly
# where the fingers already know them. The ten letters WERE contested — aerospace
# owns ctrl-alt-{u,i,j,k,d,f,g,e,t,c} for workspaces/focus and wins every one, so
# they move to cmd-ctrl with the SAME letter.
_rect() { defaults write com.knollsoft.Rectangle "$1" -dict-add keyCode -float "$2" modifierFlags -float "$3"; }
_rect leftHalf   123 786432   # ctrl-alt-←
_rect rightHalf  124 786432   # ctrl-alt-→
_rect topHalf    126 786432   # ctrl-alt-↑
_rect bottomHalf 125 786432   # ctrl-alt-↓
_rect almostMaximize 36 786432 # ctrl-alt-⏎  (almost, not maximize — this one honours the gaps)
_rect restore     51 786432   # ctrl-alt-⌫
_rect topLeftQuarter     32 1310720   # cmd-ctrl-u
_rect topRightQuarter    34 1310720   # cmd-ctrl-i
_rect bottomLeftQuarter  38 1310720   # cmd-ctrl-j
_rect bottomRightQuarter 40 1310720   # cmd-ctrl-k
_rect firstThird      2 1310720       # cmd-ctrl-d
_rect secondThird     3 1310720       # cmd-ctrl-f
_rect thirdThird      5 1310720       # cmd-ctrl-g
_rect firstTwoThirds 14 1310720       # cmd-ctrl-e
_rect lastTwoThirds  17 1310720       # cmd-ctrl-t
_rect center          8 1310720       # cmd-ctrl-c
unset -f _rect
# Rectangle's Todo feature defaults to ctrl-alt-n / ctrl-alt-b = aerospace workspaces N and B.
defaults delete com.knollsoft.Rectangle toggleTodo 2>/dev/null || true
defaults delete com.knollsoft.Rectangle reflowTodo 2>/dev/null || true
defaults write com.knollsoft.Rectangle todo -bool false

# ── Save / print panels ─────────────────────────────────────────────────────
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false # default new docs to disk, not iCloud

# ── Trackpad ──────────────────────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true  # tap to click
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ── Services shortcuts ───────────────────────────────────────────────────────
# Quick Actions (macos/services/, symlinked by bootstrap.sh).
# key_equivalent glyphs: @ cmd, $ shift, ~ option, ^ control
defaults write pbs NSServicesStatus -dict-add '"(null) - Open in TextEdit - runWorkflowAsService"' \
  '{key_equivalent = "$~^e"; enabled_services_menu = 1; presentation_modes = {ContextMenu = 1; ServicesMenu = 1;};}'   # ⇧⌥⌃E
defaults write pbs NSServicesStatus -dict-add '"(null) - Select Every Other - runWorkflowAsService"' \
  '{key_equivalent = "$~^a"; enabled_services_menu = 1; presentation_modes = {ContextMenu = 1; ServicesMenu = 1;};}'   # ⇧⌥⌃A
defaults write pbs NSServicesStatus -dict-add '"(null) - Select Every Other (Even) - runWorkflowAsService"' \
  '{key_equivalent = "$~^s"; enabled_services_menu = 1; presentation_modes = {ContextMenu = 1; ServicesMenu = 1;};}'   # ⇧⌥⌃S
/System/Library/CoreServices/pbs -flush 2>/dev/null || true

echo "Restarting Finder, Dock, SystemUIServer…"
for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1 || true; done
echo "Done. A few changes (key-repeat, some Finder bits) need a logout/restart to fully take effect."
