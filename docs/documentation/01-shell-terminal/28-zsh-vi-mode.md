---
title: zsh-vi-mode
type: reference
status: active
updated: 2026-07-09
description: Modal (vi/vim) editing for the zsh command line via the zsh-vi-mode plugin — near-native vim motions, text objects, surround, and a system-clipboard yank, with cursor-shape mode indication. Gated behind a VI_MODE flag with a one-line off-switch. Config verified against the upstream README.
aliases:
  - zsh-vi-mode
  - vi mode
  - zvm
tags:
  - domain/shell
  - integration/brew-formula
links:
  repo: https://github.com/jeffreytse/zsh-vi-mode
  brew: https://formulae.brew.sh/formula/zsh-vi-mode
covers:
  - the VI_MODE toggle + the exact go-live / bail commands
  - modes, mode-switching, and a learner cheat-sheet of motions to drill
  - how the plugin re-binds keys (zvm_after_init) and what's preserved (fzf/atuin/history)
  - the zvm_config options in use (cursor, ZVM_TERM, insert-init) + the jk escape option
related:
  - "[[zsh-vi-mode/INDEX|zsh vi-mode — complete guide]]"
  - "[[25-atuin|atuin]]"
  - "[[12-fzf|fzf]]"
  - "[[11-neovim-cheatsheet|Neovim cheatsheet]]"
---

## Summary

`zsh-vi-mode` turns the zsh command line into a modal (vim) editor — you type in **insert mode**, press `Esc` for **normal mode**, and get real vim motions (`w`, `b`, `ciw`, `dt/`, `ys`, visual mode, `.` repeat) right on the prompt. It's a pure-zsh plugin (no dependencies) that improves on zsh's raw `bindkey -v`: a **cursor-shape mode indicator**, faster mode switching, text objects, surround, and a system-clipboard yank.

**Why it's here:** you're in the terminal all day but not in nvim daily — running modal editing on every command line is a forcing function to build vim muscle memory that transfers straight to [[11-neovim-cheatsheet|nvim]].

