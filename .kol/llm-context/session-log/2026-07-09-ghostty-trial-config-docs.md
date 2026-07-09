# Session: Ghostty terminal trial — config, brewfile, docs

**Date:** 2026-07-09 (2)
**Agent:** Claude (Grim)
**Summary:** User installed Ghostty (`brew install --cask ghostty`) to trial against iTerm2 (a CPU/resource hog). Tracked it end-to-end: brewfile entry, a new config file symlinked live, bootstrap block, and a catalog reference doc.

## Changes Made

### ghostty setup
- New tracked `ghostty/config` — plain `key = value`. `theme = Catppuccin Macchiato` (bundled, user's pick — sets bg/fg/16-ANSI/cursor/selection); `font-family = MesloLGS NF` (same Nerd Font as iTerm2/p10k); `macos-option-as-alt = true` (keeps Alt-B/F word-nav + fzf Alt-C); `keybind = shift+enter=text:\n` (Claude Code newline — the iTerm three-fault saga, guaranteed here); `clipboard-read = allow` (remote tmux/OSC-52 yanks); `mouse-hide-while-typing` + `window-save-state = always`.
- `brewfile-gui` += `cask "ghostty"` (Browser/terminal/editor group, beside iterm2).
- `bootstrap.sh`: new symlink block after atuin (single-file `~/.config/ghostty/config`, same pattern as atuin/mpd/gcalcli).
- **Live on the iMac:** `~/.config/ghostty/config` symlinked to the repo file. Config validated — `XDG_CONFIG_HOME=~/.dotfiles ghostty +show-config` parsed every key clean, theme resolved.

### docs
- New `documentation/01-shell-terminal/26-ghostty.md` (reference doc, sibling to `01-iterm2`): config-at-a-glance table, what's-set-and-why table, list-themes/reload/validate commands, split/tab keys, iTerm2-retirement future note.
- INDEX bumps: `01-shell-terminal/INDEX.md` (ghostty row under iTerm2, +date), root `documentation/INDEX.md` (cat 01 **22→23**, terminal-emulators cell now names both, +date). AGENT-CONTEXT repo-layout tool count **84→85**.

## Current State

### Working
- Ghostty config is live + validated on the iMac. Catppuccin Macchiato, Meslo, Shift+Enter/Alt/clipboard all set. Reload a running window with `Cmd+Shift+,`.

### Note
- Ghostty inherits Catppuccin Macchiato's ANSI, so the prompt/tmux/yazi/nvim look **different** from iTerm2's coolnight while running in Ghostty — expected (user chose macchiato). iTerm2 is untouched; both terminals coexist during the trial.

## Next Steps
1. **MBP:** `brew bundle --file=~/.dotfiles/brewfile-gui` (installs Ghostty) + bootstrap re-run (symlinks the config). dot-sync carries the files but doesn't install/symlink.
2. If the trial sticks: retire the `iterm2` cask + `iterm/` plist/theme files and drop the iTerm2 doc.
