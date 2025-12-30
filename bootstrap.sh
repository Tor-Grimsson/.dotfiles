#!/usr/bin/env bash
set -e

# install brew (if missing)
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install packages
brew bundle --file="$HOME/.dotfiles/Brewfile"

# restore VS Code extensions
if command -v code >/dev/null; then
  cat "$HOME/.dotfiles/vscode/extensions.txt" | xargs -n 1 code --install-extension || true
fi
