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
ln -sf "$DOT/git/.gitconfig"  "$HOME/.gitconfig"
ln -sfn "$DOT/bin" "$HOME/bin"

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

# glow config + Finder "Open in glow" Quick Action
if [ -f "$DOT/glow/glow.yml" ]; then
  mkdir -p "$HOME/Library/Preferences/glow"
  ln -sf "$DOT/glow/glow.yml" "$HOME/Library/Preferences/glow/glow.yml"
fi
if [ -d "$DOT/macos/services/Open in glow.workflow" ]; then
  mkdir -p "$HOME/Library/Services"
  ln -sfn "$DOT/macos/services/Open in glow.workflow" "$HOME/Library/Services/Open in glow.workflow"
  /System/Library/CoreServices/pbs -flush 2>/dev/null || true
fi

# macOS defaults
[ -x "$DOT/macos/defaults.sh" ] && "$DOT/macos/defaults.sh"