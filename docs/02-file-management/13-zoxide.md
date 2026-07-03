---
title: zoxide
type: reference
status: active
updated: 2026-06-10
description: Smarter `cd` — learns the directories you visit and jumps to the best frecency match (`z kol` → the kol project dir). `zi` picks interactively via fzf.
aliases:
  - zoxide
  - z
  - zi
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/ajeetdsouza/zoxide
  repo: https://github.com/ajeetdsouza/zoxide
  manual: https://github.com/ajeetdsouza/zoxide#readme
  brew: https://formulae.brew.sh/formula/zoxide
covers:
  - z / zi jumping and the frecency model
  - init wiring in .zshrc, database maintenance
related:
  - "[[12-fzf|fzf]]"
  - "[[03-broot|broot]]"
---

## Summary
`z` replaces `cd` for directories you've been to before: zoxide records every visit, ranks dirs by **frecency** (frequency + recency), and `z <fragment>` jumps to the best match. `zi` shows the ranked candidates in [fzf](12-fzf.md) instead of jumping blind.

It only knows dirs visited *after* install — the database starts empty and fills as you move around.

## Use

```sh
z kol            # jump to the highest-ranked dir matching "kol"
z dev proj       # multiple fragments must all match, in order
z -              # back to the previous dir (like cd -)
z ~/Downloads    # real paths still work — z falls back to plain cd
zi kol           # fzf picker over all matches, ranked
zoxide query -ls # dump the database with scores
zoxide remove <path>   # evict a dead/renamed dir
```

## Flags / commands

| Command | Does |
|---|---|
| `z <keywords>` | jump to best frecency match |
| `zi <keywords>` | interactive fzf pick |
| `zoxide query -ls` | list database with scores |
| `zoxide add <path>` | seed a dir by hand |
| `zoxide remove <path>` | delete an entry |
| `zoxide init zsh --cmd cd` | init variant that replaces `cd` itself (not used here) |

## Config
No config file. The hook is one line at the end of `shell/.zshrc` — `eval "$(zoxide init zsh)"` (guarded on the binary existing; must run after compinit, which oh-my-zsh handles). Database lives in `~/Library/Application Support/zoxide/` (override: `_ZO_DATA_DIR`), machine-local by design — each Mac learns its own paths.

## Why installed
The fifth member of the modern-CLI core ([fzf](12-fzf.md)/[fd](10-fd.md)/[bat](09-bat.md)/[eza](08-eza.md)/[ripgrep](11-ripgrep.md) were already in). The omz `dirhistory` plugin only walks Alt-arrow history; zoxide makes any deep project dir two keystrokes from anywhere.

## Biggest win
`z` + a fragment beats tab-completing nested paths every time — `z workbox` from a fresh shell lands in an iCloud path nobody wants to type.

## Future use
`zi` piped into scripts (`zoxide query -l` as an fzf source for project pickers); `--cmd cd` if the `z` muscle memory never forms.
