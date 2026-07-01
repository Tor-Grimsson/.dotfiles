---
title: CLI workflows
type: guide
status: active
updated: 2026-06-26
audience: internal
description: Worked, copy-the-keystrokes recipes for the moves that are awkward to look up key-by-key — editing blocks of text across Neovim modes, and navigating / moving / opening files in yazi.
aliases:
  - cli-workflows
  - workflows
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[10-neovim-config|Neovim config (IDE setup)]]"
  - "[[02-yazi|Yazi]]"
---

# CLI workflows

The cheatsheet ([[01-cli-cheatsheet|CLI cheatsheet]]) lists the keys. This lists the **sequences** — the real tasks where you need three or four keys in the right order. Each recipe is *keys, in order* → what happens. Type them literally; spaces in the key column are just for reading.

---

## Neovim — editing blocks of text

Leader = `Space`. Start each from **Normal mode** (`Esc` if unsure). `⏎` = Enter.

### Words & inline edits

| Task | Keys | Why |
|---|---|---|
| Change the word you're on | `c i w` *type* `Esc` | inner-word, no spaces eaten |
| Change a word **and** trailing space | `c a w` *type* `Esc` | "around" includes the space |
| Change the next 3 words | `c 3 w` *type* `Esc` | count + motion |
| Replace inside quotes | `c i "` *type* `Esc` | works for `'` `` ` `` too |
| Replace inside brackets | `c i (` *type* `Esc` | `ci{` `ci[` `cit` (HTML tag) |
| Delete to end of line | `D` | = `d$` |
| Change to end of line | `C` | = `c$`, drops into Insert |
| Uppercase a word | `g U i w` | `guiw` = lower, `g~iw` = toggle |

### Whole blocks (paragraph / selection)

| Task | Keys | Why |
|---|---|---|
| Delete a paragraph | `d a p` | blank-line-bounded block |
| Indent a paragraph | `> i p` | `<ip` outdents, `=ip` re-indents |
| Reflow/format a paragraph | `g q i p` | rewraps to `textwidth` |
| Select a block then act | `V } ` then `d` / `y` / `>` | `V` = line-visual, `}` extends to blank line |
| Duplicate a block | `y a p` → move → `p` | yank-around-paragraph, paste below |
| Move a block down one line | `d d p` | delete line, paste after (swaps) |
| Move a selection elsewhere | `V } d` → move → `p` | cut the block, paste at cursor |

### Column / multi-line edits (Visual-block)

The one most people never learn — `Ctrl-v` selects a **rectangle**, and `I`/`A` then type onto *every* selected line at once.

| Task | Keys | Why |
|---|---|---|
| Prefix many lines (e.g. `# `) | `Ctrl-v` `j j j` `I` `# ` `Esc` | insert at block start on all rows |
| Append to many lines (e.g. `;`) | `Ctrl-v` `j j j` `$` `A` `;` `Esc` | `$` makes the block ragged-right |
| Delete a column of text | `Ctrl-v` select `d` | kill an aligned column |
| Comment a selection | `V` select `g c` *(if commenter)* or block-`I` | block-insert is the no-plugin way |

> After `Esc` the typed text appears on all rows. If only the first row changes, you left Insert too early — redo and press `Esc` once, firmly.

### Find, replace, filter

| Task | Keys | Why |
|---|---|---|
| Replace all in file | `: % s / old / new / g ⏎` | add `c` to confirm each |
| Replace only in a selection | `V` select `: s / old / new / g ⏎` | `'<,'>` is inserted for you |
| Replace word under cursor everywhere | `*` `: % s / / new / g ⏎` | `*` loads the word into the search reg |
| Change next match, repeat | `/ foo ⏎` `c g n` *type* `Esc` then `.` `.` | poor-man's multi-cursor |
| Delete every line matching | `: g / pat / d ⏎` | keep-only = `:v/pat/d` |
| Sort selected lines | `V` select `: s o r t ⏎` | `:sort u` also dedupes |
| Pipe a block through a shell cmd | `! i p sort ⏎` | filter paragraph; `:%!jq .` for the file |

### Surround (nvim-surround)

| Task | Keys |
|---|---|
| Wrap word in quotes | `y s i w "` |
| Wrap a selection in a tag | `V` select `S < e m >` |
| Change `(` → `[` | `c s ( [` |
| Delete surrounding quotes | `d s "` |

> Stuck mid-edit? `Esc` → `u` (undo, repeatable). Redo `Ctrl-r`. `.` repeats your last change — lean on it instead of retyping.

---

## yazi — navigate, move, open

Launch with **`y`** (the shell follows you on quit). `q` quits, `~` shows help.

### Get to a path fast

| Task | Keys | Why |
|---|---|---|
| Walk in / out | `l` / `h` | enter child / go to parent |
| Jump to a known dir (frecency) | `Z` *type* `⏎` | zoxide — best for dirs you visit often |
| Fuzzy-jump to any file/dir | `z` *type* `⏎` | fzf over the tree |
| Type a path interactively | `g <Space>` *type* `⏎` | `cd --interactive` |
| Shortcut dirs | `g h` `g d` `g D` `g .` `g p` `g t` | home · Downloads · Desktop · dotfiles · projects · _temp |
| Find a name in this dir | `/` *type* `⏎` (`n` `N` to repeat) | jumps the cursor as you type |
| Filter the listing | `f` *type* | hides non-matches; `Esc` clears |
| Search the whole tree | `s` *type* (fd) · `S` *type* (rg = by content) | recursive results |

### Move & copy files

| Task | Keys | Why |
|---|---|---|
| Copy a few files to another dir | mark with `Space` … → `y` → go to target → `p` | `y` = copy, `p` = paste |
| Move (cut) instead of copy | mark … → `x` → target → `p` | `x` = cut |
| Keep source + target open | `t` (new tab) → navigate → `1`/`2` to switch | paste across tabs |
| Bulk rename | mark files → `r` | opens the names in nvim; edit list, `:wq`, all apply |
| New folder, then drop files in | `a` `name/` `⏎` → enter it → paste | trailing `/` makes it a dir |
| Trash vs delete | `d` (trash) / `D` (delete forever) | `d` is recoverable |

### Open from a path

| Task | Keys | Why |
|---|---|---|
| Open with the default app | `<Enter>` or `o` | smart-enter: dir → enter, file → open |
| **Pick which app** to open with | `O` | `open --interactive` — choose the opener |
| Quick Look (peek without opening) | `<C-y>` | macOS `qlmanage` |
| Read a markdown file full-screen | `M` | mdcat pager; `q` returns |
| Open a shell here / run on selection | `;` *cmd* `⏎` (or `:` to block) | e.g. `;` `open .` opens Finder here |
| Open selection in a specific app | `;` `open -a "Affinity Photo 2" "$@"` `⏎` | `$@` = the marked files |
| Reveal current dir in Finder | `;` `open .` `⏎` | escape hatch to the GUI |

### Two everyday loops

```text
Browse → cd:   y  →  walk the tree (h/l, Z, /)  →  q   # shell is now in that dir
Find → act:    s <name> ⏎  →  land on it  →  o (open) / x (cut) / r (rename)
```

---

## See also
- [[01-cli-cheatsheet|CLI cheatsheet]] — the flat keymaps these recipes draw on.
- [[10-neovim-config|Neovim config]] · [[11-neovim-cheatsheet|Neovim beginner]] · [[02-yazi|Yazi]] — full per-tool docs.
