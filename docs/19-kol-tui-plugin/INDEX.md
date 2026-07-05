---
title: kol-tui-plugin — bookmark sidebar exploration
type: index
status: active
updated: 2026-07-04
description: Design exploration for an always-visible (or toggle-visible) sidebar pane showing bookmarked files, URLs, and git worktrees as clickable links. Not built — this is the option survey before picking an approach.
tags:
  - project/dotfiles
  - domain/shell
related:
  - "[[INDEX|tooling catalog]]"
  - "[[01-shell-terminal/02-tmux|tmux]]"
  - "[[01-shell-terminal/22-tmux-harpoon|tmux-harpoon]]"
  - "[[01-shell-terminal/24-workmux|workmux]]"
  - "[[02-file-management/02-yazi|yazi]]"
  - "[[09-productivity-desktop/05-aerospace|AeroSpace]]"
---

# kol-tui-plugin — bookmark sidebar exploration

**Status: exploration only, nothing built.** Logged so the option survey isn't lost, not because this is scheduled work.

## Problem
Want a pane — always visible, or toggled on demand — listing bookmarked **files, URLs, and git worktrees** as clickable links: click a file, it opens; click a worktree, it jumps there; click a URL, it opens in the browser. Not a file browser (already have [yazi](../02-file-management/02-yazi.md) for that, and it's better at it than the tmux sidebar plugins that were considered and passed on for being "just an explorer").

**Inspiration, visual only:** [supacode.sh](https://supacode.sh) and [herdr.dev](https://herdr.dev) both ship a sidebar wrapping a terminal multiplexer. Neither's actual feature set is what's wanted here — supacode is a full terminal-emulator replacement, herdr's sidebar shows AI-agent status, not bookmarks. The only thing borrowed from them is "a sidebar pane next to your work is a proven, comfortable layout" — not their implementation.

## Architecture question #1 — which layer does the sidebar live in?
Two genuinely different options, not interchangeable:

| Layer | Scope | Persists across |
|---|---|---|
| **AeroSpace floating window** | A dedicated iTerm2 window, positioned/floated by AeroSpace (`on-window-detected` + `after-startup-command`) | Switching tmux sessions, tmux windows, even non-terminal apps — genuinely "always visible" |
| **tmux pane** (fixed split within a window) | One pane inside *one* tmux window's layout | Only that window — switching tmux windows loses it unless the layout is duplicated everywhere |

The original ask was "always visible like windows are visible in a session" — that points at the **AeroSpace layer**, since a tmux pane is scoped to a single window, not global across the whole terminal. Worth deciding this explicitly first; it changes everything downstream.

## Architecture question #2 — what renders the content?

### A. Plain script + terminal hyperlinks (most control, build from scratch)
- **OSC-8** is a real, standard escape sequence, not something invented for this: `printf '\e]8;;URL\e\\visible text\e]8;;\e\\'` — natively supported by iTerm2 (Cmd+click to open).
- Not limited to web URLs — iTerm2 also has **command URLs** (`iterm2:/command?c=...`): a clickable link that *runs a shell command*. This is the piece that makes "click to open a file in nvim" or "click to jump into a worktree" actually work, not just http links.
- iTerm2 also already ships **Named Marks** (Edit → Named Marks, or the Toolbelt) — a built-in bookmark-a-point-and-jump-back feature. Zero code. Might cover part of this need without building anything at all — worth testing before building.
- Content sources: [tmux-harpoon](../01-shell-terminal/22-tmux-harpoon.md)'s bookmark file (sessions), a new plain-text file maintained for files/URLs, and `workmux list` (worktrees) — one script formats all three as links.

### B. A yazi bookmark plugin (didn't know these existed going in — genuinely worth reconsidering)
Yazi already has a mature bookmark-plugin ecosystem: **yamb.yazi**, **whoosh.yazi**, **bookmarks.yazi**, **bunny.yazi** — all persistent, fuzzy-searchable, jump-by-key, already built and maintained by other people. Since [yazi](../02-file-management/02-yazi.md) is already installed and already rated above the tmux file-tree sidebars for browsing, running one of these plugins inside a fixed yazi pane reuses a solved problem instead of rebuilding it.
- Doesn't natively cover **URLs** or **git worktrees** — yazi bookmarks are files/directories. Would still need pairing with something else for those two.
- Fixed-pane placement is a tmux/AeroSpace question (see question #1), not a yazi one — yazi itself doesn't "dock" anywhere on its own.

### C. Custom tmux plugin (the literal "container tmux lives inside" framing)
Same pattern as `tmux-sidebar`/`treemux` (both passed on) but purpose-built for bookmarks+worktrees+URLs instead of a file tree — a `bind` + `run-shell` pair, the same mechanism already used for [tmux-harpoon](../01-shell-terminal/22-tmux-harpoon.md), rendering into a small fixed-size pane. Most control, also the most to build and maintain long-term.

## Cheapest way to actually test the concept
1. Hand-`printf` a fake OSC-8 link in a spare pane — confirm Cmd+click actually opens it on this iTerm2 version. Five minutes, zero build, and rules out a whole class of "does the terminal even support this" risk before writing anything.
2. If that works: settle the layer question (AeroSpace window vs. tmux pane) before writing more — it's the one decision that changes the whole design.
3. Try `yamb.yazi` (looks the most fully-featured: persistence + key-jump + fzf search) standalone first, independent of the sidebar question — see whether it already solves the "files" third of the bookmark list on its own.

## Open questions
- Does "always visible" need to survive switching away from the terminal app entirely (→ AeroSpace layer), or is "visible whenever I'm in this one tmux window" actually enough day to day?
- Does the bookmark list need to be one unified view, or is sessions (harpoon) / worktrees (workmux) / files+URLs (new) staying as three separate things fine?
- Static (re-run the script by hand) or live-refreshing (`watch`-style auto-update)?

## Verdict
Visually inspiring, not a game-changer by your own read — logged as an explored option, not scheduled work. Revisit if/when it comes up again.
