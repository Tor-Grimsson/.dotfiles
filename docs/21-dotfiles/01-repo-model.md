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
  - "[[00-kol-cli/04-git-github|Git & GitHub]]"
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
| — | `_tmp/` (repo root, gitignored) — quarantined/superseded files kept for reference, never tracked |

Rule of thumb: if it reproduces from a tracked declaration (a lock file, a `@plugin` line, a brewfile), it stays untracked. yazi plugins are the deliberate exception — vendored so they arrive with the whole-dir symlink, no fetch step. `_tmp/` is the other direction — things deliberately taken *out* of tracking (a quarantined skill, removed templates) instead of hard-deleted.

**Secrets never land in a tracked file as literals** — only as `${VAR}` references sourced from Bitwarden / `~/.secrets`.

## Syncing the two machines

- **Transport is git.** The `dot-sync` launchd agent (installed by `bootstrap.sh`) pulls/pushes committed work every 30 min — but only ever *transports*; it never commits. A dirty tree is left untouched. The user owns every commit.
- **Adding a config links per machine.** The session that adds a new config hand-links it on the machine it was added on; `bootstrap.sh` covers only fresh setups. So a new symlink landing on the iMac still needs a hand-link (or a bootstrap run) on the MBP even after the commit syncs.

## Foreign/disposable boxes: local drift on a tracked file

`bootstrap-cli.sh` also targets **foreign/SSH boxes** that aren't one of the two fleet machines (see [provisioning](02-provisioning.md)'s Quickstart) — a one-off test or throwaway remote, not somewhere you `git commit` from.

On a box like that, a tool can rewrite a tracked file as a normal side effect of doing its job — e.g. `nvim/lazy-lock.json`: first launch resolves plugins against the pinned versions and can touch the lockfile even though nothing about the fleet's actual pins changed. Result: `git status` goes dirty on a box you never intended to commit from.

You just don't want *that box's* incidental local rewrites tracked, shown as a diff, or ever accidentally pushed back over the real pins.

```sh
git update-index --skip-worktree nvim/lazy-lock.json
```

Run once, on that box, inside `~/.dotfiles`. It's a **local, per-clone flag** — git stops reporting worktree changes to the file *in that clone only* (`git status`/`git diff` go quiet on it). Reverse it with `git update-index --no-skip-worktree nvim/lazy-lock.json` if that box is ever promoted to a real fleet member (at which point its lockfile changes become meaningful again and should be committed like on the iMac/MBP).

**Live example — the `acyr` remote box:** currently has two files flagged this way, `claude/settings.json` and `nvim/lazy-lock.json` (confirmed via `git ls-files -v | grep '^S'`, 2026-07-05). `acyr` only ever pulls and holds these flags — it never commits from that box.

**What this does *not* do (tested live, 2026-07-05, not assumed):** it does **not** mean "`git pull` keeps flowing the fleet's real updates through while ignoring local drift." If the file has actual local drift when a `pull`/`rebase`/`checkout` needs to touch it, git **aborts the whole operation** — `"Your local changes to <file> would be overwritten by merge/checkout... Aborting."` — the same way it would with any dirty tracked file, skip-worktree or not. It only silences *reporting* (`status`/`diff`); it does not make git tolerant of the drift during an actual sync. If a pull on this box ever refuses because of this file: `git update-index --no-skip-worktree nvim/lazy-lock.json`, then `git checkout -- nvim/lazy-lock.json` (drop the local rewrite, take the fleet's version) or stash it, pull, then re-apply `--skip-worktree`.

## See also

- [Provisioning](02-provisioning.md) — the scripts + brewfiles that build all of the above.
- [ARCHITECTURE.md](../../.kol/llm-context/ARCHITECTURE.md) — §1–§3 are the load-bearing form of this doc.
