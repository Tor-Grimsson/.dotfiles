---
title: md-preview
type: reference
status: active
updated: 2026-08-04
description: Renders a markdown file for the yazi preview pane in one of three switchable modes, keeping the frontmatter both renderers throw away and fitting the output to the pane width piper reports.
tags:
  - project/dotfiles
  - domain/scripts
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[documentation/02-file-management/02-yazi|yazi]]"
  - "[[scripts/ref-system/INDEX|ref-system]]"
---

## Summary
`md-preview` is yazi's markdown previewer. Daily lookup is `ref-yazi md-preview` — this doc is the system record.

| command | does | needs |
|---|---|---|
| *(automatic)* | renders any `.md` hovered in yazi | yazi + the piper plugin |
| `prefix v` | cycle the mode, reported in the tmux status bar | tmux |
| `md-preview <file>` | render to stdout in the current mode | mdcat, glow |
| `md-preview --mode` | print the current mode | — |
| `md-preview --cycle` | switch, print the new one | — |
| `O` → *md-preview (as previewed)* | full screen in the **same** mode, paged | less |

## Setup
1. yazi's piper plugin installed (`package.toml`, rev `b9598e6`).
2. `yazi/yazi.toml` § previewers carries `{ url = "*.{md,markdown}", run = 'piper -- md-preview "$1"' }`.
3. `prefix r` to reload tmux — the `prefix v` bind is inert until then.

## Modes

| mode | renders | frontmatter |
|---|---|---|
| `full` | hand-built properties block, then the body through mdcat | **visible** (default) |
| `mdcat` | plain mdcat | hidden |
| `glow` | plain glow with the ref-card style file | hidden |

Mode persists in `~/.cache/md-preview.mode` and is read **per render**, which is what lets `prefix v` take effect inside a *running* yazi. Move the cursor off the file and back to redraw.

## Why the frontmatter block is hand-built
Both mdcat and glow parse a leading `---` block as metadata and discard it before rendering, and neither has a flag to keep it. In a vault where frontmatter carries status, tags and related, that is the half you most want at a glance. So `full` mode prints the fields itself and hands only the body to mdcat. The strip is **positional** — the identical block one blank line down renders as a thematic break plus a setext heading.

## Width
Not a setting. piper exports `w` (the preview pane's width in columns), `h` and `t` into the script's environment; `md-preview` passes `w` on as mdcat `--columns` and glow `-w`. Both renderers take a **total** width and inset within it, landing content at `w-4` — measured w=40→36, w=60→56, w=100→96.

Without that flag mdcat renders at a fixed 76 columns and glow at its own default, and anything wider is **clipped**: yazi has no horizontal preview scroll, and piper never calls `:wrap()` on its widget. `notes-shell` explains the `$w` syntax itself.

## As an opener
`yazi.toml` § `[opener] markdown` carries `md-preview %s1 | less -R`, so `O` on a markdown file offers **md-preview (as previewed)** — the same script, reading the same `~/.cache/md-preview.mode`, so the full-screen view always matches the pane you were just looking at. Outside piper there is no `w`, so it falls back to the real terminal width. `less` scrolls sideways with the arrow keys, which is the only way a wide table gets read at all.

## Gotchas

| gotcha | fact |
|---|---|
| wide tables still overflow **the pane** | neither renderer shrinks a markdown table to the requested width — `docs/INDEX.md` at w=80 measures 236 · 236 · 224 across the three modes. Open it with `O` instead: the pager scrolls sideways |
| colour needs forcing | neither renderer colours a non-TTY and yazi always captures the pane — mdcat needs `--ansi`, glow needs `CLICOLOR_FORCE=1` plus the repo style file |
| `fold` and `read` | `fold` does not terminate its last line and a `read` loop silently drops an unterminated one. `printf '%s'` cost every single-line frontmatter field on 2026-08-04; it must be `printf '%s\n'` |
| vertical scroll exists | `J` / `K` are `seek 5` / `seek -5`; piper honours `job.skip`, so the preview does scroll up and down |
| running it by hand | with no `w` in the environment it falls back to the real terminal width, then 80 — so a plain-shell run is not the pane's behaviour |
