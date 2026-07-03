---
title: mdcat
type: reference
status: active
updated: 2026-06-25
description: Terminal markdown renderer with clean headings (no `##` markers) and inline images in iTerm2 — the yazi `.md` previewer.
aliases:
  - mdcat
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/BIRSAx2/mdcat
  repo: https://github.com/BIRSAx2/mdcat
  manual: https://github.com/BIRSAx2/mdcat#readme
  brew: https://formulae.brew.sh/formula/mdcat
covers:
  - render + pager, inline iTerm2 images
  - the flags that matter for piping / previewers (--ansi, --local, --columns)
  - its role as the yazi .md previewer + the `M` full-screen key
related:
  - "[[08-glow|glow]]"
  - "[[../02-file-management/02-yazi|yazi]]"
---

## Summary
A terminal **markdown renderer** (single Rust binary) that styles headings **without leaving the `##` markers**, renders tables/lists/quotes/code, and — unlike most — shows **inline images** in iTerm2 (and kitty) via the terminal image protocol. Chosen over [glow](08-glow.md) as the yazi preview renderer after an A/B: glow keeps the `##` and strips frontmatter; mdcat drops the markers and shows frontmatter as a rule + text.

It pairs with, doesn't replace, glow — glow stays for scripts + the "Open in glow" Quick Action; mdcat is the in-terminal reader and yazi previewer.

## Why installed
The markdown renderer for [yazi](../02-file-management/02-yazi.md)'s `.md` preview pane, and a nicer full-screen reader than glow for docs with headings or images. The dotfiles are markdown-heavy; mdcat is the cleanest in-terminal view of them.

## Most common use case
You rarely call it directly — it renders automatically in the yazi preview pane, and on the `M` key for a full-screen read. Standalone: `mdcat -p file.md`.

## Biggest win
**Clean headings + inline images.** No `##` clutter, and in iTerm2 a doc's embedded images actually appear instead of rendering as nothing — the one thing terminal markdown readers usually can't do.

## How to use
```sh
mdcat file.md             # render to the terminal
mdcat -p file.md          # pager mode (less), q to quit — best for long docs
mdcat --ansi file.md      # force formatting even when stdout is a pipe (no TTY)
mdcat --local file.md     # don't fetch remote images (fast, no network stalls)
mdcat --columns 80 f.md   # set wrap width
mdcat -c file.md          # --no-colour: plain text
```

| Flag | Does |
|---|---|
| `-p`, `--paginate` | page through `less` (`-P`/`--no-pager` to force off) |
| `--ansi` | skip terminal detection, emit ANSI — **needed when piped** (e.g. a previewer) |
| `-l`, `--local` | skip remote resource (image) fetches |
| `--columns N` | max output width |
| `-c`, `--no-colour` | disable colours/styles |

## Config
**No config file** — mdcat is flags-only (no `~/.config` entry). Behaviour is set per-invocation, so the defaults live wherever it's called from.

## yazi integration
- **Previewer:** `yazi/plugins/mdcat.yazi/main.lua` (hand-written, not a `ya pkg` dep) runs `mdcat --ansi --local --columns <pane-width>` with a 2-col margin via `job.area:pad(ui.Pad.x(2))`. Wired in `yazi.toml` for `*.{md,markdown}` (by extension — yazi tags `.md` as `text/plain`, so mime won't match).
- **Full-screen:** the `M` key in `keymap.toml` → `shell 'mdcat -p "$@"' --block` (pager + inline images), `q` returns to yazi.
- See [yazi](../02-file-management/02-yazi.md) for the full preview-backend picture.

## Future use
A `md() { mdcat -p "$@"; }` shell alias for a quick reader; swap the yazi `pad` local if the margin wants tuning. If a doc-with-images workflow grows, mdcat's inline-image rendering is the reason to reach for it over glow.
