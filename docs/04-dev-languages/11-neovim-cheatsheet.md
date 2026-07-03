---
title: Neovim cheatsheet (beginner)
type: guide
status: active
updated: 2026-07-02
audience: internal
description: Zero-assumptions beginner reference for writing and navigating text in Neovim — modes, moving the cursor, editing, selecting, search/replace, the panic button, and the most-used shortcuts from this repo's config.
aliases:
  - nvim-cheatsheet
  - neovim-beginner
  - vim-basics
tags:
  - domain/dev/editor
  - pattern/tui
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[10-neovim-config|Neovim config (IDE setup)]]"
  - "[[03-neovim|Neovim]]"
---

# Neovim cheatsheet (beginner)

Assumes you've never used vim. Read top to bottom once, then keep it open while you work. For the full keybind tables and plugin list, see [Neovim config (IDE setup)](10-neovim-config.md).

## The one thing to understand: modes

Neovim has **modes**. The same key does different things depending on which mode you're in. This is what trips up everyone at the start.

| Mode | What it's for | How you get there | You'll know because |
|---|---|---|---|
| **Normal** | Moving around + running commands. **This is home.** | `Esc` (or `jk`) from any mode | letters move the cursor / run commands instead of typing |
| **Insert** | Actually typing text | `i`, `a`, `o` (see below) | `-- INSERT --` shows at the bottom; keys type normally |
| **Visual** | Selecting text | `v`, `V`, `Ctrl-v` | `-- VISUAL --` at the bottom; text highlights as you move |
| **Command** | Typing `:` commands (save, quit, search-replace) | `:` from Normal | a `:` appears at the very bottom line |

**The golden rule:** if keys are doing something weird, you're in the wrong mode. **Press `Esc`** to get back to Normal mode, then try again. When in doubt, `Esc`.

## Get text in (Normal → Insert)

You don't type in Normal mode. Press one of these first, type your text, then `Esc` (or `jk`) to go back:

| Key | Starts typing… |
|---|---|
| `i` | **before** the cursor |
| `a` | **after** the cursor (append) |
| `I` | at the **start** of the line |
| `A` | at the **end** of the line |
| `o` | on a **new line below** |
| `O` | on a **new line above** |

`jk` (typed fast) is set up in this config as a shortcut for `Esc`.

## Save & quit (Normal mode, type the `:` first)

| Command | Does |
|---|---|
| `:w` | save (write) |
| `:w name.txt` | save with a filename (new files) |
| `:q` | quit |
| `:wq` or `:x` | save **and** quit |
| `:q!` | quit and **throw away** unsaved changes |
| `:wqa` | save and quit **everything** (all splits/tabs) |

**Repeating a `:` command.** Typed something you want to run again? Press `:` then `↑` (or `Ctrl-p`) to bring back your last command — keep pressing to go further back, same idea as shell history. Better yet: from Normal mode, press **`q:`** to open the **command-line window** — a real editable buffer listing everything you've typed after `:`. Move to the line you want, edit it if needed, press `Enter` to run it. `q` closes the window without running anything.

## Move the cursor (Normal mode)

Arrow keys work, but the home-row way is faster:

| Key | Moves |
|---|---|
| `h` `j` `k` `l` | left, down, up, right |
| `w` / `b` | forward / back one **word** |
| `0` / `$` | start / end of the **line** |
| `gg` / `G` | top / bottom of the **file** |
| `5G` | go to **line 5** (any number) |
| `Ctrl-d` / `Ctrl-u` | half a page down / up |
| `{` / `}` | previous / next paragraph (blank-line gap) |
| `%` | jump to the matching bracket `()` `[]` `{}` |

The numbers on the left are **relative** — `j` is "down 1", and the number next to a line is how far it is, so `5j` jumps down 5.

## Edit text (Normal mode)

Most edits are a **verb + a target**. `d` = delete, `c` = change (delete then type), `y` = yank (copy). The target is a motion like `w` (word) or `iw` (inner word).

| Key | Does |
|---|---|
| `x` | delete one character |
| `dd` | delete (cut) the whole line |
| `dw` / `diw` | delete to next word / the word you're on |
| `cw` / `ciw` | change word (deletes it, drops you in Insert) |
| `yy` | yank (copy) the line |
| `p` / `P` | paste after / before the cursor |
| `u` | **undo** |
| `Ctrl-r` | **redo** |
| `r` | replace the single character under the cursor |
| `.` | **repeat the last change** (hugely useful) |

**Counts work everywhere:** `3dd` deletes 3 lines, `2w` jumps 2 words. Pattern = *number + command*.

## Select text (Visual mode)

Press to start selecting, move to extend, then act:

1. `v` (character select) · `V` (whole lines) · `Ctrl-v` (block/column)
2. move with `h j k l w $` etc. to grow the selection
3. then: `y` copy · `d` delete · `c` change · `>` / `<` indent right/left

## Find & replace

| Key / command | Does |
|---|---|
| `/word` then `Enter` | search forward for "word" |
| `n` / `N` | next / previous match |
| `*` | search for the word under the cursor |
| `:noh` (or `<leader>nh`) | clear the leftover search highlight |
| `:s/old/new/` | replace first "old" on the current line |
| `:s/old/new/g` | replace **all** on the current line |
| `:%s/old/new/g` | replace all in the **whole file** |
| `:%s/old/new/gc` | …and **confirm** each one (`y`/`n`) |

## This setup's shortcuts (Leader = `Space`)

These come from the plugins. Press `Space`, then the keys. The handful you'll use first:

| Key | Does |
|---|---|
| `<leader>ee` | toggle the file tree (open/close) |
| `<leader>ff` | fuzzy-find and open a file by name |
| `<leader>fs` | search text across the whole project |
| `<leader>sv` / `<leader>sh` | split the window vertical / horizontal |
| `Ctrl-h/j/k/l` | jump between splits |
| `<leader>mp` | auto-format the file |
| `gd` / `K` | (in code) go to definition / show docs popup |

Full tables for LSP, git, diagnostics, etc. live in [Neovim config (IDE setup)](10-neovim-config.md).

## When you're stuck (panic button)

- **Keys acting weird?** → `Esc`. You were in the wrong mode.
- **Made a mess?** → `u` (undo, press it repeatedly).
- **`:` commands not working?** → make sure you typed `:` first and see it at the bottom.
- **Can't quit / "E37: No write since last change"?** → `:q!` quits without saving, or `:wq` saves and quits.
- **Beeping / nothing happens?** → you're probably already in Normal mode; that's fine, just keep going.

## Keep learning

- **`:Tutor`** — Neovim's built-in 30-minute hands-on tutorial. Do it once; it pays off.
- **`<leader>fk`** — searchable list of *every* shortcut that's actually active.
- **which-key** — press `<leader>` (Space) and wait half a second; a menu shows what's available next.
