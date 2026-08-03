---
title: kol-agent-system — the wholesale outline
type: index
status: active
updated: 2026-08-03
description: The complete outline of the agent operating system — init, context economy, journaling, memory, plans, docs framework, human tier, behavior stack, routing, and the naming system. One doc per module, each with diagram, file map, and export notes. The design space for sharing the system wholesale or by module.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[../INDEX|docs root]]"
  - "[[../kol-claude-memory/INDEX|kol-claude-memory]]"
---

# kol-agent-system

The whole system, outlined for export — wholesale or by module. Each module doc answers: what it is, how it's wired, which files/skills/hooks it owns, and what extraction costs. Working title only; the public umbrella name is open and comes from the naming system ([[10-naming|10]]).

## Canon vs superseded — ruled 2026-08-03

This suite is the **design outline of the private source** (dotfiles). jabberwocky,
humpty and memory-glass are the **exports**. They are two views of one system, not
duplicates — so nothing here is retired for merely having an exported twin. Only a
doc whose *facts* stopped being true is marked superseded.

| Doc | Verdict | Why |
|---|---|---|
| `08-behavior` | 🔴 **superseded** | every hook it maps moved to humpty 2026-08-03; kept as the design record |
| `11-grant` | 🔴 **superseded** | `agent-grant` → `humpty-grant`; gate, badge and cadence all moved |
| `12-setup-a-to-z` | 🟡 **needs a pass** | walks the published system; the hook wiring half is now wrong |
| `04-memory` | 🟢 canon | pointer module — memory-glass verified accurate 2026-08-03 |
| `10-naming` | 🟢 canon | the Glass/Ubu/Alice bag; a copy now also lives in humpty |
| `00` `01` `02` `03` `05` `06` `07` `09` | 🟢 canon | describe dotfiles' own wiring, which did not move |

**Rule this produced:** a thing ships as a concept **and keeps its dotfiles copy**.
Nothing is single-homed, so an export never obsoletes its source doc.

## The publishing surface — added 2026-08-03

`kol-dumpty/ubu-roi` is the **public repo**, generated from humpty by `bin/humpty-payload`.
It receives runtime payload only — `hooks/ skills/ commands/ bin/ .claude-plugin/ LICENSE`
plus `README.public.md` staged as its README. `.kol/`, `docs/`, `lobby/`, `concepts/` and
`_tmp/` never leave the dev repo.

The generator refuses to stage unless the tests are green, no personal paths survive, every
hook `hooks.json` registers exists, and every skill has valid frontmatter. So the published
tree cannot drift from the dev repo by hand, and a broken plugin cannot be published by
accident.

**Rejected:** hoisting `.kol/` and `docs/` up to `kol-dumpty/` to leave only payload behind.
It would break `/ag-init` (which reads `.kol/` at repo root) and the self-hosting property
both humpty and jabberwocky were deliberately rebuilt for.

## The system at a glance

```
                        ┌─────────────────────────────────────────────┐
                        │            dotfiles (the source)            │
                        │  claude/ = repo-backed ~/.claude            │
                        │  skills(43) hooks packages agents memory    │
                        └──────────────┬──────────────────────────────┘
                                       │ bootstrap.sh symlinks
      ┌────────────────────────────────┼───────────────────────────────┐
      ▼                                ▼                               ▼
┌───────────┐                 ┌─────────────────┐              ┌──────────────┐
│ 01 INIT   │  boots agent →  │ per-repo .kol/  │ ← humans use │ 07 HUMAN     │
│ LLM_RULES │                 │ 02 llm-context  │              │ docs/ vault  │
│ ag-init   │                 │ 03 journaling   │              │ 06 framework │
└───────────┘                 │ 04 llm-memory   │              │ .obsidian    │
                              │ 05 llm-plan     │              └──────────────┘
                              └────────┬────────┘
                                       │ aggregated by
                              ┌────────▼────────┐      ┌──────────────────┐
                              │ 09 ROUTING      │      │ 08 BEHAVIOR      │
                              │ kol-glass lens  │      │ persona · hooks  │
                              │ repos/ memory/  │      │ ponytail · gates │
                              └─────────────────┘      └──────────────────┘
```

## Modules

| Doc | Module | One line |
|---|---|---|
| [[00-system-map\|00 — system map]] | **Review** | The one-page map of everything — private sources, exports, statuses, review checklist. **Start here.** |
| [[01-init\|01 — init]] | Boot | How an agent comes up: `LLM_RULES.md` symlink → `/ag-init` → context loaded, machine detected |
| [[02-context\|02 — context]] | State | `AGENT-CONTEXT.md` + `ARCHITECTURE.md` + the red-queen trim discipline that keeps context loadable |
| [[03-journaling\|03 — journaling]] | Time | The four log skills: playbook (live) · session-log (retro) · handoff (bridge) · milestone (seal) |
| [[04-memory\|04 — memory]] | Facts | The tier system + write-path redirect — built and shipped as memory-glass |
| [[05-plans\|05 — plans]] | Future | `llm-plan/` parking lot: graduate · park · kill |
| [[06-docs-framework\|06 — docs framework]] | Spec | kol-docs packages: frontmatter contract, archetypes, tag taxonomy, scaffolds |
| [[07-human-tier\|07 — human tier]] | Audience | `docs/` vault: documentation vs operations, siblings, `.obsidian` — the human's equal surface |
| [[08-behavior\|08 — behavior]] | Discipline | Persona (ships as Ubu Roi) + ponytail + the enforcement hooks — anti-word-soup as code |
| [[09-routing\|09 — routing]] | Search | The glass lenses over 30+ repos; grep first, indexer only when that fails |
| [[10-naming\|10 — naming]] | Names | The three-family bag: Glass=state · Ubu=actors · Alice=motion |
| [[11-grant\|11 — grant]] | Trust | Time-boxed permission windows: `prefix g` = 15m of read-only git + downloads, self-expiring, statusline-badged |
| [[12-setup-a-to-z\|12 — setup A–Z]] | Adopt | The zero-to-verified walkthrough of the published system: humpty · memory-glass · jabberwocky · dotfiles wiring, every command verbatim, traps footnoted |

## Export rules (apply to every module)

- **Scripts ship twice** — embedded in the doc (readable) and as real files (runnable).
- **Persona in public material is Ubu Roi** — never the private name.
- **Per-module token screen** before anything leaves: no user paths, no client names, no memory content.
- **Names come from [[10-naming|the bag]]** — module docs use working titles until the user assigns.
