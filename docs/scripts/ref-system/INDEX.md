---
title: Reference-card system
type: index
status: active
updated: 2026-07-29
description: The ref pipeline as a system — cards (data) → engine (bin/ref) → renderer (glow/bat) → theme (JSON) → terminal. Read 01→05 to follow a card from authored text to pixels.
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[scripts/INDEX|Scripts index]]"
  - "[[20-files|files]]"
  - "[[20-files|files]]"
---

# The ref system

One engine prints hand-kept reference cards to the terminal, filtered by words in
their section titles. Not one script — a pipeline with four ends. The docs are
numbered in pipeline order: reading 01→05 follows a card from authored markdown
to rendered pixels.

| doc | end | carries |
|---|---|---|
| [[01-system\|01 — system]] | the whole | architecture + the engine (`bin/ref`), card registry, aliases, ref-pick |
| [[02-cards\|02 — cards]] | data | authoring the card files: no per-row spacers, 46-char cells, `\| ## name \|` in-table groups, filter-word headers, and **`ref --lint`** — the dialect as a machine check |
| [[03-glow\|03 — glow]] | renderer | the element vocabulary glow can draw + how the nvim card renders |
| [[04-theme\|04 — theme]] | style | the vendored style JSON, its values as tables, opt-in/out |
| [[05-terminal\|05 — terminal]] | screen | pager vs scrollback, the cat-pipe, color forcing, width |

## Sources

| what | path |
|---|---|
| engine | `~/.dotfiles/bin/ref` (aliases `bin/ref-tmux` `-nvim` `-git` `-yazi` `-explorer` `-grep` `-media` `-desk` `-terminal` `-shell` `-system` `-files` `-pick`) |
| card data | `~/.dotfiles/files/folders.md` · `~/.dotfiles/ref/{tmux,nvim,git,yazi,explorer,grep,media,desk,terminal,shell,system}.md` — the keys card dissolved into these 2026-07-29 |
| vendored theme | `~/.dotfiles/ref/glow-style.json` (wired 2026-08-02 — see [[04-theme\|04 — theme]]) |
| glow config | `~/.dotfiles/glow/glow.yml` → symlinked to `~/Library/Preferences/glow/glow.yml` |
| glow itself | [[documentation/01-shell-terminal/08-glow|glow (tool catalog)]] |
