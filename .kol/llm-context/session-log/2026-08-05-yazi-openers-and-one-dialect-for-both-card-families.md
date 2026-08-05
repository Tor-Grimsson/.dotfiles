# Session: yazi openers gain markdown reach, and one dialect governs both card families

**Date:** 2026-08-05
**Agent:** Claude Code (Grim) — MBP
**Summary:** Markdown was the only file type in yazi that could not reach the default app, and could not be read full-screen in the rendering the preview shows. Both fixed as opener entries, with a tmux bind to restart yazi so config edits land. Then the notes family was folded back under the ref dialect on the user's ruling.

## Changes Made

### Files Modified
- `yazi/yazi.toml:84` — the `.md` open rule gained `open`; it was the only file-opening rule without it
- `yazi/yazi.toml` § `[opener] markdown` — new first entry, `md-preview %s1 | less -R`, desc *md-preview (as previewed)*
- `tmux/.tmux.conf:60` — **new bind** `prefix y` — restart yazi in place with config re-read. **Shipped broken and fixed the same session**, see below
- `yazi/init.lua` — **new status child**: `md:<mode>` on the right, only while a markdown file is hovered
- `bin/ref` — `card_lint()` now lints `notes/*.md` alongside `ref/*.md`
- `notes/shell.md` — two cells trimmed to the 46-char budget
- `bin/notes` — header corrected; it claimed exemption from the ref dialect
- `claude/skills/ref-admin/SKILL.md` — declared the arbiter for **both** families; description, files table, cells rule, and both `To add` steps updated
- `ref/yazi.md` — `## full screen` group added to the md-preview section; **new `## yazi — reload after a config edit` section**
- `ref/tmux.md` — **new `## reload` section**: `pfx r` moved out of `## copy` where it never belonged, joined by `pfx y` and `pfx v`
- `docs/scripts/md-preview.md` — `As an opener` section; the table gotcha now points at the pager
- `docs/scripts/notes-system.md` — the "no lint" gotcha and the split-contract row were false, rewritten

### Features Added/Removed
- Added: `O` on a markdown file offers **Open** (default app) and **md-preview (as previewed)**
- Added: `prefix y` — restart yazi in place, same dir, fresh config
- Added: `ref --lint` covers the notes family — 21 cards clean

## Current State

### Working
- The md `O` menu resolves to 8 entries: `$EDITOR · md-preview (as previewed) · glow (pager) · mdcat (pager) · nano · Open · Reveal · Show EXIF`
- The opener command ran for real — frontmatter block renders, 73 ANSI sequences survive the pipe, width falls back to `tput cols` outside piper
- `.tmux.conf` parsed in a throwaway server; `bind y` and `bind r` both resolve; server killed, no stray
- `ref --lint` clean at **21** (20 ref + 1 notes)

### Known Issues
- Wide markdown **tables** still overflow the preview pane. The opener is now the answer rather than a fix: `less` scrolls sideways with the arrow keys, which the pane cannot do
- `tmux/layout-picker.sh:3` still says `prefix C-d`; the live bind is `prefix C-o`

### Two rulings from the user, both reversing me
1. **The `.md` opener rule.** I answered three times from mtimes — *yazi.toml is unchanged since 03/08, therefore not my doing* — instead of reading the rules. Reading them: `*/`, `image/svg+xml`, `image/*` and the `*` fallback all carry `open`; the `.md` rule alone did not. Attribution was a distraction from a real defect sitting in the file the whole time.
2. **One dialect, not two.** `notes` was built exempt from the ref dialect on the grounds that a 46-char cell is right for keybinds and wrong for prose. User: *"its the same arbiter of truth in terms of layout and structure."* Correct — prose belongs in the paragraphs around the table, exactly as `ref/yazi.md` already does it. `ref --lint` was pointed at `notes/` and immediately caught two over-length cells. The exemption is now recorded in the skill as the wrong call, with the reason: two ways to express the same thing always drift.

### A third correction: the bind was shipped uncarded
`prefix y` went into `.tmux.conf` and onto neither card — the one discipline `/ref-admin` states outright ("when a config changes, the card changes in the **same edit**"), broken in the same session the skill was loaded. `ref-yazi reload` returned nothing, and so would `ref-tmux reload`: `pfx r` was stranded at the bottom of `## copy` with no "reload" in any section title. User's rule, recorded: **things live where they are referenced, even if they have two homes** — yazi is what gets reloaded, tmux is what reloads it, so both cards carry the key. The *reasoning* stays in one place; `ref-tmux` points at `ref-yazi` rather than duplicating it.

### `prefix y` shipped broken — "it parses" is not "it works"
The first version was `bind y send-keys q "y ." Enter`, and I reported it verified because the config **parsed** and tmux stored the binding. The user: *"you think prefix y works? it just exist, doesnt reopen."*

**The bug:** `send-keys` with three arguments delivers them as one uninterrupted burst. yazi is still holding the tty when `y .` arrives, so the relaunch never reaches a shell — reproduced in a throwaway pane, which showed the literal string `qy .` sitting at the prompt.

**The fix** separates the two sends without blocking the tmux server:

```tmux
bind y send-keys q \; run-shell -b 'sleep 0.4; tmux send-keys -t "#{pane_id}" "y ." Enter'
```

`run-shell` is synchronous by default and would freeze the server for the sleep; `-b` backgrounds it. The 0.4s is the gap yazi needs to release the tty and the zshrc `y` wrapper to start reading.

**The lesson is the one this repo keeps relearning**: parsing, storing and rendering are not running. Two entries ago it was *reading or piping is not the live behaviour*; this is the same failure wearing a tmux costume.

### The preview mode is now in yazi's own status line
`yazi/init.lua` gained a `Status:children_add` child showing `md:full` / `md:mdcat` / `md:glow` on the right, and **only while a markdown file is hovered** — on every other file type it would be permanent clutter. It reads the same `~/.cache/md-preview.mode` the renderer reads, with the same unknown-value-means-`full` fallback, so the badge cannot disagree with what is on screen.

Every identifier was lifted from yazi's own embedded Lua rather than memory — `Status:children_add(fn, order, side)`, `self._current.hovered`, the bare `return ""` for nothing, `self:style()` → `style.alt`. One useful detail found while checking: `children_add` tests `side == self.RIGHT`, so passing `Status.RIGHT` lands on the right whether or not that constant is actually defined.

Confirmed rendering by the user. Lua syntax was machine-checked, but the draw itself needed a real TTY and a hovered file, so it could not be verified from here.

### Why the lint reason lives in the code
`bin/ref`'s `card_lint()` carries the ruling inline, not only in the skill — the next person to add a card family hits it before writing the file, not after.

## Next Steps
1. Fix `tmux/layout-picker.sh:3` — the comment names the wrong bind.
2. `notes/` has one card. It is the right shape for anything explained once and then forgotten.
3. Untouched and still open: the plugin-namespace question (`/humpty:<name>` vs bare).
