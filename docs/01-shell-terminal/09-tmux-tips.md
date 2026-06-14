---
title: tmux tips & tricks
type: guide
status: active
updated: 2026-06-14
audience: internal
description: Day-to-day tmux beyond the basics — copy mode explained in full (scroll, search, select, copy to the macOS clipboard), plus pane, window, and session tricks tuned to this repo's ~/.tmux.conf.
aliases:
  - tmux-tips
  - tmux-tricks
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[02-tmux|tmux]]"
  - "[[10-tmux-help|tmux help & cheat sheet]]"
---

# tmux tips & tricks

## Purpose

The moves that make tmux fast once the basics click — copy mode (scrolling and grabbing text), and the pane / window / session tricks worth muscle memory. Tuned to this repo's [[02-tmux|tmux]] config, so the keys below assume `~/.tmux.conf` is in place.

## Prerequisites

- tmux installed and `~/.dotfiles/tmux/.tmux.conf` symlinked to `~/.tmux.conf` — see [[02-tmux|tmux]].
- **The prefix is `Ctrl-b`.** Every command is `Ctrl-b` then a key; written `prefix` below. Press `Ctrl-b`, let go, then the key.
- The config sets `mode-keys vi`, so copy mode moves like vim.

## Copy mode — scroll, search, and grab text

**What it is.** Normally a pane only shows the latest output and your keystrokes go straight to the shell. **Copy mode** freezes the pane and turns it into a navigable buffer of everything that scrolled past — you move a cursor through the history, select text, and copy it. While you're in copy mode, typing moves the cursor instead of reaching the shell; you leave when you're done.

**Enter it** two ways:

- `prefix [` — enter at the bottom of the buffer.
- **Scroll up with the mouse** — the config's `mouse on` drops you into copy mode automatically.

**Move around** (vi-style, because `mode-keys vi`):

| Key | Moves |
|---|---|
| `h` `j` `k` `l` / arrows | left / down / up / right |
| `w` / `b` | forward / back one word |
| `0` / `$` | start / end of line |
| `Ctrl-u` / `Ctrl-d` | half a page up / down |
| `g` / `G` | top / bottom of the buffer |

**Search the scrollback** — this is where copy mode earns its keep when you need output from 200 lines ago:

| Key | Does |
|---|---|
| `/` | search **forward** (type a word, Enter) |
| `?` | search **backward** |
| `n` / `N` | jump to next / previous match |

**Select and copy** (the config's bindings):

| Key | Does |
|---|---|
| `v` | start selecting (move to extend the selection) |
| `Ctrl-v` | toggle **block** (rectangular) selection |
| `y` | copy the selection to the **macOS clipboard** via `pbcopy`, and leave copy mode |
| mouse drag | select; on release it copies to the clipboard too |

After `y`, the text is on your real clipboard — `⌘V` pastes it into any app.

**Paste back into a pane:** `prefix ]` pastes tmux's own copy buffer (the last thing you copied) at the cursor.

**Leave copy mode:** `q` (or `Esc`).

> **Mouse selection vs the terminal's own:** with `mouse on`, dragging selects tmux's text. To use your terminal emulator's native selection instead (e.g. to copy across panes as one rectangle), hold **Option** (iTerm2's bypass modifier) while dragging.

## Pane tricks

```text
prefix z      zoom the current pane to fullscreen — press again to un-zoom
prefix x      close (kill) the current pane          (asks to confirm)
prefix {      swap pane with the previous one
prefix }      swap pane with the next one
prefix !      break the current pane out into its own new window
prefix space  cycle through the built-in layouts (see Pane layouts below)
prefix q      flash each pane's number; tap the number to jump to it
```

`prefix z` (zoom) is the one you'll reach for constantly — focus one pane fullscreen, then pop back to the split.

## Pane layouts — arrange splits automatically

Once a window has several panes, stop dragging borders by hand. tmux has five preset layouts: `prefix space` cycles through them, and `select-layout` jumps straight to one. The names describe the **direction panes spread**, not the split lines — which trips everyone up at first.

| Layout | Arrangement |
|---|---|
| `even-horizontal` | equal **width**, side by side — spreads left → right (columns) |
| `even-vertical` | equal **height**, stacked — spreads top → bottom (rows) |
| `main-horizontal` | one large pane on **top**, the rest in a row below |
| `main-vertical` | one large pane on the **left**, the rest stacked on the right |
| `tiled` | even grid in both directions |

```text
prefix space                            cycle through all five layouts
prefix :  select-layout even-vertical   jump straight to one
prefix :  select-layout tiled
```

From the shell it targets the active window:

```sh
tmux select-layout even-horizontal
tmux select-layout tiled
```

**Sizing the main pane.** The `main-*` layouts read the big pane's size from the `main-pane-width` / `main-pane-height` options — set the option, *then* select the layout:

```text
prefix :  set -w main-pane-height 30    # top pane = 30 rows
prefix :  select-layout main-horizontal
```

Put `set -wg main-pane-height 30` in `~/.tmux.conf` (then `prefix r`) to make that the default main-pane size everywhere. It tunes the `main-*` layouts — it does **not** auto-apply a layout to new windows; you still pick one with `prefix space` or `select-layout`.

## Window tricks

```text
prefix c      new window (opens in the current folder)
prefix ,      rename the current window
prefix 1..9   jump to window by number
prefix n / p  next / previous window
prefix w      pick a window from an interactive list
prefix &      close (kill) the current window         (asks to confirm)
prefix .      move the current window to a different number
```

Names beat numbers once you have a few windows open — `prefix ,` and call it `edit`, `server`, `logs`.

## Session tricks

The whole point of tmux: sessions outlive the terminal.

```sh
tmux new -s work      # start a named session "work"
tmux ls               # list running sessions
tmux a -t work        # reattach to "work"
tmux a                # reattach to the most recent session
```

From inside tmux:

```text
prefix d      detach — leave the session running in the background
prefix s      interactive session switcher (also previews each session's windows)
prefix $      rename the current session
```

A clean loop: `tmux new -s <project>` to start, `prefix d` to step away, `tmux a -t <project>` to come back to it exactly as you left it.

## Handy one-offs

```text
prefix r      reload ~/.tmux.conf after editing it (flashes "tmux.conf reloaded")
prefix ?      list every key binding (q to close) — the built-in cheat sheet
prefix t      big clock (q to dismiss)
prefix :      command prompt — type any tmux command directly
```

**Type the same keystrokes into every pane at once** (handy for the same command across several servers):

```text
prefix :  setw synchronize-panes on     # turn it on
prefix :  setw synchronize-panes off    # turn it off
```

## Troubleshooting

- **Colours look flat / wrong.** Your outer terminal must support true colour for the `RGB` override to bite — fine in iTerm2/WezTerm/Ghostty/Kitty/Alacritty, not in plain Terminal.app. Harmless either way.
- **`y` didn't reach the clipboard.** The copy binding pipes to `pbcopy`; confirm `echo hi | pbcopy && pbpaste` works in a plain shell. If it does, reload the config with `prefix r`.
- **Edited the config but nothing changed.** tmux only reads `~/.tmux.conf` on server start — run `prefix r` (or `tmux kill-server` and reopen) to apply edits.
- **Mouse drag selects the wrong thing.** That's tmux's selection winning over the terminal's; hold **Option** to fall back to the native selection.
