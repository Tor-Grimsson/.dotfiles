---
title: Visual mode & selections
type: guide
status: active
updated: 2026-07-09
description: Visual mode on the command line — select by character or whole line, extend the selection with motions, and apply an operator (delete/change/yank/surround) to exactly what you highlighted.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[02-motions-and-editing|Motions & editing]]"
  - "[[07-surround|Surround — the full grammar]]"
---

# Visual mode & selections

Visual mode is "select first, act second." Instead of composing a verb with a motion up front (`d3w`), you highlight a range, *see* it, then hit one key to act. It's the friendliest way in while the operator+motion grammar is still landing.

## Entering & leaving

| Key | Enters |
| --- | --- |
| `v` | **character** visual — select char by char |
| `V` | **line** visual — selects the whole command line (one line at the prompt, so `V` = "the lot") |
| `Esc` | leave visual, back to normal |

The cursor is at one end of the selection; move to grow or shrink it.

## Extending the selection

Every motion from [[02-motions-and-editing|chapter 2]] works to extend the highlight:

| Key | Extends by |
| --- | --- |
| `w` / `b` / `e` | word forward / back / to end |
| `0` / `$` | to line start / end |
| `f<c>` / `t<c>` | to the next `<c>` / just before it |
| `h` / `l` | one char left / right |
| `iw` / `i"` / `i(` | snap to a **text object** — inner word / quotes / parens |
| `o` | jump to the **other end** of the selection (to extend the other side) |

`vi"` — enter visual then select inside quotes; `viw` — select the word. These are the same text objects you use with `d`/`c`, just visualized.

## Acting on the selection

Once highlighted, one key operates on it:

| Key | Does |
| --- | --- |
| `d` (or `x`) | delete the selection |
| `c` (or `s`) | change it — delete and drop into insert |
| `y` | yank (copy) it |
| `u` / `U` | lowercase / uppercase the selection |
| `~` | toggle case |
| `S<char>` | **surround** the selection (e.g. `S"` wraps it in quotes) — see [[07-surround|chapter 7]] |
| `p` | replace the selection with the clipboard/register contents |

## Worked examples

| Goal | Keys |
| --- | --- |
| Uppercase a word | `viw` `U` |
| Delete from cursor to the next `/` | `v` `t/` `d` |
| Wrap the whole command in quotes | `V` `S"` |
| Copy the argument inside `(...)` | `vi(` `y` |
| Change everything from here to end of line | `v$` `c` |
| Select a word, extend to the next two words | `viw` `w` `w` |

## When to use it vs operator+motion

- **Visual** when you're not sure how far to go, or want to confirm before acting — you see the range first.
- **Operator+motion** (`d3w`, `ci"`) when you know exactly the target — it's fewer keystrokes and repeatable with `.`.

A visual-mode edit is *not* repeatable with `.` the way `ci"` is, so once a target shape becomes routine, graduate it to the operator form.

Next: [[07-surround|Surround — the full grammar]].
