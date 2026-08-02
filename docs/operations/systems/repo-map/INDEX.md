---
title: Repo map — the estate and how it wires together
type: index
status: active
updated: 2026-07-30
description: What every repo IS and how they connect — the ASCII wiring diagram (package publisher → consumers, the agent tier, the lens), the family structure, and the drift check that catches a new repo the map hasn't heard of.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[operations/systems/INDEX|systems/]]"
  - "[[01-repos|the repo table]]"
  - "[[operations/systems/claude-memory/03-kol-glass-vault|kol-glass, the lens]]"
---

# Repo map

**29 repos** under `~/dev/projects`, in **6 top-level repos + 2 families**. This doc is the wiring; [[01-repos|01-repos]] is the per-repo table (what each one is, hand-kept + generated columns).

## The estate

```
~/dev/projects/
│
├── kol-ds-ui ......... THE PACKAGE SOURCE — 15 packages under @kolkrabbi/*
├── kol-website ....... the public site (apps/web) — biggest consumer
├── kol-chess ......... chess app + its own published package
├── kol-ds-fxr ........ editor.kolkrabbi.io — fx/editor surface
├── kol-vault ......... personal Obsidian vault (markdown, not code)
├── kol-glass ......... THE LENS — owns nothing, symlinks everything
│
├── kol-apps/ ......... FAMILY, 20 repos — clients, experiments, one-offs
│   └── kol-client-* · kol-editor-radar · kol-monitor · kol-mirror · …
│
├── kol-dumpty/ ....... FAMILY, 3 repos — the agent stack
│   ├── humpty ........ the muzzle: laws · 4-level dial · clamps · gates
│   ├── jabberwocky ... the agent OS: init · context · journal · memory · plans · docs
│   └── memory-glass .. the memory template (git-backed, symlinked)
│
└── (untracked, not repos) _kol-lobby · _kol-quick · kol-ds-type · kol-studio
```

## How the code wires

```
                    ┌────────────────────────────────┐
                    │  kol-ds-ui — 15 packages       │
                    │  @kolkrabbi/kol-{component,    │
                    │  framework, icons, theme, …}    │
                    └───────────────┬────────────────┘
                     publishes npm  │  dogfoods in-repo
        ┌──────────────┬────────────┼──────────────┬───────────────┐
        ▼              ▼            ▼              ▼               ▼
   kol-website     kol-chess    kol-ds-fxr    ds-ui/showcase  ds-ui/workbench
   apps/web        6 pkgs       4 pkgs        11 pkgs         5 pkgs
   10 pkgs         (+ publishes
                    kol-chess)

   kol-studio/app ──▶ @kolkrabbi/kol-media-client   (the odd one out)
```

Read it as: **one publisher, five consumers.** A package change in `kol-ds-ui` ripples to every arrow. `showcase/` and `workbench/` are in-repo consumers — the dogfood — which is why they break first and warn you cheapest.

## How the agent stack wires

```
  ~/.dotfiles ───symlink───▶ ~/.claude          kol-dumpty/  (family folder,
   ├── claude/  (config, hooks, skills)          │            NOT a repo)
   ├── docs/    (this vault)                     ├── humpty ......... muzzle
   ├── bin/     (the ref cards, scripts)         ├── jabberwocky .... agent OS
   └── .kol/    (agent state, not for humans)    └── memory-glass ... memory tmpl
          │                                              ▲
          │  memory: claude/memory/ = global tier         │ source of the
          ▼                                              │ patterns dotfiles
  kol-glass  ── repos/ ─▶ every repo's docs/       ──────┘ runs locally
  (the lens)  ── memory/ ─▶ every repo's .kol/llm-memory/ + the global tier
```

- **Complaints about muzzling / word-soup / gates → `kol-dumpty/humpty`.**
- Complaints about agent structure (init, context, journaling, plans) → `jabberwocky`.
- Memory *mechanism* → `memory-glass`; memory *content* → the repo it belongs to.
- kol-glass is never the place to fix anything — it's symlinks; edits write through.

## Drift

The estate changes faster than any hand-written list. `repo-map.sh` walks it read-only and reports what the map hasn't heard of — same pattern as [[operations/systems/cdn/INDEX|the CDN bucket snapshots]]: generated structure, hand-kept meaning, drift flagged rather than silently overwritten.

```sh
repo-map.sh            # print the live estate + flag drift against 01-repos.md
repo-map.sh --update   # refresh the generated block in 01-repos.md
```
