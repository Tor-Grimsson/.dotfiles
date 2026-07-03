---
title: Neovim workflows — reshaping & handling text
type: guide
status: active
updated: 2026-07-03
audience: internal
description: The sequences and the process for reshaping badly-formatted text in Neovim — the edit grammar (verb + target), visual-block column edits, find/replace/filter, the messy-paste→clean-block cleanup workflow (indent, wrap, blanks), wrap/reflow with gq vs par vs fmt (orphans), piping the buffer through shell tools (:%!), regex that doesn't fight you, :g + :normal combos, and worked examples.
aliases:
  - nvim-workflows
  - neovim-workflows
  - text-handling
tags:
  - domain/shell
  - domain/neovim
  - pattern/tui
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[10-neovim-config|Neovim config (IDE setup)]]"
  - "[[11-neovim-cheatsheet|Neovim beginner]]"
---

# Neovim workflows — reshaping & handling text

The cheatsheet ([CLI cheatsheet](01-cli-cheatsheet.md)) lists the **keys**. This lists the **sequences** — the real tasks where you need three or four keys in the right order — plus the **process** for the most common job: you paste a chunk of text and it's not shaped the way you want (indented, too wide, stray blank lines, ugly wrapping) and you want to fix it fast.

Each recipe is *keys, in order* → what happens. Type them literally; spaces in the key column are just for reading. Leader = `Space`; start each from **Normal mode** (`Esc` if unsure). `⏎` = Enter.

---

## Editing blocks of text

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
| Reflow/format a paragraph | `g q i p` | rewraps to `textwidth` (see *Reshaping* below) |
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

## Reshaping messy text — the cleanup workflow

The most common job: you paste a chunk (chat log, notes, a wrapped email) and want it tidy — no indent, wrapped to a sane width, blank lines under control, no ugly orphans.

### The golden rule — blank lines are structure

The wrap command (`gq`) treats **every blank line as a fence** marking where one paragraph ends and the next begins. So:

- **Keep** the blank lines while you adjust width and shape.
- **Delete** them dead last — and only if you want them gone at all.
- Delete them too early and `gq` fuses the whole file into one run-on paragraph.

Wreck it? `u` (undo) walks every step back, so experiment freely.

### The core sequence (run top to bottom)

```vim
:set textwidth=90      " your max line length
:%left                 " remove all indentation (left-align to column 0)
gggqG                  " wrap the whole file to 90
:%s/\v\s+$//           " strip trailing whitespace
:%s/\v\n{3,}/\r\r/     " collapse any pile-up of blank lines down to a single one
:g/^\s*$/d             " OPTIONAL, LAST — delete every blank line entirely
```

Order matters only around wrapping: **wrap while the blank lines still exist**, delete them afterward.

`:` commands need `⏎`. `gggqG` has **no colon and no Enter** — it's raw Normal-mode keys that fire the instant you finish typing them.

### Anatomy of the wrap keystrokes

`gggqG` is just a *scope* wrapped around the `gq` command. Change the letters after `gq` to wrap more or less:

| Keystrokes | Wraps… | Read as |
|---|---|---|
| `gggqG` | the whole file | `gg` (top) → `gq` (wrap) → `G` (bottom) |
| `gqG` | cursor line down to end of file | `gq` (wrap) → `G` (bottom) |
| `gqap` | just the paragraph the cursor is in | `gq` (wrap) → `ap` (a paragraph) |
| `gqq` | just the current line | `gq` (wrap) → `q` (this line) |

`gq` always wraps to the **current** `textwidth`. To reflow at a new width: `:set textwidth=72`, then `gqap` (one paragraph) or `gggqG` (all).

### Spacing control

| Goal | Command |
|---|---|
| Collapse piles of blank lines to a single one | `:%s/\v\n{3,}/\r\r/` |
| Double-space — add a blank line after every line | `:g/./normal o` |
| Remove all blank lines | `:g/^\s*$/d` |

`\v\n{3,}` = "three or more newlines in a row" (two or more blank lines); `\r` is how you write a newline on the *replacement* side of a `:s`.

### Reflow tools — `gq` vs `par` vs `fmt` (orphans)

`gq` is **greedy**: it crams each line full and drops whatever's left onto the last line, even if that's one stranded word (an "orphan"). Vim has no setting to prevent this. For balanced line lengths, pipe the buffer through **`par`** — a real paragraph reformatter that distributes words evenly:

```vim
:%!par 90              " balanced wrap at 90 — no lonely last-line word
:'<,'>!par 72          " balance just the selected lines at 72
```

