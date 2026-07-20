---
title: btop — themeable resource monitor
type: reference
status: active
updated: 2026-07-14
audience: internal
description: btop as the desk's boxed system monitor (cpu/mem/net/proc panels) — installed alongside htop, themed by kol-theme via a generated theme pointer. The monitor from the linkarzu reference desk.
aliases:
  - btop
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[INDEX|Shell & terminal]]"
  - "[[../09-productivity-desktop/08-kol-theme|kol-theme]]"
---

# btop

## Purpose

The desk's *display* monitor — the boxed cpu/mem/net/proc panels from the linkarzu reference desk, mouse-driven and **themeable** (which is why it exists next to [[../01-shell-terminal/INDEX|htop]]: htop stays the quick find-and-kill tool, btop is the one that joins the theme system).

## Dependencies

| piece | does | needs |
|---|---|---|
| `brew "btop"` | the monitor | `brewfile-cli` line exists — user runs install (already on the iMac) |
| `themes/<name>/btop.theme` | per-theme colors | ships with every kol-theme theme |
| `~/.config/btop/themes/kol-current.theme` | constant symlink into the active theme | created by `bin/kol-theme` |

## Setup

1. `brew install btop` (or `brew bundle` — the line is in `brewfile-cli`).
2. `kol-theme <name>` — points btop's `color_theme` at `kol-current` and links the theme.
3. Launch `btop`. Theme changes apply on next launch (btop reads themes at start).

## Commands

```sh
btop                 # the monitor
# in-app: Esc → Options for size/layout; m cycles preset layouts; q quits
```

## Gotchas

- **btop rewrites `~/.config/btop/btop.conf` on exit** — that's why the conf is NOT repo-tracked; `kol-theme` re-asserts the `color_theme` line on every switch, so btop's own writes never orphan the theme.
- The `linkarzu` theme sets `main_bg=""` (transparent) — pairs with that theme's frosted ghostty; the other themes use solid backgrounds.
