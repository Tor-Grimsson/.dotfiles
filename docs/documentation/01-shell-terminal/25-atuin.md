---
title: atuin
type: reference
status: active
updated: 2026-07-09
description: SQLite-backed shell history with a full-screen fuzzy search UI — records exit code/duration/cwd/host per command, scoped search (global/host/session/directory), optional encrypted multi-machine sync. Bound to Ctrl-P and Shift+Up (plain Up is zsh prefix search; fzf keeps Ctrl-R).
aliases:
  - atuin
tags:
  - domain/shell
  - pattern/tui
  - integration/brew-formula
links:
  website: https://atuin.sh/
  repo: https://github.com/atuinsh/atuin
  docs: https://docs.atuin.sh/
  brew: https://formulae.brew.sh/formula/atuin
covers:
  - the Ctrl-P + Shift+Up bindings (fzf keeps Ctrl-R; plain Up is zsh prefix search)
  - scoped search (global/host/session/directory) + the tracked config.toml
  - importing existing history, and the sync opt-in
related:
  - "[[12-fzf|fzf]]"
  - "[[13-shell-functions|Shell functions]]"
---

## Summary

Atuin replaces plain reverse-i-search with a SQLite-backed history DB and a full-screen fuzzy picker. Beyond text, it records **exit code, duration, cwd, host, and session** per command, so search can be scoped (this directory / this session / this host / everywhere) instead of one flat list. Sync across machines is built in but opt-in — not enabled here yet.

## Setup

1. Install (in `brewfile-cli`): `brew install atuin`
2. Config is tracked at `atuin/config.toml`, symlinked to `~/.config/atuin/config.toml` by `bootstrap.sh` (history.db/key/session stay local, untracked, in `~/.local/share/atuin/`)
3. Init wired in `shell/.zshrc` with `--disable-ctrl-r` (fzf keeps Ctrl-R) **and `--disable-up-arrow`** (plain Up stays zsh history). atuin is bound to **Ctrl-P** (`bindkey '^P' atuin-search`, full search) and **Shift+Up** (`bindkey '^[[1;2A' atuin-up-search`). fzf keeps Ctrl-T/Alt-C — see [[12-fzf|fzf]]
4. One-time backfill of existing shell history: `atuin import auto`

## How to use

| Key | Does |
|---|---|
| `Ctrl-p` | Open search (global scope); press again while searching to cycle scope |
| `Shift-Up` | Open atuin scoped to the current directory (`filter_mode_shell_up_key_binding`), seeded with the typed prefix — plain `Up` is zsh prefix search now |
| `Ctrl-s` | Cycle search mode (fuzzy / prefix / fulltext / skim) |
| `Enter` | Run the selected command |
| `Tab` | Paste it into the prompt instead of running |
| `Ctrl-o` | Open the inspector (exit code, duration, cwd, host for that entry) |
| `Esc` / `Ctrl-c` | Cancel, restore what you were typing |

```sh
atuin stats                 # top commands, usage patterns
atuin search <query>         # same search from a script/non-interactive shell
atuin import auto            # backfill from the existing .zsh_history (one-time)
```

## Config

`atuin/config.toml` sets three things deliberately, everything else stays on Atuin's defaults:

| Key | Value | Why |
|---|---|---|
| `update_check` | `false` | no startup network call to check for a new release |
| `enter_accept` | `true` | Enter runs the command immediately (Tab to edit instead) — this is what Atuin ships in its own generated config, pinned here explicitly |
| `filter_mode_shell_up_key_binding` | `"directory"` | Shift+Up (the atuin up-search widget) stays scoped to cwd even while Ctrl-P searches globally |

## Sync (not enabled)

`atuin register` / `atuin login` turns on encrypted history sync (hosted `atuin.sh` or self-hosted) — same history on the iMac and MBP. Deliberately left off: get used to local scoped search first, decide on hosted-vs-self-hosted later. Nothing here depends on it.

## Why installed

Two machines, two separate `.zsh_history` files — a command run on one box is invisible on the other. Sync closes that gap when turned on. Locally, exit-code/cwd context on every entry does what plain history search can't: "what did I run in this directory that actually succeeded."

## Future use

Turn on sync once the local workflow has been lived with; `atuin stats` as a periodic "what do I actually run" check.
