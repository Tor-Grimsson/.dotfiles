---
title: ref — the terminal end
type: reference
status: active
updated: 2026-07-29
description: Why a ref print stays in the scrollback — pager vs alternate screen, the cat-pipe that defeats glow's pager, CLICOLOR_FORCE for color through a pipe, and the width knobs.
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[01-system|01 — system]]"
  - "[[03-glow|03 — glow]]"
---

## Summary
A ref card must print like cat: land in the scrollback, prompt back, nothing to quit. Two terminal mechanics fight that — the glow call in `show()` neutralizes both.

## The two mechanics

| mechanic | what happens | the counter |
|---|---|---|
| **pager → alternate screen** | glow.yml sets `pager: true` (wanted for `glow file.md` reading); glow 2.1.2 pages even with `--pager=false`. A pager draws on the terminal's *alternate screen* — quitting it ERASES everything drawn | pipe glow through `cat` — a pager can only engage on a real TTY, and a pipe isn't one |
| **color stripping on pipe** | glow drops all ANSI color the moment stdout isn't a TTY — the cat-pipe alone prints monochrome | `CLICOLOR_FORCE=1` on the glow call — "color anyway" |

The resulting call in `bin/ref` `show()`:
```sh
CLICOLOR_FORCE=1 glow -s dark -w "$(tput cols 2>/dev/null || echo 100)" | cat
```

## Width

| knob | scope |
|---|---|
| `-w $(tput cols)` on the ref call | wrap width per print — the live terminal width; **fallback 100** if cols can't be read (a print stuck wrapping at ~100 in a wider window = the fallback firing) |
| `glow.yml width: 100` | bare `glow` runs only — the ref `-w` flag outranks it |
| tables | sized to content regardless — `-w` caps only where paragraphs and long cells wrap |

## Verifying (the probes used to pin this down)
```sh
# does a command draw on the alternate screen? (1049h = yes)
script -q /dev/null ref-nvim drill < /dev/null | grep -c '1049h'
# does color survive the pipe? (escape bytes = yes)
ref-nvim drill | od -c | head -3
```
