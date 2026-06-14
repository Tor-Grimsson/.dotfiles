#!/usr/bin/env bash
set -e

DOT="$HOME/.dotfiles"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages
brew bundle --file="$DOT/brewfile"

# Ensure SSH dir exists
mkdir -p "$HOME/.ssh"

# Symlink shell + git
ln -sf "$DOT/shell/.zshrc"     "$HOME/.zshrc"
ln -sf "$DOT/shell/.zprofile" "$HOME/.zprofile"
ln -sf "$DOT/shell/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOT/shell/.nanorc"   "$HOME/.nanorc"
ln -sf "$DOT/git/.gitconfig"  "$HOME/.gitconfig"
ln -sfn "$DOT/bin" "$HOME/bin"

# tmux
[ -f "$DOT/tmux/.tmux.conf" ] && ln -sf "$DOT/tmux/.tmux.conf" "$HOME/.tmux.conf"

# SSH config (no keys)
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

# Claude Code (native installer, not brew)
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Claude config (CLAUDE.md, settings, skills, hooks) — symlinked from repo
if [ -d "$DOT/claude" ]; then
  mkdir -p "$HOME/.claude"
  ln -sf  "$DOT/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
  ln -sf  "$DOT/claude/settings.json" "$HOME/.claude/settings.json"
  ln -sfn "$DOT/claude/skills"        "$HOME/.claude/skills"
  ln -sfn "$DOT/claude/hooks"         "$HOME/.claude/hooks"
  ln -sfn "$DOT/claude/commands"      "$HOME/.claude/commands"
  ln -sfn "$DOT/claude/agents"        "$HOME/.claude/agents"
  ln -sfn "$DOT/claude/output-styles" "$HOME/.claude/output-styles"
fi

# Claude MCP servers — user scope lives in ~/.claude.json, not settings.json
if command -v claude >/dev/null 2>&1; then
  claude mcp add --scope user playwright -- npx @playwright/mcp --headless 2>/dev/null || true
  claude mcp add --scope user glif -e 'GLIF_API_TOKEN=${GLIF_API_TOKEN}' -- npx -y @glifxyz/glif-mcp-server@latest 2>/dev/null || true
fi

# Claude skill dependencies (claude/packages → ~/.local/bin)
if [ -d "$DOT/claude/packages" ]; then
  mkdir -p "$HOME/.local/bin"
  for f in "$DOT/claude/packages"/*; do
    [ -f "$f" ] && [ -x "$f" ] && ln -sf "$f" "$HOME/.local/bin/$(basename "$f")"
  done
fi

# mpv
if [ -d "$DOT/mpv" ]; then
  mkdir -p "$HOME/.config/mpv"
  ln -sf "$DOT/mpv/mpv.conf"   "$HOME/.config/mpv/mpv.conf"
  ln -sf "$DOT/mpv/input.conf" "$HOME/.config/mpv/input.conf"
fi

# nvim (whole dir)
[ -d "$DOT/nvim" ] && ln -sfn "$DOT/nvim" "$HOME/.config/nvim"

# yazi (whole dir — config + plugins + flavors are all tracked, like nvim)
[ -d "$DOT/yazi" ] && ln -sfn "$DOT/yazi" "$HOME/.config/yazi"
if [ -d "$DOT/broot" ]; then
  mkdir -p "$HOME/.config/broot"
  ln -sf "$DOT/broot/conf.hjson"  "$HOME/.config/broot/conf.hjson"
  ln -sf "$DOT/broot/verbs.hjson" "$HOME/.config/broot/verbs.hjson"
  ln -sfn "$DOT/broot/skins"      "$HOME/.config/broot/skins"
fi

# glow config + Finder "Open in glow" Quick Action
if [ -f "$DOT/glow/glow.yml" ]; then
  mkdir -p "$HOME/Library/Preferences/glow"
  ln -sf "$DOT/glow/glow.yml" "$HOME/Library/Preferences/glow/glow.yml"
fi
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

# Terminal.app prefs — import (not symlink; Terminal is cfprefsd-cached). Close Terminal first.
if [ -f "$DOT/terminal/com.apple.Terminal.plist" ]; then
  defaults import com.apple.Terminal "$DOT/terminal/com.apple.Terminal.plist"
fi

# macOS defaults
[ -x "$DOT/macos/defaults.sh" ] && "$DOT/macos/defaults.sh"