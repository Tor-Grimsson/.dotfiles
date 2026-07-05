---
title: Repo model
type: reference
status: active
updated: 2026-07-05
description: Two machines, one repo — the symlink source-of-truth model, cross-arch portability, and what's tracked vs. left as runtime state.
aliases:
  - repo-model
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[02-provisioning|provisioning]]"
  - "[[INDEX|how this repo works]]"
---

# Repo model

`~/.dotfiles` is a git repo that *is* the machine's config. Nothing is copied into place — configs are **symlinked** back out of the repo, so editing `~/.zshrc` (a symlink) edits the tracked file. Git is the single source of truth; there is no separate "apply" step to forget.

## One repo, two machines

The same repo drives two Macs of different architecture:

| Machine | Arch | Brew prefix |
|---|---|---|
| Intel iMac | `x86_64` | `/usr/local` |
| Apple-Silicon MBP | `arm64` | `/opt/homebrew` |

**Consequence — never hardcode a brew prefix in a tracked file.** Use the bare command name (found via `PATH`) or `$(brew --prefix)`. A hardcoded `/opt/homebrew/...` path silently breaks on the iMac and vice-versa. This is the repo's one non-negotiable portability rule.

## Source of truth: git, not iCloud

The repo (git) is the single source of truth for all portable config. **iCloud is for media and Obsidian vaults only** — never for config sync. If it belongs on both machines and isn't a binary blob, it lives here.

## The symlink model

`bootstrap.sh` / `bootstrap-cli.sh` create symlinks from `$HOME` (and `~/.config`) *into* the repo:

```
~/.zshrc            → ~/.dotfiles/shell/.zshrc
~/.config/nvim      → ~/.dotfiles/nvim
~/.claude/CLAUDE.md → ~/.dotfiles/claude/CLAUDE.md
~/bin               → ~/.dotfiles/bin
```

So `~/.claude` is repo-backed: editing `~/.claude/settings.json`, a skill, or `CLAUDE.md` edits the repo directly. See [provisioning](02-provisioning.md) for the full link map.

## Tracked vs. runtime state

The repo tracks **declarations and config**, not the heavy artifacts a tool downloads for itself:

| Tracked (in the repo) | Runtime state (untracked, per-machine) |
|---|---|
| `@plugin` lines in `tmux/.tmux.conf` | the TPM plugin clones in `~/.tmux/plugins/` |
| `nvim/lazy-lock.json` (pinned versions) | the nvim plugins in `~/.local/share/nvim/` |
| vendored yazi plugins in `yazi/` | — (these *are* tracked, on purpose) |
| `claude/` config + skills | `~/.claude` history / sessions / plugin cache |
| package manifests (`brewfile-*`) | the installed Homebrew Cellar |
| env-var *references* (`${GLIF_API_TOKEN}`) | the real secrets in `~/.secrets` (local, `chmod 600`) |

Rule of thumb: if it reproduces from a tracked declaration (a lock file, a `@plugin` line, a brewfile), it stays untracked. yazi plugins are the deliberate exception — vendored so they arrive with the whole-dir symlink, no fetch step.

**Secrets never land in a tracked file as literals** — only as `${VAR}` references sourced from Bitwarden / `~/.secrets`.

## Syncing the two machines

- **Transport is git.** The `dot-sync` launchd agent (installed by `bootstrap.sh`) pulls/pushes committed work every 30 min — but only ever *transports*; it never commits. A dirty tree is left untouched. The user owns every commit.
- **Adding a config links per machine.** The session that adds a new config hand-links it on the machine it was added on; `bootstrap.sh` covers only fresh setups. So a new symlink landing on the iMac still needs a hand-link (or a bootstrap run) on the MBP even after the commit syncs.

## See also

- [Provisioning](02-provisioning.md) — the scripts + brewfiles that build all of the above.
- [ARCHITECTURE.md](../../.kol/llm-context/ARCHITECTURE.md) — §1–§3 are the load-bearing form of this doc.
