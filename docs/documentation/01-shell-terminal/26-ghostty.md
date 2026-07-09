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
| **Theme** | `Gruvbox Dark` (bundled; sets bg/fg/16-ANSI/cursor/selection) — warm, matches nvim/yazi/tmux/starship |
| **Font** | `MesloLGS NF` at `font-size = 16` (Ghostty's default 13 read small; tune the line or `Cmd +`/`Cmd -` live) |

### What's set and why
| Setting | Why |
|---|---|
| `background = #1d1f20` | Overrides the theme bg to a near-black warm dark (a touch darker than Gruvbox's stock `#282828`), matching nvim so terminal + editor read as one. |
| `theme = Gruvbox Dark` | Bundled theme drives the whole look — prompt, tmux, yazi, nvim all inherit its 16 ANSI slots. Warm (cream/orange/green on `#282828`). Swap for any name from `ghostty +list-themes`. |
| `background-opacity = 0.92`, `background-blur-radius = 12` | Frosted-glass window — slight translucency + blur behind. Set opacity `1.0` for fully solid. |
| `alpha-blending = linear` | Blends text over the translucent bg in gamma-corrected (linear) space instead of macOS `native`. `native` renders text crisp with a dark edge-fringe ("too high-res"); `linear` drops the fringe and thickens light-on-dark text for a softer, fuller look closer to iTerm. `linear-corrected` = native weight minus the fringe. |
| `font-feature = -liga,-calt,-dlig` | Disable ligatures / contextual + discretionary alternates (a no-op on Meslo, kept for parity if the font changes). |
| `font-codepoint-map = U+2591-U+2593=MesloLGS NF` | Force the shade blocks `░▒▓` to render from the font, not Ghostty's built-in block renderer. p10k's "blurred" prompt heads/tails use these; the built-in draws a smooth alpha gradient, the font's glyphs are the dithered checkerboard (the iTerm look). Remove to get the smooth gradient back. |
| `cursor-style = block`, `cursor-style-blink = false`, `cursor-color = cell-foreground`, `cursor-text = cell-background` | Solid non-blinking block cursor that inverts the cell colours under it. |
| `unfocused-split-opacity = 0.55`, `split-divider-color = #504945` | Dim the inactive split; subtle divider in Gruvbox `bg3` warm-grey. |
| `macos-titlebar-style = hidden` | Frameless clean top edge — no native titlebar. |
| `macos-option-as-alt = true` | So shell word-nav (Alt-B/F) and fzf's Alt-C keep working — Option must send Alt, not compose an accented char. |
| Shift+Enter — **no keybind** | Ghostty handles Shift+Enter → newline in Claude Code natively via the Kitty keyboard protocol; a `shift+enter=text:\n` override *breaks* it under tmux (raw newline vs the extended-key sequence tmux forwards), so it's left unbound. Inside tmux also needs `set -s extended-keys on` + `terminal-features '…:extkeys'` — see [[02-tmux|tmux]]. |
| `clipboard-read = allow` | Terminal apps may read the clipboard, so tmux/OSC-52 `y` yanks from a remote box reach the local clipboard (mirrors iTerm2's deliberate "Always Allow"). |
| `window-padding-x = 10`, `window-padding-y = 10`, `window-padding-balance = true` | Breathing room (points) between content and the window edge; `-balance` evens out leftover space so opposite sides match. |
| `confirm-close-surface = false`, `window-decoration = auto` | No confirm prompt when closing a surface/tab; let Ghostty decide window decoration. |
| `mouse-hide-while-typing`, `window-save-state = always` | QoL — hide the pointer while typing; restore windows across quit/relaunch. |
| `auto-update = check`, `auto-update-channel = stable` | Check for updates on the stable channel (check only — doesn't auto-install). |

## How to use
- **First run:** macOS prompts for permissions; allow them. The config is already live via the symlink — no setup screen to click through.
- **Change the theme:** `ghostty +list-themes` to browse (463 bundled), then edit the `theme =` line and reload with `Cmd+Shift+,`.
- **Inspect the resolved config:** `ghostty +show-config` (add `--default --docs` to see every setting with its default and inline docs).
- **Validate an edit without launching a window:** `XDG_CONFIG_HOME=~/.dotfiles ghostty +show-config` reads the repo file directly and reports any bad key.
- **Splits:** `Cmd+D` (right), `Cmd+Shift+D` (down); navigate with `Cmd+Alt+Arrow`. **Tabs:** `Cmd+T`. **Scrollback search:** `Cmd+F`.

## Future use
If the trial sticks, the iTerm2 cask + its `iterm/` plist/theme files can be retired. Ghostty also supports config `keybind` sequences, per-split working dirs, and `config-file` includes for splitting the config — none used yet.
