---
title: Ghostty
type: reference
status: active
updated: 2026-07-09
description: GPU-accelerated, config-file-driven macOS/Linux terminal emulator — trialing as a lighter-weight replacement for iTerm2.
aliases:
  - ghostty
tags:
  - domain/shell
  - pattern/gui
  - integration/brew-cask
links:
  website: https://ghostty.org/
  repo: https://github.com/ghostty-org/ghostty
  manual: https://ghostty.org/docs
  config: https://ghostty.org/docs/config/reference
  brew: https://formulae.brew.sh/cask/ghostty
covers:
  - Where the tracked config lives and how it's symlinked
  - The settings that are set, and why (theme, option-as-alt, Shift+Enter, clipboard)
  - Reloading, listing themes, and inspecting the resolved config
related:
  - "[[01-iterm2|iTerm2]]"
  - "[[02-tmux|tmux]]"
  - "[[03-powerlevel10k|powerlevel10k]]"
---

## Summary
Ghostty is a fast, GPU-accelerated terminal emulator (written in Zig by Mitchell Hashimoto). Unlike iTerm2's GUI-driven preferences, it is configured entirely from a plain-text file — one `key = value` per line — which makes it a clean fit for this dotfiles repo.

## Why installed
Being trialed as a replacement for [[01-iterm2|iTerm2]], which is a CPU/resource hog. Ghostty renders on the GPU and starts lean, so the bet is a smoother everyday terminal for the same job — hosting the shell, prompt, tmux, and the TUIs that run inside them.

## Config, at a glance
The whole configuration is one tracked file. No GUI-only state to export (the trap that bit iTerm2's plist).

| | |
|---|---|
| **Tracked file** | `ghostty/config` |
| **Symlinked to** | `~/.config/ghostty/config` (by `bootstrap.sh`) |
| **Reload after edit** | `Cmd+Shift+,` in a running window (or quit + relaunch) |
| **Theme** | `Catppuccin Macchiato` (bundled; sets bg/fg/16-ANSI/cursor/selection) |
| **Font** | `MesloLGS NF` — same Nerd Font iTerm2 + powerlevel10k use |

### What's set and why
| Setting | Why |
|---|---|
| `theme = Catppuccin Macchiato` | Bundled theme drives the whole look — prompt, tmux, yazi, nvim all inherit its 16 ANSI slots. Swap for any name from `ghostty +list-themes`. |
| `macos-option-as-alt = true` | So shell word-nav (Alt-B/F) and fzf's Alt-C keep working — Option must send Alt, not compose an accented char. |
| `keybind = shift+enter=text:\n` | Shift+Enter inserts a newline in Claude Code. Ghostty speaks the Kitty keyboard protocol so this usually works natively; the explicit bind guarantees it (a three-fault saga to get working in iTerm2 — see [[01-iterm2|iTerm2]]). |
| `clipboard-read = allow` | Terminal apps may read the clipboard, so tmux/OSC-52 `y` yanks from a remote box reach the local clipboard (mirrors iTerm2's deliberate "Always Allow"). |
| `mouse-hide-while-typing`, `window-save-state = always` | QoL — hide the pointer while typing; restore windows across quit/relaunch. |

## How to use
- **First run:** macOS prompts for permissions; allow them. The config is already live via the symlink — no setup screen to click through.
- **Change the theme:** `ghostty +list-themes` to browse (463 bundled), then edit the `theme =` line and reload with `Cmd+Shift+,`.
- **Inspect the resolved config:** `ghostty +show-config` (add `--default --docs` to see every setting with its default and inline docs).
- **Validate an edit without launching a window:** `XDG_CONFIG_HOME=~/.dotfiles ghostty +show-config` reads the repo file directly and reports any bad key.
- **Splits:** `Cmd+D` (right), `Cmd+Shift+D` (down); navigate with `Cmd+Alt+Arrow`. **Tabs:** `Cmd+T`. **Scrollback search:** `Cmd+F`.

## Future use
If the trial sticks, the iTerm2 cask + its `iterm/` plist/theme files can be retired. Ghostty also supports config `keybind` sequences, per-split working dirs, and `config-file` includes for splitting the config — none used yet.
