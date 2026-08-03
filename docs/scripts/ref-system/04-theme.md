---
title: ref — the theme JSON
type: reference
status: active
updated: 2026-08-02
description: The wired-in glow style (ref/glow-style.json, glamour's dark theme + a colored strong for category markers) translated into readable tables — every color and glyph the render uses, and the opt-in/out flow for customizing.
tags:
  - project/dotfiles
  - domain/shell
  - pattern/config
related:
  - "[[03-glow|03 — glow]]"
  - "[[02-cards|02 — cards]]"
---

## Summary
`~/.dotfiles/ref/glow-style.json` is a vendored copy of glamour's dark style — the exact values behind `glow -s dark`, plus a colored `strong`. **Wired in 2026-08-02**: `bin/ref`'s `show()` renders every card through this file, not the builtin `dark` by name — so an edit here shows up on the next `ref <card>`, no flag flip needed.

## Opt in / out

| step | how |
|---|---|
| currently ON (custom theme) | `bin/ref` `show()` already points at `-s "$dot/ref/glow-style.json"` |
| opt OUT | flip the flag back to `-s dark` — the JSON stays as documentation |
| after any JSON edit | re-port changed values into the tables below ([[02-cards\|02 — port flow]]) |

## The values (ported 2026-07-29)

Colors are 256-palette numbers unless hex. Empty = inherits/none.

| element | value |
|---|---|
| document | fg `252` · margin 2 (the left inset) |
| heading (all) | fg `39` blue · bold |
| h1 | fg `228` on bg `63` — the title pill |
| h2–h5 | literal `##`…`#####` prefix, heading color |
| h6 | fg `35`, not bold |
| inline code | fg `203` on bg `236` — the red-on-grey pill (`<leader>` etc.) |
| code block | fg `244`, margin 2, own chroma palette (hex values in the JSON) |
| **bullet glyph** | `item.block_prefix: "• "` — make it `"+ "` here to get `+` bullets |
| numbered lists | `. ` suffix style |
| task list | `[✓] ` / `[ ] ` |
| blockquote | 1-level indent, `│ ` bar |
| hr | fg `240`, renders `--------` |
| link / link text | `30` underlined / `35` bold |
| strikethrough · emph | crossed · italic |
| strong | bold, fg `214` — colors `**## group**` category markers in cards |
| **table** | `{}` — EMPTY: separators/rules are compiled glamour defaults, not stylable — per-row rules stay impossible even here |

## Paths

| what | path |
|---|---|
| the JSON | `~/.dotfiles/ref/glow-style.json` |
| consumed by | `show()` in `~/.dotfiles/bin/ref` (default renderer since 2026-08-02) |
| glow's global config (separate concern) | `~/.dotfiles/glow/glow.yml` — style/width/pager defaults for bare `glow` |
