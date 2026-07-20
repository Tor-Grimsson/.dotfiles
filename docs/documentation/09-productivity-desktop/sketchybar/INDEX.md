---
title: SketchyBar — complete guide
type: index
status: active
updated: 2026-07-10
description: Read-me-start-to-finish guide to the SketchyBar setup — the config model (bar → items → plugins → events), every widget explained, how to add your own, the styling toolkit, and the trendy-features roadmap. Companion to the catalog reference.
aliases:
  - sketchybar guide
tags:
  - domain/productivity
related:
  - "[[06-sketchybar|SketchyBar (catalog reference)]]"
  - "[[05-aerospace|AeroSpace]]"
---

# SketchyBar — complete guide

Everything about *how the bar works and how to change it*. The catalog page [[06-sketchybar|SketchyBar]] is the quick reference (what's installed, item table, reload); **this folder is the how-to.**

## Read in this order

| # | Chapter | What you'll learn |
| --- | --- | --- |
| 1 | [[01-model|The config model]] | bar → items → plugins → events; hotload; the mental model that makes everything else obvious |
| 2 | [[02-widgets|Every widget explained]] | each item on your bar — what it shows, the exact macOS command, and the trick |
| 3 | [[03-build-your-own|Add your own widget]] | the item + plugin pattern step-by-step, events vs polling, clicks, popups, the bash-3.2 trap |
| 4 | [[04-styling|The styling toolkit]] | palette, colour-grading, bar geometry (float/blur), brackets, popups, hover-reveal, glyphs |
| 5 | [[05-roadmap|Trendy roadmap]] | the showpiece features (Dynamic Island, app-menu mirror, graphs…) + the honest menu-bar-reveal answer |
| 6 | [[06-wishlist|Wishlist & backlog]] | **every idea from the build sessions** as a checklist — done / queued / open questions |

## The 30-second mental model

SketchyBar is a **daemon** you talk to with the `sketchybar` CLI. Your `sketchybarrc` is just a shell script that runs a pile of `sketchybar --add`/`--set` commands at startup. Each **item** is a chip on the bar; each item points at a **plugin** (a shell script) that runs on a timer or an **event** and sets the item's label/icon. That's the whole thing — no binary config, no GUI.

```
sketchybarrc ──sources──▶ items/*.sh  (define + style + subscribe each chip)
                                │ script=
                                ▼
                         plugins/*.sh  (run on event/interval → sketchybar --set $NAME …)
```

## Where it lives
Repo `sketchybar/` → whole-dir symlink → `~/.config/sketchybar`. Edit the repo files; **hotload** auto-applies them (the daemon watches the config dir). Details in [[01-model|chapter 1]].
