---
title: docs — top-level router
type: index
status: active
updated: 2026-07-11
description: Entry point to the dotfiles vault. Splits into documentation (the tool catalog & guides), operations (repo machinery & systems), and three named siblings (kol-cli cheat cards, scripts, kol-terminality).
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[TOOLING|tooling audit & sync]]"
---

# docs

The dotfiles Obsidian vault. Content and machinery are separated — the split follows the kol-docs three-layer model (agent state lives outside the vault in `.kol/llm-context/`).

## Layers

| Layer | Home | Holds |
|---|---|---|
| **Content** | [[documentation/INDEX|documentation/]] | The repo's subject — one reference doc per installed tool + multi-chapter guides. |
| **Machinery** | [[operations/INDEX|operations/]] | How the repo is built/run + repo-built systems (dotfiles model, agent config, docs system, remote, CDN snapshots). |

## Siblings
Boundary sets that are neither pure content nor pure machinery — kept at the top level with their own names.

| Sibling | What it covers |
|---|---|
| [[kol-cli/INDEX|kol-cli]] | Printable cross-cutting cheat cards — Neovim · tmux · yazi · fzf · AeroSpace · git · network · Tailscale/Jellyfin · storage. Symlinked into the kol-vault for print. |
| [[scripts/INDEX|scripts]] | The repo's own `bin/` helpers (au/vid/img/pdf/art/batch/tor/fs/bucket/os/theme), one doc per family. |
| [[kol-terminality/INDEX|kol-terminality]] | The terminal-as-workstation initiative — vision & cockpit, workspaces, Neovim/desk/tmux/notes, the daily login→work→close→track ritual + automation, and connected reach. Outline + roadmap; nothing filtered. |

## Related
- [[TOOLING|tooling audit & sync]] — the drift audit, Brewfile reconciliation, cross-arch portability notes, and open items.

## Maintenance
- Source of truth for *what's installed* is the repo `brewfile-cli` + `brewfile-gui`. When a tool is added/removed there, add/remove its doc under `documentation/`.
- The catalog intentionally runs ahead of the Brewfiles: `pbcopy`/`pbpaste` are macOS built-ins, a few CLIs (`edge-tts` via pipx, `llm` + `kanban-tui` via uv) are not Brewfile lines, some tmux plugins are TPM-managed, and `ponytail` is a Claude Code plugin — don't "fix" the count against the Brewfiles.
- Removed 2026-07-05: **tmux-agent-sidebar** (TPM plugin). Removed 2026-06-04: **tmate** + **qlstephen**.
- **2026-07-08 restructure:** `docs/` converged onto the kol-docs content/operations split — flat `NN-` sections moved under `documentation/` and `operations/`, with `kol-cli`/`scripts`/`explorations` as named siblings. `.obsidian` seeding + the kol-vault sync-script repoint are follow-on work, not done here.

