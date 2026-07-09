#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════════════
# bootstrap.sh — FULL setup for a daily-driver Mac. Runs bootstrap-cli.sh (the
# CLI toolchain + dotfile symlinks) first, then layers on everything that is
# macOS-only: GUI cask apps, VS Code, iTerm/Terminal prefs, macOS defaults,
# launchd agents, and Finder Quick Actions.
#
# On a foreign box you only SSH into, run bootstrap-cli.sh directly instead —
# it does the CLI half and skips everything below that mutates macOS state.
# See docs/operations/01-dotfiles/ for the CLI-vs-GUI split and the symlink model.
#
# RESILIENT (no `set -e`): failing steps are recorded and skipped, not fatal.
# bootstrap-cli.sh (sourced below) provides FAILED/note_fail/summarize; the
# combined summary of everything that didn't install prints at the very end.
# ════════════════════════════════════════════════════════════════════════════

DOT="$HOME/.dotfiles"

# ── CLI toolchain + dotfile symlinks (shared with the standalone CLI setup) ──
source "$DOT/bootstrap-cli.sh"

# ═════════════════════════════════════════════════════════════════════════════
# GUI / macOS-only from here down: cask apps, `defaults` writes, launchd agents,
# Quick Actions. None of this is run by bootstrap-cli.sh.
# ═════════════════════════════════════════════════════════════════════════════

# GUI packages (casks + VS Code extensions)
brew bundle --file="$DOT/brewfile-gui" || note_fail "brew bundle (brewfile-gui — see output above)"

# Git hooks (post-commit: mirror docs/ into the kol-vault rsync copy on change)
if [ -d "$DOT/.git" ]; then
  chmod +x "$DOT/git-hooks/"* 2>/dev/null || true
  ln -sf "$DOT/git-hooks/post-commit" "$DOT/.git/hooks/post-commit"
fi

# SSH config (no keys)
mkdir -p "$HOME/.ssh"
if [ -f "$DOT/ssh/config" ]; then
  ln -sf "$DOT/ssh/config" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config" || true
fi

# VS Code
if command -v code >/dev/null 2>&1; then
  mkdir -p "$HOME/Library/Application Support/Code/User"
  ln -sf "$DOT/vscode/settings.json" \
    "$HOME/Library/Application Support/Code/User/settings.json" 2>/dev/null || true
  ln -sf "$DOT/vscode/keybindings.json" \
    "$HOME/Library/Application Support/Code/User/keybindings.json" 2>/dev/null || true
  cat "$DOT/vscode/extensions.txt" | xargs -n 1 code --install-extension || true
fi

# iTerm2
if [ -d "$DOT/iterm" ]; then
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOT/iterm"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  # Save changes: Manually — never auto-write the repo plist (keys are NoSync*, machine-local)
  defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
  defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 1
fi

# Claude MCP servers — user scope lives in ~/.claude.json, not settings.json
if command -v claude >/dev/null 2>&1; then
  claude mcp add --scope user playwright -- npx @playwright/mcp --headless 2>/dev/null || true
  claude mcp add --scope user glif -e 'GLIF_API_TOKEN=${GLIF_API_TOKEN}' -- npx -y @glifxyz/glif-mcp-server@latest 2>/dev/null || true
fi

# Claude plugins — runtime state (the cloned repos + *.json) lives in ~/.claude/plugins
# and is NOT tracked; we reproduce the intent here, same as the MCP block above.
if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace add DietrichGebert/ponytail 2>/dev/null || true
  claude plugin install ponytail@ponytail 2>/dev/null || true
fi

# aerospace (tiling window manager — single config file)
if [ -d "$DOT/aerospace" ]; then
  mkdir -p "$HOME/.config/aerospace"
  ln -sf "$DOT/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
fi

# fastfetch (shell-home — whole dir: config.jsonc + chafa logo.txt + source image)
if [ -d "$DOT/fastfetch" ]; then
  mkdir -p "$HOME/.config"
  ln -sfn "$DOT/fastfetch" "$HOME/.config/fastfetch"
fi

# tmuxinator (shell-layout dashboards — whole dir of *.yml project configs)
if [ -d "$DOT/tmuxinator" ]; then
  mkdir -p "$HOME/.config"
  ln -sfn "$DOT/tmuxinator" "$HOME/.config/tmuxinator"
