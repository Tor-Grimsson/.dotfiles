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

# ── Save / print panels ─────────────────────────────────────────────────────
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false # default new docs to disk, not iCloud

# ── Trackpad ──────────────────────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true  # tap to click
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Restarting Finder, Dock, SystemUIServer…"
for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1 || true; done
echo "Done. A few changes (key-repeat, some Finder bits) need a logout/restart to fully take effect."
