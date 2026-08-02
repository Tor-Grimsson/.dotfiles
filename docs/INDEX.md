---
title: docs — top-level router
type: index
status: active
updated: 2026-08-01
description: Entry point to the dotfiles vault. Three shelves — documentation (the tool catalog & guides), operations (repo machinery + systems/, the home for every interconnected system), and the repo's own scripts + kol-cli cheat cards. Carries the agent's read contract for this vault.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[TOOLING|tooling audit & sync]]"
  - "[[operations/systems/INDEX|systems/]]"
---

# docs

The dotfiles Obsidian vault — **curated, for the human**. Agent state lives outside it in `.kol/llm-context/`; this side is written to be read.

## The three shelves

| Shelf | Home | Holds |
|---|---|---|
| **Content** | [[documentation/INDEX|documentation/]] | The repo's subject — one reference doc per installed tool + multi-chapter guides. |
| **Machinery** | [[operations/INDEX|operations/]] | How this repo is built and run — plus **[[operations/systems/INDEX|systems/]]**, one folder per interconnected system (agent-system · claude-memory · claude-harness · docs-framework · cdn · terminality · repo-map · lobby · headless-agents). |
| **This repo's own** | [[scripts/INDEX|scripts/]] · [[kol-cli/INDEX|kol-cli/]] | `bin/` helpers, one doc per family; and the printable cross-cutting cheat cards symlinked into the kol-vault. |

## For the agent — the read contract for this vault

**`docs/` is the rules layer; `.kol/` is state.** Search here before improvising anything, and
search by **grep** — this vault is a catalog written to be found by name, not read end to end.

**The one rule that outranks the rest: a summary is never the source.** This repo is unusually
full of enumerations — a tool catalog, a systems index, cheat cards, a folder registry, a copy of
a spec. Every one of them is a *description* of something that lives elsewhere and changes without
asking. A row that reads as current can be a snapshot nobody refreshed.

| If the question is about | Open the enumeration | …but answer from the source |
|---|---|---|
| whether a tool is installed | [[TOOLING\|tooling audit]] · [[documentation/INDEX\|documentation/]] | `brewfile-cli` + `brewfile-gui` — and the catalog **intentionally runs ahead** of them (see Maintenance) |
| what a key or command does | the `ref/` card (`ref-lobby`, `ref-keys`, …) | the config that binds it — `tmux.conf`, `keybindings.json`, the script's own `--help` |
| where a folder lives | `files/folders.md` | the path itself. `folders.md` is the **registry** `clip-drop.sh` and `bin/lobby` parse at runtime — wrong there means wrong everywhere |
| a lobby ticket's state | [[operations/systems/lobby/INDEX\|systems/lobby]] | that lobby's own `INDEX.md`/`LEDGER.md` — **the destination ledger, not ours**, and never a raw `ls` |
| the docs spec a repo follows | a repo's `.kol/docs-framework/` | `claude/packages/kol-docs/` **here** — the repo copies are copies, and no sync skill exists |
| how a system actually behaves | its `operations/systems/<name>/` doc | the hook, script or skill it documents — the code is the contract |

**Grep entry points.** Section headers in `files/folders.md` (`## lobby`), ref-card names
(`ref-lobby`), skill directory names under `claude/skills/`, script names under `bin/`, and system
folder names under `operations/systems/`. All stable handles; all greppable from the repo root.

**Deliberately not under `docs/`** — live state, not published documentation: `lobby/` and its
`INDEX.md` ledger (plus `lobby/outbox/`, the receipts for tickets this repo filed elsewhere),
`.kol/llm-context/` (agent state), `claude/` (skills, hooks, memory), `files/`, `bin/`. An agent
that assumes `docs/` is everything will miss the queue addressed to it and the work owed back to it.

## The rule (2026-07-30)

**A system does not live at the root.** Anything spanning repos, machines or services goes in `operations/systems/`. Before adding a folder here, name its shelf; if the answer is "it's its own thing", it's a system — `systems/` is sized to grow and takes it.

Root cleanup 2026-07-30: `kol-agent-system` · `kol-claude-memory` · `kol-terminality` moved into `operations/systems/` (as `agent-system` · `claude-memory` · `terminality`), joining `claude-harness` · `docs-framework` · `cdn`, which came out of the numbered operations sequence for the same reason.

## Related
- [[TOOLING|tooling audit & sync]] — the drift audit, Brewfile reconciliation, cross-arch portability notes, and open items.

## Maintenance
- Source of truth for *what's installed* is the repo `brewfile-cli` + `brewfile-gui`. When a tool is added/removed there, add/remove its doc under `documentation/`.
- The catalog intentionally runs ahead of the Brewfiles: `pbcopy`/`pbpaste` are macOS built-ins, a few CLIs (`edge-tts` via pipx, `llm` + `kanban-tui` via uv) are not Brewfile lines, some tmux plugins are TPM-managed, and `ponytail` is a Claude Code plugin — don't "fix" the count against the Brewfiles.
- Removed 2026-07-05: **tmux-agent-sidebar** (TPM plugin). Removed 2026-06-04: **tmate** + **qlstephen**.
- **2026-07-08 restructure:** `docs/` converged onto the kol-docs content/operations split — flat `NN-` sections moved under `documentation/` and `operations/`, with `kol-cli`/`scripts`/`explorations` as named siblings. Superseded in part by the 2026-07-30 systems cleanup above.
