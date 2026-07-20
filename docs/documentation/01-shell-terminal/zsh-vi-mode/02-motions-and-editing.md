---
title: Motions & editing
type: guide
status: active
updated: 2026-07-09
description: The core of command-line vi — every movement (word/char/line/find), the verb+object edit grammar, text objects, and undo/redo/repeat/yank. These are identical in nvim, so every rep counts twice.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[01-basics|Basics]]"
  - "[[03-power-and-setup|Power features & your setup]]"
  - "[[11-neovim-cheatsheet|Neovim cheatsheet]]"
---

# Motions & editing

All of this is normal mode (press `Esc` first). Every key here behaves the same in nvim.

## Moving around

**By word**

| Key | Moves to |
| --- | --- |
| `w` | start of the next word |
| `b` | start of the previous word |
| `e` | end of the current/next word |
| `W` `B` `E` | same, but WORD = whitespace-separated (ignores punctuation) |

**By line**

| Key | Moves to |
| --- | --- |
| `0` | very start of the line (column 0) |
| `^` | first non-blank character |
| `$` | end of the line |

**By find** — the fastest horizontal moves; learn these early.

| Key | Moves to |
| --- | --- |
| `f<c>` | onto the next `<c>` (e.g. `f/` jumps to the next `/`) |
| `t<c>` | just before the next `<c>` |
| `F<c>` `T<c>` | same, backwards |
| `;` | repeat the last `f`/`t` |
| `,` | repeat it in the opposite direction |

## The edit grammar: verb + object

vim editing is a little language: a **verb** (operator) plus an **object** (a motion or a text object). Learn a few verbs and a few objects and you get every combination for free.

**Verbs (operators)**

| Verb | Does |
| --- | --- |
| `d` | delete |
| `c` | change (delete, then drop into insert) |
| `y` | yank (copy) |

**Objects = a motion**

| Combo | Effect |
| --- | --- |
| `dw` | delete to the start of the next word |
| `d$` (or `D`) | delete to end of line |
| `d0` | delete to start of line |
| `dt/` | delete up to (not including) the next `/` |
| `df=` | delete up to and including the next `=` |
| `cw` / `C` | change word / change to end of line |
| `y$` | yank to end of line |

Whole-line shortcuts double the verb: **`dd`** delete line, **`cc`** change line, **`yy`** yank line.

## Text objects — the real power

Instead of a motion, an object can be a *thing*: a word, a quoted string, a bracket pair. The pattern is **`<verb>` + `i`/`a` + `<thing>`**, where `i` = **inner** (contents) and `a` = **around** (contents + delimiters).

| Combo | Effect |
| --- | --- |
| `ciw` | change the whole word you're on (cursor anywhere in it) |
| `diw` | delete the word (no trailing space) |
| `daw` | delete **a** word (with its trailing space) |
| `ci"` | change what's inside the `"…"` |
| `ci(` / `ci)` | change inside the parentheses |
| `ci{` `ci[` | change inside braces / brackets |
| `da(` | delete around parens (contents **and** the `()`) |
| `cit` | change inside a tag (for `<x>…</x>`) |

`ci"` from anywhere on the line — cursor doesn't even need to be inside the quotes; it finds the next pair. This one edit replaces "select the string, delete it, retype" with three keys.

## Undo, redo, repeat

| Key | Does |
| --- | --- |
| `u` | undo the last change |
| `Ctrl-r` | redo |
| **`.`** | **repeat the last change** — the single biggest time-saver |

`.` is worth its own paragraph. Did `ciwfoo<Esc>`? Move to another word, press `.`, it becomes `foo` too. Deleted `da(`? `.` deletes the next parens group. Make a change once, repeat it everywhere.

## Yank & paste

| Key | Does |
| --- | --- |
| `yy` | yank the whole line |
| `yw` `y$` | yank a word / to end of line |
| `p` | paste after the cursor |
| `P` | paste before the cursor |
| `x` | delete (and yank) the char under the cursor |

Yank/delete share the same register, so `dd` then `p` = "cut this line, paste it there." System-clipboard integration is covered in [[03-power-and-setup|chapter 3]].

## Counts — do it N times

Put a number before almost anything to repeat it:

| Combo | Effect |
| --- | --- |
| `3w` | forward 3 words |
| `2dd` | delete 2 lines |
| `d3w` | delete 3 words |
| `5x` | delete 5 chars |
| `10p` | paste 10 times |

Next: [[03-power-and-setup|Power features & your exact setup]].
