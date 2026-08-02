---
title: ref — the glow end
type: reference
status: active
updated: 2026-07-29
description: What glow can draw in a ref card — the full element vocabulary (headings, tables, lists, quotes, rules, code) and the terminal's hard limits (no text size, no per-row table rules, theme-owned bullet glyphs).
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[01-system|01 — system]]"
  - "[[04-theme|04 — theme]]"
  - "[[documentation/01-shell-terminal/08-glow|glow (tool catalog)]]"
---

## Summary
glow *renders* markdown (bat only highlights its source). The nvim card goes through glow; this is the vocabulary available when authoring it. Install/general usage: [[documentation/01-shell-terminal/08-glow|glow in the tool catalog]].

## Hard limits first
A terminal is a grid of same-sized cells: **no text size** — hierarchy is color, bold, background, never font size. glow's table engine draws a header rule + column rules only — **no per-row lines** — and that is fine; a blank spacer row per data row was tried and RULED OUT 2026-07-31, and is now failed by `ref --lint` rather than merely discouraged ([[02-cards|02]]). Grouping inside one table is done with a `| ## name |` marker row after a single blank row — glow renders the `##` literally, which is exactly the wanted separator.

## The vocabulary

| element | renders? | notes |
|---|---|---|
| H1–H6 | yes | distinct styling per level — H1 gets the background pill, H2 the colored `##` prefix, deeper = plainer |
| tables | yes | real box-drawing; sized to content, `-w` only caps wrapping |
| bullets | yes, nested + indented | rendered glyph is the THEME's (`•`) — a `+` in source still renders `•`; changing it = [[04-theme\|04]] |
| numbered lists | yes | auto-renumbered |
| task lists `- [ ]` `- [x]` | yes | checkboxes |
| bold / italic / strikethrough | yes | inline |
| inline code | yes | the highlighted pill — how `` `<leader>` `` renders |
| code blocks | yes | syntax-highlighted |
| blockquote | yes | indented `│` bar — the asides |
| horizontal rule `---` | yes | full-width divider without a heading |
| links / images | text only | links show as text; images don't render |

## How the nvim card is rendered
`bin/ref` pipes the (filtered) card into `glow -s dark -w <terminal-cols>` — see [[05-terminal|05]] for why the call is wrapped in `CLICOLOR_FORCE=1 … | cat`.
