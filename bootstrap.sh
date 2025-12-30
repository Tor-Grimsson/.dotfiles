#!/usr/bin/env bash
set -e

DOT="$HOME/.dotfiles"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages
brew bundle --file="$DOT/Brewfile"

# Ensure SSH dir exists
mkdir -p "$HOME/.ssh"

# Symlink shell + git
ln -sf "$DOT/shell/.zshrc"     "$HOME/.zshrc"
ln -sf "$DOT/shell/.zprofile" "$HOME/.zprofile"
ln -sf "$DOT/git/.gitconfig"  "$HOME/.gitconfig"
ln -sf "$DOT/bin" "$HOME/bin"

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

# macOS defaults
[ -x "$DOT/macos/defaults.sh" ] && "$DOT/macos/defaults.sh"