For example, `gq` wrapped at ~30 can leave a lonely last line:

```
Building the exact flag for
the converter is
straightforward enough
honestly                     ← orphan
```

`par` at the same width redistributes the words so the last line carries its weight and nothing is stranded.

| Tool | Where | Wrapping | Orphans | Note |
|---|---|---|---|---|
| `gq` | built into nvim | greedy | leaves them | zero-dep, wraps to `textwidth` |
| `:%!par N` | `brew install par` | **balanced** | avoids them | best for prose you actually read |
| `:%!fmt -w N` | `/usr/bin/fmt` (system) | greedy | leaves them | no install, but no better than `gq` |

See `man par` for justify/prefix options.

### Filter through a shell tool (`:%!`)

The big one for "just parse this for me": nvim can pipe a range **out** to any command-line program and replace it with that program's output. `:%!cmd` = whole buffer, `:'<,'>!cmd` = the visual selection, `!ip cmd` = the paragraph under the cursor.

| Job | Command |
|---|---|
| Sort / sort + dedupe | `:%!sort` · `:%!sort -u` (native: `:sort` / `:sort u`) |
| Pretty-print JSON | `:%!jq .` (`:%!jq -S .` sorts keys) |
| Line up ragged columns | `:%!column -t` (`-s','` to split on commas) |
| Keep one field per line | `:%!awk '{print $2}'` |
| Anything too gnarly for regex | `:%!python3 -c "…read stdin, print result…"` |

> **Undo covers you.** If a filter empties or mangles the buffer (usually a wrong command name — `command not found` prints nothing), press `u` and it's back. Test the command in a real shell first if unsure.

### Regex that doesn't fight you

Vim's default regex dialect needs backslashes in front of `+ ? ( ) { }`. Prefix any pattern with **`\v`** ("very magic") and they behave like every other regex engine:

```vim
:%s/\v(foo|bar)/baz/g      " very magic — clean
:%s/\(foo\|bar\)/baz/g     " same thing, default dialect — noisy
```

Handy pieces: `\v +` (runs of spaces), `\s+$` (trailing whitespace), `^` / `$` (line start/end), `(…)` capture → `\1` `\2` reuse, `\=expr` evaluates a Vimscript expression as the replacement.

### `:g` + `:normal` — run an edit on matching lines

`:g/pat/normal <keys>` finds every line matching `pat` and plays the Normal-mode `<keys>` on it — a targeted macro without recording one.

```vim
:g/)$/normal A;            " append ; to every line ending in )
:g/^import /m$             " move every import line to the bottom
:v/ERROR/d                 " delete every line that is NOT an error (log filter)
```

---

## Worked examples

| # | Task | Do this |
|---|---|---|
| 1 | Clean a messy paste (indent + width + blanks) | the **core sequence** above |
| 2 | Reflow one paragraph to 72 | `:set tw=72` → cursor in it → `gqap` |
| 3 | Balanced wrap, no orphans | `:%!par 80` |
| 4 | Collapse double-spacing to single blanks | `:%s/\v\n{3,}/\r\r/` |
| 5 | Sort a list + drop duplicates | `:sort u` (or `:%!sort -u`) |
| 6 | Pretty-print a blob of JSON | `:%!jq .` |
| 7 | Align ragged columns into a table | `:%!column -t` |
| 8 | Number every line `1. `, `2. `… | `:%s/\v^/\=line('.').'. '/` |
| 9 | Keep only the lines that mention ERROR | `:v/ERROR/d` |
| 10 | Comment out a block | `Ctrl-v` select `I` `# ` `Esc` |

Two fuller ones:

**Wrapped email → clean 80-col prose, balanced.** Paste it, then:

```vim
:%left                 " kill the quote indentation
:set tw=80
:%!par 80              " balanced reflow (or gggqG for greedy)
:%s/\v\n{3,}/\r\r/     " one blank line between paragraphs
```

**CSV-ish paste → aligned, second column only.** Selection first (`V` … `'<,'>`), or whole file:

```vim
:%!column -t -s','     " align on commas into padded columns
" or, to keep just one field:
:%!awk -F',' '{print $2}'
```

---

## See also
- [CLI cheatsheet](01-cli-cheatsheet.md) — the flat keymaps these recipes draw on (Neovim section).
- [Neovim config](../04-dev-languages/10-neovim-config.md) · [Neovim beginner](../04-dev-languages/11-neovim-cheatsheet.md) — full per-tool docs.
