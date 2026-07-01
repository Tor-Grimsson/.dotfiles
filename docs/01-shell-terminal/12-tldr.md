---
title: tldr (tealdeer)
type: reference
status: active
updated: 2026-06-24
description: Community cheat-sheets of real examples per command — `tldr tar` shows the five invocations you actually use, not the whole man page.
aliases:
  - tldr
  - tealdeer
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://tealdeer-rs.github.io/tealdeer/
  repo: https://github.com/tealdeer-rs/tealdeer
  manual: https://tealdeer-rs.github.io/tealdeer/usage.html
  brew: https://formulae.brew.sh/formula/tealdeer
  tldr-pages: https://tldr.sh/
covers:
  - First-run cache update and config
  - tldr lookups, listing, platform selection
  - The tealdeer-vs-man distinction
related:
  - "[[07-fastfetch|fastfetch]]"
  - "[[11-htop|htop]]"
---

## Summary
`tldr <command>` prints a handful of **practical, copy-paste examples** for a command — the common cases, not an exhaustive reference. It's the fast antidote to a 600-line man page when you just need "how do I extract a tar.gz again".

**tealdeer** is the client (fast Rust implementation); **tldr-pages** is the community example database it renders. Pages are cached **locally** after the first fetch, so lookups are offline and instant.

| Piece | Does | Needs |
|---|---|---|
| `tealdeer` (brew) | the `tldr` command | network **once** to seed the cache |
| `tldr --update` | download/refresh the page cache | network |
| tldr-pages | the example content (rendered, not installed separately) | — |

## Setup
1. Install: `brew bundle` (it's in the `Brewfile` — `brew "tealdeer"`).
2. Seed the cache **once**: `tldr --update`
3. (Optional) auto-refresh — `~/.config/tealdeer/config.toml`:
   ```toml
   [updates]
   auto_update = true
   auto_update_interval_hours = 720   # ~monthly
   ```
4. Test: `tldr tar`

## Use
```sh
tldr tar               # the 5 tar invocations you actually use
tldr ffmpeg            # works for installed tools too
tldr git commit        # subcommands: space-separated
tldr --update          # refresh the local page cache
tldr --list            # every page available
tldr --platform linux  # show the Linux page while on macOS
tldr --show-paths      # where the cache + config live
```

## Flags
| Flag | Does | Example |
|---|---|---|
| `-u`, `--update` | refresh the local cache | `tldr -u` |
| `-l`, `--list` | list all cached pages | `tldr -l` |
| `-p`, `--platform` | force a platform's page | `-p linux` / `-p osx` |
| `-f`, `--render` | render a local page file | `-f ./page.md` |
| `--show-paths` | print cache/config paths | — |
| `--clear-cache` | wipe the local cache | — |
| `-q`, `--quiet` | suppress update/info noise | — |

## Why installed
man pages answer "what are all the options"; tldr answers "what's the command I want". For tools used occasionally — `tar`, `ffmpeg`, `rsync`, `dd` — the example is faster than scanning a wall of flags. tealdeer over the original node client: no Node runtime, instant start, local cache.

## Biggest win
Offline, instant, example-first. After `tldr --update` once, every lookup is a local cache hit — no network, no waiting, just the three or four invocations that cover 90% of real use.

## Future use
Enable `auto_update` so the cache never goes stale; a `tldrf` fzf wrapper (`tldr --list | fzf --preview 'tldr {}'`) if browsing pages becomes a habit. Custom local pages under the tealdeer pages dir for in-house scripts.
