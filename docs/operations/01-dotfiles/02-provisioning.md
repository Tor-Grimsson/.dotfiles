---
title: Provisioning
type: guide
status: active
updated: 2026-07-05
description: bootstrap-cli.sh vs bootstrap.sh and brewfile-cli vs brewfile-gui — the CLI-vs-GUI split, the foreign-box / SSH quickstart, and what each script installs.
aliases:
  - provisioning
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[01-repo-model|repo model]]"
  - "[[INDEX|how this repo works]]"
---

# Provisioning

Two layers, split on the same line: **package manifests** (`brewfile-cli` / `brewfile-gui`) and **installers** (`bootstrap-cli.sh` / `bootstrap.sh`). The split is always **CLI-vs-GUI** — never which package manager installs a given tool.

## The split at a glance

| Layer | CLI-only — any box, incl. SSH | + GUI — daily-driver Mac |
|---|---|---|
| **Packages** | [`brewfile-cli`](../../brewfile-cli) — formulas only | [`brewfile-gui`](../../brewfile-gui) — casks + VS Code extensions |
| **Installer** | [`bootstrap-cli.sh`](../../bootstrap-cli.sh) | [`bootstrap.sh`](../../bootstrap.sh) — sources `bootstrap-cli.sh` first, then adds the GUI/macOS half |

`bootstrap.sh` doesn't duplicate anything: its first real line is `source "$DOT/bootstrap-cli.sh"`, so the CLI half is defined once and the GUI file is a thin superset.

## brewfile-cli vs brewfile-gui

- **`brewfile-cli`** — CLI/TUI formulas only (~54). Safe to `brew bundle` on any machine, including a foreign box over SSH: it pulls no cask apps and touches no macOS state.
- **`brewfile-gui`** — cask apps + VS Code extensions. Daily-driver Macs only.

Split on **2026-07-04**, triggered by needing to install just the CLI tools on a machine reached over SSH.

## bootstrap-cli.sh — CLI toolchain + symlinks

Runs on **any** box and installs the **complete CLI tool set across every package manager**, then symlinks the configs. It never runs `defaults`, installs a GUI app, loads a launchd agent, or stamps a Quick Action.

**Installs:**
- `brew bundle --file=brewfile-cli` — the formulas.
- **pipx / uv tools** — not brew formulas, but the same tier, because scripts call them by name:
  ```
  pipx install edge-tts
  uv tool install llm --with llm-anthropic
  ```
  (`uv tool install pdf2image` was tried and dropped 2026-07-05 — it's a library with no CLI entry point, so `uv tool install` has nothing to link; nothing in the repo imports it either. PDF→raster already has a working answer: poppler's `pdftoppm`/`pdftocairo`, pulled in as a dependency of `imagemagick`/`yazi`.)

> **Why the pipx/uv tools live here:** the scoping axis is CLI-vs-GUI, **not** package manager. `au-transcribe.sh` needs `llm` whether brew or uv installed it; omitting a tool because it's a uv tool would leave scripts calling a binary that isn't there. A `bootstrap-cli.sh` that installs *some* CLI tools is broken by definition — so it installs all of them.

**Symlinks:** shell (`.zshrc` / `.zprofile` / `.p10k.zsh` / `.nanorc`) · `.gitconfig` · `~/bin` · `.tmux.conf` (+ clones TPM and runs `install_plugins`) · Claude Code + its repo-backed config + `bucket` CLIs → `~/.local/bin` · nvim · yazi · broot · glow · mpv.

## bootstrap.sh — full daily-driver Mac

Sources `bootstrap-cli.sh`, then layers on everything that mutates macOS state:

- `brew bundle --file=brewfile-gui` (casks + VS Code extensions)
- VS Code settings/keybindings/extensions
- iTerm2 + Terminal.app prefs (`defaults`)
- AeroSpace + gcalcli config
- Finder Quick Actions (`macos/services/*.workflow`)
- launchd agents — `dot-sync` (repo auto-sync) + `tg-inbox` (Telegram capture)
- `macos/defaults.sh` (Finder / keyboard / Dock / screenshots baseline)

## Quickstart — foreign box over SSH

```bash
git clone <repo-url> ~/.dotfiles
~/.dotfiles/bootstrap-cli.sh
exec zsh
```

That gives you the full CLI environment — prompt, completions, tmux, nvim, yazi, the `bin/` scripts — with nothing touched that shouldn't be.

> **✓ Verified 2026-07-05** — real end-to-end run on a foreign/SSH box, not just theory: `brew bundle` (63 formulas), the third-party-tap `workmux` formula, pipx/uv tools, and every shell/tmux/TPM/claude/nvim/yazi symlink all landed; a second run came back idempotent. Two bugs surfaced and got fixed along the way (tap-trust isolation, dead `pdf2image` line) — detail in `session-log/2026-07-05-bootstrap-cli-remote-verify-tap-trust-fix.md`. For what comes *after* provisioning — actually working on a box like this — see [[operations/04-remote-machine/INDEX|Remote machine]].

> **Already `cd`'d into `~/.dotfiles`? Bare `bootstrap-cli.sh` will NOT run.** The shell never searches the current directory for commands — only `$PATH`. Typing just the filename gives `zsh: command not found`, every time, forever, until you prefix it. Run `./bootstrap-cli.sh` (leading `./` = "run the file right here"), or use the full path from the Quickstart above.

> **A tool rewriting a tracked file as a side effect (e.g. `nvim` touching `lazy-lock.json` on first launch) will make `git status` go dirty on this box.** You still want `git pull` to sync the file normally — you just don't want that box's incidental drift tracked or pushed back. See [[01-repo-model#Foreign/disposable boxes: local drift on a tracked file|repo model]] for the `git update-index --skip-worktree` fix.

> **Do NOT run `bootstrap.sh` on a foreign box.** It rewrites the machine's macOS defaults, installs GUI cask apps, imports iTerm/Terminal prefs, and loads auto-sync launchd agents — none of which belong on a box you only log into. It also runs under `set -e`, so one GUI step failing aborts the rest. Use `bootstrap-cli.sh`.

## Plugins hydrate separately

Bootstrap installs *tools*; plugin bodies are runtime state (see [[01-repo-model|repo model]]) and hydrate from their tracked declarations:

| Ecosystem | Declared in | Hydrated by |
|---|---|---|
| tmux (TPM) | `@plugin` lines in `tmux/.tmux.conf` | `bootstrap*.sh` (clone TPM + `install_plugins`), or `prefix I` live |
| nvim | `nvim/lazy-lock.json` (pinned) | first `nvim` launch |
| yazi | vendored in `yazi/` + `package.toml` | already present — arrives with the symlink |

## See also

- [[01-repo-model|Repo model]] — the symlink + tracked-vs-runtime model this builds.
- [TOOLING.md](../../TOOLING.md) — drift audit + open items.
