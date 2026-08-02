---
title: Repo table — what each one is
type: reference
status: active
updated: 2026-07-30
description: One row per repo — hand-kept meaning (what it is, what it connects to) plus a generated structure block (docs/.kol/memory/package presence) refreshed by repo-map.sh. Meaning is authored; structure is derived; drift is flagged, never silently rewritten.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|repo map]]"
---

# The repos

**Meaning is hand-kept** (READMEs are mostly Vite boilerplate — worthless as a source). **Structure is generated** by `repo-map.sh` into the block at the bottom. If a row here says something the code contradicts, the row is wrong — fix it here.

## Top level

| repo | what it is | wires to |
|---|---|---|
| **kol-ds-ui** | the design system — 15 published packages under `@kolkrabbi/*` (component · framework · icons · theme · content · store · dashboards · foundry · styleguide · workshop · brand · chess · media-client · scrape · brand-template), plus in-repo `showcase/` + `workbench/` that dogfood them | publishes to → website · chess · ds-fxr · its own showcase/workbench |
| **kol-website** | the public site (`apps/web`) — the biggest package consumer, 10 of them | consumes ds-ui packages |
| **kol-chess** | the chess app — and publishes `@kolkrabbi/kol-chess` back into the set | consumes 6 ds-ui packages · publishes 1 |
| **kol-ds-fxr** | `editor.kolkrabbi.io` — the fx/editor surface | consumes 4 ds-ui packages |
| **kol-vault** | the personal Obsidian vault — markdown, not code; the law lives in `_system/_kol-rules/` | read by the desk widgets (`desk-notes.md`) |
| **kol-glass** | the aggregator lens — owns nothing, symlinks every repo's `docs/` and `.kol/llm-memory/` into one vault | symlinks everything · `sync.sh` regenerates |

## kol-apps/ — the family (20 repos)

Clients, experiments and one-offs. No shared build; each is standalone. Names are written out longhand on purpose — the drift check greps this file, so brace shorthand would hide a repo from it.

**Client work:** `kol-client-ac` · `kol-client-acyr-website` · `kol-client-aftra` · `kol-client-canalix` · `kol-client-canalix-contract` · `kol-client-kolkrabbi`.

**Tools / experiments:** `kol-chrome-vcap` · `kol-docs` · `kol-docs-md` · `kol-docs-noter` · `kol-draw-3d` · `kol-editor-radar` · `kol-labs-single` · `kol-lightroom` · `kol-mirror` · `kol-modulator` · `kol-monitor` · `kol-radial` · `kol-svg-distress` · `kol-years`.

Live surfaces: `kol-monitor` → monitor.kolkrabbi.io · `kol-chrome-vcap` → vcap.kolkrabbi.io.

## kol-dumpty/ — the agent stack (3 repos)

| repo | what it is | you go here when |
|---|---|---|
| **humpty** | the muzzle — reuse-first doctrine, the 4-level dial, `st`/`stf`/`stfu` clamps, the permission gate, the hooks that enforce them | the agent writes word soup, buries the lead, ignores a law, or a gate misfires |
| **jabberwocky** | the agent OS — init · context economy · journaling · memory · plans · docs framework · human tier · behavior · routing | the agent's *structure* is wrong: how it boots, journals, remembers, plans |
| **memory-glass** | the memory template — git-backed, symlinked, shared across repos and machines | the memory *mechanism* needs changing (not its content) |

⚠ **`kol-dumpty/` is not a repo** — it's a plain folder holding three. Anything living directly in it (e.g. `lobby/`) is untracked and backed by nothing.

## Not repos

`_kol-lobby` · `_kol-quick` · `kol-ds-type` · `kol-studio` — folders under `~/dev/projects` that are neither repos nor families. Either they should be, or they should move; flagged 2026-07-30, undecided.

<!-- GENERATED: repo-map.sh --update — do not hand-edit below this line -->

### Generated — the live estate (`repo-map.sh --update`, 2026-07-30)

29 repos · 2 families

| repo | docs | .kol | memory | package |
|---|---|---|---|---|
| `kol-apps/kol-chrome-vcap` | ✓ | · | · | · |
| `kol-apps/kol-client-ac` | ✓ | · | · | ✓ |
| `kol-apps/kol-client-acyr-website` | ✓ | · | · | ✓ |
| `kol-apps/kol-client-aftra` | ✓ | · | · | ✓ |
| `kol-apps/kol-client-canalix` | ✓ | · | · | ✓ |
| `kol-apps/kol-client-canalix-contract` | ✓ | ✓ | · | ✓ |
| `kol-apps/kol-client-kolkrabbi` | ✓ | · | · | ✓ |
| `kol-apps/kol-docs` | · | · | · | ✓ |
| `kol-apps/kol-docs-md` | ✓ | · | · | ✓ |
| `kol-apps/kol-docs-noter` | ✓ | · | · | ✓ |
| `kol-apps/kol-draw-3d` | ✓ | · | · | ✓ |
| `kol-apps/kol-editor-radar` | ✓ | · | · | ✓ |
| `kol-apps/kol-labs-single` | ✓ | · | · | ✓ |
| `kol-apps/kol-lightroom` | ✓ | · | · | ✓ |
| `kol-apps/kol-mirror` | ✓ | · | · | ✓ |
| `kol-apps/kol-modulator` | ✓ | · | · | ✓ |
| `kol-apps/kol-monitor` | ✓ | · | · | ✓ |
| `kol-apps/kol-radial` | ✓ | · | · | ✓ |
| `kol-apps/kol-svg-distress` | ✓ | · | · | ✓ |
| `kol-apps/kol-years` | ✓ | · | · | ✓ |
| `kol-chess` | ✓ | ✓ | ✓ | ✓ |
| `kol-ds-fxr` | ✓ | ✓ | · | ✓ |
| `kol-ds-ui` | ✓ | ✓ | ✓ | ✓ |
| `kol-dumpty/humpty` | ✓ | ✓ | · | · |
| `kol-dumpty/jabberwocky` | ✓ | ✓ | · | · |
| `kol-dumpty/memory-glass` | ✓ | ✓ | · | · |
| `kol-glass` | · | ✓ | · | · |
| `kol-vault` | · | · | · | · |
| `kol-website` | ✓ | ✓ | ✓ | ✓ |

<!-- /GENERATED -->