**The commitment worry is handled.** It is a *toggle*, not a one-way door — one flag (`VI_MODE=false`) plus `exec zsh` puts you back in emacs mode instantly. See [The off-switch](#the-off-switch).

## Setup

Installed via Homebrew (`brewfile-cli`: `brew "zsh-vi-mode"`), sourced near the end of `shell/.zshrc` behind a `VI_MODE` guard. The whole block is inert until the formula is installed **and** `VI_MODE=true`.

| To… | Do |
| --- | --- |
| **Go live** | `brew install zsh-vi-mode` → `exec zsh` |
| **Turn it off** | in `shell/.zshrc` set `VI_MODE=false` → `exec zsh` (back to emacs mode, nothing else changes) |
| **Turn it back on** | `VI_MODE=true` → `exec zsh` |

Load order matters and is already correct: the block sits **after** `zsh-autosuggestions` and **before** `zsh-syntax-highlighting` (which must stay last). The plugin postpones its own init to the first prompt (its documented way of sidestepping source-order bugs), so the other plugins load cleanly.

## The off-switch

```zsh
VI_MODE=true    # ← flip to false, then `exec zsh`
```

That's the entire commitment surface. `false` skips the `source` line, the `zvm_config`/`zvm_after_init` hooks never register, and your emacs keymap (the default) stands. No uninstall needed, no other edits.

## How modal editing works

Two modes you'll live in (plus visual):

| Mode | Enter it with | You're doing |
| --- | --- | --- |
| **Insert** | `i` `a` `I` `A` `o` `O` (from normal); every new prompt starts here | typing normally |
| **Normal** | `Esc` (or `Ctrl-[`) | moving + editing with motions |
| **Visual** | `v` (char) / `V` (line) from normal | selecting a range, then operate on it |

The **cursor shape tells you the mode** — beam `│` in insert, block `█` in normal. Each new command line starts in **insert** (`ZVM_LINE_INIT_MODE=insert`), so typing always Just Works; press `Esc` only when you want to edit.

## Learn it — the how-to guide

The full, read-in-order how-to lives in the companion folder **[[zsh-vi-mode/INDEX|zsh vi-mode — complete guide]]** (basics → motions & editing → power features & your setup). The ten you'll use most:

| Key | Does |
| --- | --- |
| `Esc` | insert → normal mode |
| `A` / `I` | insert at end / start of line |
| `w` / `b` / `0` / `$` | word forward/back · line start/end |
| `f<c>` | jump to next `<c>` |
| `dd` / `dw` / `x` | delete line / word / char |
| `ciw` / `ci"` | change the word / inside quotes |
| `u` / `Ctrl-r` | undo / redo |
| `.` | repeat the last change |
| `ysiw"` | wrap the word in quotes (surround) |
| `vv` | edit the line in nvim, save to run |

> Escape hatch while learning: `^A` `^E` `^K` and word-nav still work **in insert mode** (kept on purpose, below), so you're never stuck. Also `keys vimode` prints the drill list any time.

## What's preserved (and how)

zsh-vi-mode **re-initializes zle at the first prompt**, which wipes keybindings set earlier in `.zshrc`. The upstream-documented fix is to re-apply them in the `zvm_after_init` hook — which the config does, so nothing you rely on is lost:

| Preserved | Key(s) |
| --- | --- |
| fzf | `Ctrl-R` (history), `Ctrl-T` (files), `Alt-C` (cd) |
| [[25-atuin|atuin]] | `Ctrl-P`, `Shift-Up` |
| History tiers | `Up`/`Down` prefix search, `Opt-Up`/`Down` plain history |
| emacs line-nav **in insert mode** | `^A` `^E` `^K` `^W`-ish, `Alt-b`/`Alt-f`, `Alt-⌫` |

Normal/visual-mode custom binds (if ever added) go in a **`zvm_after_lazy_keybindings`** hook instead — the plugin lazy-loads those keymaps on first entry to normal mode.

## Config reference

Two functions the plugin auto-calls (both in `shell/.zshrc`):

**`zvm_config()`** — runs during sourcing; the only correct place for options referencing plugin-defined vars.

| Option | Value | Why |
| --- | --- | --- |
| `ZVM_TERM` | `xterm-256color` | emit cursor-shape sequences that survive tmux (README flags this as per-emulator important) |
| `ZVM_NORMAL_MODE_CURSOR` | `$ZVM_CURSOR_BLOCK` | block cursor = normal mode |
| `ZVM_INSERT_MODE_CURSOR` | `$ZVM_CURSOR_BEAM` | beam cursor = insert mode |
| `ZVM_LINE_INIT_MODE` | `$ZVM_MODE_INSERT` | every prompt starts in insert — friendlier while learning |

**`zvm_after_init()`** — runs after the first-prompt re-init; re-applies the preserved binds above.

**Other knobs** (not set, documented for later):

- `ZVM_VI_INSERT_ESCAPE_BINDKEY=jk` — add `jk` as an Esc alias (real `Esc` still works). Commented in the config; uncomment to try.
- `ZVM_KEYTIMEOUT` (default `0.4`s) — the plugin manages its own timeout; do **not** set zsh's `KEYTIMEOUT`.
- `ZVM_INIT_MODE=sourcing` — init at source time instead of first prompt (only if a plugin-ordering bug appears).
- `ZVM_LAZY_KEYBINDINGS=false` — bind normal/visual keys eagerly (slower startup; only if needed).

## tmux notes

Your `tmux.conf` is already vi-mode-ready — `escape-time 10` (`:25`, no Esc lag), `mode-keys vi` (`:118`, same motions in copy-mode), and clipboard passthrough. The one thing to verify on first boot is the **cursor shape** changing inside tmux. If it doesn't, add one line to `tmux/.tmux.conf`:

```tmux
set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[ q'
```

Even without it, the block/beam still works outside tmux, and you always have the mode implicitly (each line starts in insert).

## Verify on first boot

After `brew install zsh-vi-mode` + `exec zsh`, confirm:

- [ ] Prompt starts in insert; `Esc` → block cursor, `i` → beam cursor.
- [ ] `Ctrl-R` (fzf), `Ctrl-P` (atuin), `Up` prefix search all still work.
- [ ] `zsh-autosuggestions` grey text still appears (if not, it needs re-init — flag it).
- [ ] Cursor shape changes inside tmux (else add the tmux override above).
- [ ] `VI_MODE=false` + `exec zsh` cleanly reverts to emacs mode.

## Why installed

Deliberate skill-building: modal editing everywhere the terminal goes, so vim motions become reflex without living in nvim. Kept behind a flag because it's a real habit change — the off-switch means trying it costs nothing.

## Related
- [[11-neovim-cheatsheet|Neovim cheatsheet]] — the same motions in their native home; the transfer target.
- [[25-atuin|atuin]] / [[12-fzf|fzf]] — the history/finder binds preserved through `zvm_after_init`.
