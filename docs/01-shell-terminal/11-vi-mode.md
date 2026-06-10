---
title: zsh vi-mode
type: reference
status: active
updated: 2026-06-10
description: Modal (vi) keybindings for the zsh line editor via `bindkey -v`. Always-on; Esc only switches sub-mode. Any binding you want in vi-mode must be re-added with `-M viins`.
aliases:
  - vi-mode
  - vi mode
  - bindkey -v
  - viins
  - vicmd
tags:
  - domain/shell/keybindings
  - pattern/cli
links:
  zle: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
  bindkey: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
covers:
  - the `bindkey -v` block in shell/.zshrc (always-on vi keymap)
  - the viins/vicmd sub-mode model + cursor-shape indicator
  - the keymap-swap gotcha (why a binding silently dies under vi-mode)
  - which emacs keys are preserved in insert mode, and the word-nav fix
related:
  - "[[01-iterm2|iTerm2]]"
---

## Summary
`bindkey -v` (end of `shell/.zshrc`) makes the zsh line editor **modal**, matching nvim as `$EDITOR` and [[02-tmux|tmux]] vi copy-mode. It is **always on** from the moment the shell starts — there is no shortcut that toggles vi-mode on or off.

What feels like a "toggle" is **Esc**, and it only switches *sub-mode within* vi-mode:

| Sub-mode | Keymap | You're here when | Cursor |
|---|---|---|---|
| Insert | `viins` | typing a command (default at each new prompt) | beam `▏` |
| Command/normal | `vicmd` | after pressing **Esc** — `hjkl`, `i`/`a`, `w`/`b`, `dd`, etc. work | block `█` |

The cursor shape **is** the mode indicator (`_vi_cursor_shape` via `add-zle-hook-widget`). `KEYTIMEOUT=1` (10 ms) kills the Esc→command lag.

## The keymap-swap gotcha (read this before adding any shortcut)
This is the thing that bites. A bare `bindkey '<seq>' <widget>` binds into the **emacs** keymap (zsh's default `main`). `bindkey -v` then points `main` at **`viins`** — which never received those bindings, so they're silently shadowed.

**Rule: every interactive binding you want under vi-mode must specify `-M viins` (and `-M vicmd` if it should also work in command mode).** A binding with no `-M` is dead the moment vi-mode is active.

This is exactly what broke **Option+Left/Right word-jump**: `^[b`/`^[f` were bound bare (emacs keymap), vi-mode shadowed them, and only Ctrl-b/f (one-char, a viins default) still moved. Fixed by re-binding with `-M viins` — see the table below.

## Bindings kept alive in insert mode
Vi insert mode binds almost nothing by default, so the emacs muscle-memory keys are re-added explicitly in the `shell/.zshrc` vi block:

| Keys | Widget | Does | Notes |
|---|---|---|---|
| `^A` / `^E` | beginning/end-of-line | line start / end | also reachable via **Cmd+←/→** (iTerm sends hex `0x1`/`0x5`) |
| `^K` / `^U` | kill-line / backward-kill-line | cut to end / start of line | |
| `^W` | backward-kill-word | cut previous word | |
| `^?` | backward-delete-char | Backspace past the insert point | |
| `^[b` / `^[f` | backward-word / forward-word | **jump back / forward one word** | **Option+←/→** — iTerm sends `ESC-b`/`ESC-f` |
| `^[^?` | backward-kill-word | delete previous word | **Option+Backspace** |
| `^R` | fzf-history-widget | fuzzy history search | bound in **both** `viins` *and* `vicmd` |

The vi block is sourced **last** in `.zshrc` so it wins over zsh-autosuggestions and zsh-syntax-highlighting.

## The iTerm side (what the keys actually send)
vi-mode binds *sequences*; the terminal decides what each key transmits. The [[01-iterm2|iTerm2]] profile (`New Bookmarks[0]`) sends:

| Key | iTerm action | Sequence | viins binding |
|---|---|---|---|
| Option+← / → | Send ESC seq `b` / `f` | `^[b` / `^[f` | backward-word / forward-word |
| Cmd+← / → | Hex code `0x1` / `0x5` | `^A` / `^E` | beginning/end-of-line |

Left Option = **Normal**, Right Option = **Esc+**, but the per-key overrides above win regardless. So the terminal sends the right bytes — getting word-jump working is purely a matter of having the `-M viins` binding present.

## Why
Modal editing on the command line, consistent with vi everywhere else in the stack (nvim, tmux copy-mode). Esc-then-`b`/`w`/`dd` to surgically edit a long command instead of holding arrow keys.

## Gotchas / future
- **Adding a shortcut?** `-M viins` or it won't fire. This is the #1 trap.
- `KEYTIMEOUT=1` is aggressive; on a laggy SSH link it *can* clip multi-byte escape sequences. Local iTerm is fine — bump to `~20` only if remote arrows misbehave.
- If vi-mode ever earns a rip-out: delete the whole `bindkey -v` block (lines ~251–275) — the main keymap reverts to emacs and the word-nav keys work natively without any `-M viins` babysitting.
