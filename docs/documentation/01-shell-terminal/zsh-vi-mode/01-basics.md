---
title: Basics — modes, cursor & the off-switch
type: guide
status: active
updated: 2026-07-09
description: The three vi modes, how to move between them, what the cursor shape tells you, and the one-line off-switch — the first ten minutes with command-line vi-mode.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[02-motions-and-editing|Motions & editing]]"
---

# Basics — modes, cursor & the off-switch

## The mental model

vi-mode splits editing into **modes**. In *insert* you type text; in *normal* the letter keys become commands (move, delete, change). This is the one idea vim is built on — you stop holding modifier keys and instead switch modes.

Every new command line starts in **insert** (your config sets `ZVM_LINE_INIT_MODE=insert`), so typing always works immediately. You only enter normal mode when you *want* to edit.

## The three modes

| Mode | Enter with | Cursor | You're doing |
| --- | --- | --- | --- |
| **Insert** | starts here; or `i` `a` `I` `A` `o` `O` from normal | beam `│` | typing |
| **Normal** | `Esc` (or `Ctrl-[`) | block `█` | moving & editing with commands |
| **Visual** | `v` (char) / `V` (line) from normal | block | selecting a range to act on |

**The cursor shape is your mode indicator** — beam means you can type, block means keys are commands. If you ever forget where you are, look at the cursor (or just press `Esc` then `i` to reset to insert).

## Getting into insert mode (the 6 ways)

From normal mode, these all start typing — the difference is *where*:

| Key | Starts insert… |
| --- | --- |
| `i` | before the cursor |
| `a` | after the cursor |
| `I` | at the first non-blank of the line |
| `A` | at the end of the line |
| `o` | on a new line below (rare on a one-line prompt) |
| `O` | on a new line above |

`A` and `I` are the workhorses — jump to the end or start of the command and type.

## Getting out (to normal mode)

- **`Esc`** — the real vim way.
- **`Ctrl-[`** — same thing, keeps your hands on the home row.
- Optional: you can add **`jk`** as an escape alias (type `j` then `k` fast). It's commented in your config — uncomment `ZVM_VI_INSERT_ESCAPE_BINDKEY=jk` in `.zshrc` and `exec zsh` to try. Real `Esc` still works alongside it.

## You're never stuck — emacs keys survive in insert

While you're still learning normal-mode motions, these classic shortcuts still work **in insert mode**, so you can always fall back:

| Key | Does |
| --- | --- |
| `Ctrl-A` / `Ctrl-E` | jump to start / end of line |
| `Ctrl-K` | delete to end of line |
| `Alt-b` / `Alt-f` | move back / forward a word |
| `Alt-⌫` | delete the previous word |

So even on day one you can edit fast, then reach for vim motions as they become reflex.

## The off-switch

vi-mode is a habit change, so it's built as a **toggle**:

```zsh
# shell/.zshrc
VI_MODE=false      # ← flip this
```

Then `exec zsh`. You're back in emacs mode instantly — the plugin isn't sourced, the vi hooks never register, nothing else changes. Flip it back to `true` + `exec zsh` whenever. No uninstall, no cleanup.

## First-ten-minutes drill

1. Type a command, press `Esc` — watch the cursor turn to a block.
2. `A` to jump to the end and keep typing. `Esc` again.
3. `0` then `$` — hop to the start, then the end of the line.
4. `b` `b` `w` — walk backward two words, forward one.
5. `dw` to delete a word; `u` to undo it.
6. `ciw` on a word — it vanishes and you're typing its replacement.
7. `Esc`, `.` — repeat that last change on another word.

Next: [[02-motions-and-editing|Motions & editing]].
