---
title: The four lobbies — paths, flags, and what belongs where
type: reference
status: active
updated: 2026-08-01
description: The registered lobbies (dotfiles, humpty, kol-website, kol-ds-ui), how a flag name is derived from a path, what belongs in each queue, and how a fifth repo joins.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|Lobby]]"
  - "[[03-tooling|skills + scripts]]"
  - "[[operations/systems/repo-map/01-repos|the repo table]]"
---

## The registry lives in one place

`~/.dotfiles/files/folders.md` § `lobby` is the **single catalog**. `clip-drop.sh` parses it at runtime; the skills read it; `bin/lobby` reads it. Nothing hardcodes the list — a hardcoded copy is exactly how `ref-pick` silently lost three cards.

## The four

| lobby | path | flag | skill | holds |
|---|---|---|---|---|
| **dotfiles** | `~/.dotfiles/lobby` | `--dotfiles` | `/lobby-dotfiles` | tooling · scripts · configs · ref cards · the desk |
| **humpty** | `~/dev/projects/kol-dumpty/humpty/lobby` | `--humpty` | `/lobby-humpty` | agent behaviour — muzzle, output discipline, gates, laws ignored |
| **kol-website** | `~/dev/projects/kol-website/lobby` | `--kol-website` | `/lobby-web` | site content · UI issues |
| **kol-ds-ui** | `~/dev/projects/kol-ds-ui/lobby` | `--kol-ds-ui` | `/lobby-ds` | component specs · tokens · design-system behaviour |

Every one of the four is both a **destination** (its `inbox/`) and a **filer** (its `outbox/`) — the roles are per-ticket, not per-repo. dotfiles received `agent-init-docs-index` from kol-ds-ui and filed `goal-loop-is-repo-scoped`'s re-home in the same week.

The **flag** is derived, not declared: the last path segment before `/lobby`, minus a leading dot (`lobby_flag()` in `clip-drop.sh`). `~/.dotfiles/lobby` → `dotfiles`. Add a registry row and the flag falls out.

The **skill name** is the flag, shortened only where the flag is unwieldy: `kol-website` → `/lobby-web`, `kol-ds-ui` → `/lobby-ds`. Those two aliases are the *only* place the two vocabularies differ, and the mapping is stated here so it stays findable.

## How a fifth repo joins

1. `mkdir -p <repo>/lobby/{inbox,done,archive,outbox,_assets}`
2. Copy a ledger — `~/.dotfiles/lobby/INDEX.md` is the reference implementation; change the title, the flag, and the **bar for closed**. Keep the empty **Filed elsewhere** section: a repo with no `outbox/` section silently loses every receipt sent back to it.
3. Add the row to `files/folders.md` § `lobby`. The `clip-drop.sh` flag now works with no code change.
4. Add a `/lobby-<name>` skill only if the repo will receive tickets *from elsewhere often*. `clip-drop.sh --<flag>` covers the occasional case without one.
5. Add the row to the table above and to [[05-lookup|05-lookup]].

## Not registered, and why

| path | status |
|---|---|
| `~/dev/projects/_kol-lobby` | **the ancestor.** A pre-system dumping ground — loose notes (`kol-ds-nested-theming-fix.md`, `format-text-nvim.txt`), four project folders, a screenshot. Untracked, backed by nothing. It is what the lobby system replaces. Needs triage: each item belongs in a real lobby or in the bin. |
| `~/dev/projects/kol-dumpty/lobby` | family-level, **not inside a repo** — anything there is untracked. Treat as misfiled and name the repo it belongs in. |
| `kol-dumpty/jabberwocky/lobby` | agent-OS port notes. Real, but not in the registry — reachable only by hand. Register it or fold it into humpty. |

## Sibling ledgers that predate the standard

**humpty** ran its own four-state ledger (`LEDGER.md`: `filed → researched → addressed → verified`) before this system existed, and its `verified` bar — *a measurement in `06-measure/_results/`, not an opinion* — is stricter than the standard and stays. **kol-ds-ui** ran `INDEX.md` with `parked` / `USER RULING` / `NEEDS RULING`. Both are absorbed rather than overwritten: see [[02-lifecycle|02-lifecycle]] § Per-repo bars.

**Absorbed is not the same as absorbed *silently*, and that cost a state.** humpty also ran `retired` — closed without a fix, with the reason written down — and it was absorbed in practice onto ⚪, the glyph the ladder had already given `parked`. Renaming a rung is safe: `researched` and `verified` are `read` and `closed` under local names, and the emoji still means one thing. **`retired` was never a rename — it was a sixth ending**, and folding it onto a fifth made one glyph mean both *revisitable* and *terminal* across four ledgers. It is its own state, ⚫, since 2026-08-01. The lesson generalises: when a repo's dialect carries a word the ladder has **no rung for**, that is a gap in the standard, not a local flavour to map onto the nearest neighbour.