fi

# gcalcli (single config file — the OAuth token lives beside it in this dir and
# is machine-local, so only config.toml is symlinked, not the whole dir)
if [ -d "$DOT/gcalcli" ]; then
  mkdir -p "$HOME/Library/Application Support/gcalcli"
  ln -sf "$DOT/gcalcli/config.toml" "$HOME/Library/Application Support/gcalcli/config.toml"
fi

# mpd + rmpc (terminal music). Single-file symlinks — mpd's db/state/log/playlists
# live locally in ~/.config/mpd/ (untracked), so only the config file is linked.
if [ -d "$DOT/mpd" ]; then
  mkdir -p "$HOME/.config/mpd/playlists"
  ln -sf "$DOT/mpd/mpd.conf" "$HOME/.config/mpd/mpd.conf"
fi
if [ -d "$DOT/rmpc" ]; then
  mkdir -p "$HOME/.config/rmpc"
  ln -sf "$DOT/rmpc/config.ron" "$HOME/.config/rmpc/config.ron"
fi

# atuin (shell-history search — single config file; history.db/key/session live in
# ~/.local/share/atuin/, untracked/machine-local, so only config.toml is symlinked)
if [ -d "$DOT/atuin" ]; then
  mkdir -p "$HOME/.config/atuin"
  ln -sf "$DOT/atuin/config.toml" "$HOME/.config/atuin/config.toml"
fi

# Finder Quick Actions (macos/services/*.workflow) — includes "Open in glow"
if [ -d "$DOT/macos/services" ]; then
  mkdir -p "$HOME/Library/Services"
  for wf in "$DOT/macos/services/"*.workflow; do
    [ -d "$wf" ] || continue
    ln -sfn "$wf" "$HOME/Library/Services/$(basename "$wf")"
  done
  /System/Library/CoreServices/pbs -flush 2>/dev/null || true
fi

# dot-sync launchd agent — auto-sync this repo every 30 min (bin/dot-sync.sh --auto)
# Copied, not symlinked: launchd is unreliable with symlinked plists on modern macOS.
if [ -f "$DOT/macos/launchd/com.kolkrabbi.dot-sync.plist" ]; then
  mkdir -p "$HOME/Library/LaunchAgents"
  cp "$DOT/macos/launchd/com.kolkrabbi.dot-sync.plist" "$HOME/Library/LaunchAgents/"
  launchctl bootout "gui/$(id -u)/com.kolkrabbi.dot-sync" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.kolkrabbi.dot-sync.plist"
fi

# tg-inbox launchd agent — poll the Telegram capture bot every 2 min (bin/tg-inbox.sh)
# Copied, not symlinked (launchd dislikes symlinked plists). Needs ~/.secrets with the tokens.
if [ -f "$DOT/macos/launchd/com.kolkrabbi.tg-inbox.plist" ]; then
  mkdir -p "$HOME/Library/LaunchAgents"
  cp "$DOT/macos/launchd/com.kolkrabbi.tg-inbox.plist" "$HOME/Library/LaunchAgents/"
  launchctl bootout "gui/$(id -u)/com.kolkrabbi.tg-inbox" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.kolkrabbi.tg-inbox.plist"
fi

# mpd launchd agent — mount-guarded (only runs while the external library drive is
# mounted; KeepAlive→PathState). Copied, not symlinked (launchd dislikes symlinked plists).
if [ -f "$DOT/macos/launchd/com.kolkrabbi.mpd.plist" ]; then
  mkdir -p "$HOME/Library/LaunchAgents"
  cp "$DOT/macos/launchd/com.kolkrabbi.mpd.plist" "$HOME/Library/LaunchAgents/"
  launchctl bootout "gui/$(id -u)/com.kolkrabbi.mpd" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.kolkrabbi.mpd.plist"
fi

# Terminal.app prefs — import (not symlink; Terminal is cfprefsd-cached). Close Terminal first.
if [ -f "$DOT/terminal/com.apple.Terminal.plist" ]; then
  defaults import com.apple.Terminal "$DOT/terminal/com.apple.Terminal.plist"
fi

# macOS defaults
[ -x "$DOT/macos/defaults.sh" ] && "$DOT/macos/defaults.sh"
