---
title: AeroSpace
type: reference
status: active
updated: 2026-07-05
description: i3-like tiling window manager for macOS, driven entirely from the keyboard.
aliases:
  - aerospace
tags:
  - domain/productivity
  - pattern/gui
  - pattern/cli
  - integration/brew-cask
links:
  website: https://nikitabobko.github.io/AeroSpace/
  repo: https://github.com/nikitabobko/AeroSpace
  guide: https://nikitabobko.github.io/AeroSpace/guide
  commands: https://nikitabobko.github.io/AeroSpace/commands
  brew: https://formulae.brew.sh/cask/aerospace
covers:
  - Tiling layout + virtual workspaces (no macOS Spaces animation)
  - The Alt-based keymap (focus / move / resize / workspaces / service mode)
  - Config location, auto-assign rules, first-run setup
  - Disabling AeroSpace for apps that need their own shortcuts (off/on hotkeys + Raycast re-enable)
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[01-raycast|Raycast]]"
---

## Summary
AeroSpace is a tiling window manager for macOS in the spirit of i3 — it arranges windows into a non-overlapping tree and switches between **its own** virtual workspaces instead of macOS Spaces (so there's no slow swipe animation). It's a background app controlled by keyboard shortcuts and the `aerospace` CLI; the whole setup lives in one TOML file. Tracked here as `aerospace/aerospace.toml`, symlinked to `~/.config/aerospace/aerospace.toml`.

## Why installed
Keyboard-driven window management without the mouse. Tiling keeps windows laid out automatically, and AeroSpace's virtual workspaces are instant (it emulates them by moving windows off-screen rather than using native Spaces), which is the main reason to pick it over yabai — no SIP disable, no scripting addition.

## Most common use case
`Alt+H/J/K/L` to move focus between tiled windows, `Alt+<number/letter>` to jump to a workspace, `Alt+Shift+<number/letter>` to throw the focused window to one. Apps auto-land on assigned workspaces on launch (see the rules below).

## Biggest win
Zero-privilege install. Unlike yabai it needs no SIP changes — just an Accessibility permission grant — yet still gives full tiling + fast workspaces. One declarative TOML file is the entire config, so it version-controls cleanly and reproduces on the other machine via `brew bundle` + the symlink.

## Config & setup
- **Config file:** `~/.config/aerospace/aerospace.toml` → symlink → `aerospace/aerospace.toml` in the repo. (AeroSpace also reads `~/.aerospace.toml`; we use the `.config` path.)
- **First run:** launch AeroSpace.app and grant **Accessibility** permission (System Settings → Privacy & Security → Accessibility).
- **Reload after editing:** `aerospace reload-config`, or service mode → `Esc` (see table). Config errors surface in the menu-bar icon.
- **Launch at login:** `start-at-login = false` in our config — flip to `true` (or use AeroSpace's menu) to autostart.
- **Gaps:** 10px inner + outer.

## Keymap
`Alt` is the modifier throughout (qwerty preset).

| Keys | Action |
| --- | --- |
| `Alt+H/J/K/L` | Focus window left / down / up / right |
| `Alt+Shift+H/J/K/L` | Move window left / down / up / right |
| `Alt+-` / `Alt+=` | Resize focused window smaller / larger (±50) |
| `Alt+/` | Tiles layout (toggle horizontal/vertical) |
| `Alt+,` | Accordion layout (toggle horizontal/vertical) |
| `Cmd+Alt+G` | **2×2 grid** — two columns of two (one-key macro; tuned for 4 windows) |
| `Cmd+Alt+S` | **Main + stack** — one big window left, the rest stacked in a right column (macro; tuned for 4 windows) |
| `Alt+1`…`9`, `Alt+A`…`Z` | Switch to workspace |
| `Alt+Shift+1`…`9`, `Alt+Shift+A`…`Z` | Move focused window to workspace |
| `Alt+Tab` | Jump to previous workspace (back-and-forth) |
| `Alt+Shift+Tab` | Move current workspace to the next monitor |
| `Alt+Shift+;` | Enter **service mode** |
| `Cmd+Alt+Shift+D` | **Disable** AeroSpace — release all keys to the focused app (re-enable with `Cmd+Alt+Shift+E`, see below) |

> **Grid macros** — AeroSpace has no native grid layout (it's a binary tree, i3-style). `Cmd+Alt+G` / `Cmd+Alt+S` bundle the whole `flatten-workspace-tree` → `join-with` → `layout tiles vertical` / `move` sequence into one binding, with focus pinned to the workspace (`--boundaries workspace --boundaries-action stop`) so it can't wander to another workspace. Built + verified for a flat row of **4** windows; other counts still run (extra focus/join steps are harmless no-ops) but won't tile into a clean grid.

**Service mode** (after `Alt+Shift+;`, each returns to main mode):

| Key | Action |
| --- | --- |
| `Esc` | Reload config + exit |
| `r` | Flatten / reset the workspace layout tree |
| `f` | Toggle floating ↔ tiling for the focused window |
| `Backspace` | Close all windows but the current one |
| `Alt+Shift+H/J/K/L` | Join the focused window with its neighbour |

> Service-mode keys are bare (no Shift needed). `Shift+F` isn't bound here — it collides with the main-mode `Alt+Shift+F` (throw focused window to workspace **F**, one of the `Alt+Shift+A`…`Z` workspace binds). That just relocates the window off-screen to workspace F; it looks like the other window got killed because the remaining one expands to fill the tile.

## Auto-assigned apps
`on-window-detected` rules send apps to a workspace on launch (edit these in the TOML as your app set changes):

| App | Workspace |
| --- | --- |
| iTerm2 | `T` |
| Google Chrome | `B` |
| Firefox Developer Edition | `B` |
| Affinity | `P` |
| Figma | `P` |
| Obsidian | `O` |
| Spotify | `M` |
| Mail | `M` |
| Messages | `S` |
| Finder | `W` |
| Telegram | `A` |
| Todoist | `A` |

## Disabling for apps that need their own shortcuts
Apps like Figma and Affinity bind their own `Alt`-combos, which AeroSpace would otherwise swallow. There is **no per-app keybinding disable** in AeroSpace (that would need Karabiner) — the only way to hand keys back is to turn AeroSpace off globally:

1. **`Cmd+Alt+Shift+D`** → `enable off`. AeroSpace stops managing windows **and** stops intercepting keys, so the app gets every shortcut.
2. Do the thing in the design app.
3. **`Cmd+Alt+Shift+E`** → re-enable.

**Why two different keys:** while disabled, AeroSpace ignores *all* keys, so its own binding can't switch it back on. The re-enable has to come from outside AeroSpace:
- **`Cmd+Alt+Shift+E`** is a **Raycast Script Command** — `raycast/scripts/aerospace-enable.sh` (runs `aerospace enable on`). Add `~/.dotfiles/raycast/scripts` via Raycast → Settings → Extensions → Scripts → **Add Directories**, then record the hotkey on the `Enable AeroSpace` command. Re-add the directory once per machine.
- **Fallback:** `aerospace enable on` in any terminal always works.

> The CLI client is the brew-symlinked `aerospace`, **not** `/Applications/AeroSpace.app/Contents/MacOS/aerospace` (that's the server and rejects `enable on`). The Raycast script puts both arch brew bins on `PATH` so it resolves under Raycast's minimal environment.

Alternative for *tiling-only* exemption (let an app float free but keep AeroSpace's keys live): add an `on-window-detected` rule with `run = 'layout floating'` instead of disabling. `run` takes an array to combine it with a workspace assignment (e.g. `run = ["layout floating", "move-node-to-workspace O"]`) if you want both.

**Currently always-floating** (floating-only, no workspace assignment):

| App | app-id |
| --- | --- |
| TextEdit | `com.apple.TextEdit` |
| Bitwarden | `com.bitwarden.desktop` |
| Claude | `com.anthropic.claudefordesktop` |
| Passwords | `com.apple.Passwords` |

## Future use
Add more `on-window-detected` rules to route apps to dedicated workspaces, `after-startup-command` to lay out a session on login, or per-monitor workspace assignment for the iMac's external display. Pairs with Raycast — Raycast launches, AeroSpace arranges.
