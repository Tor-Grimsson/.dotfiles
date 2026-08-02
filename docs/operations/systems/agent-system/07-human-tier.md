---
title: 07 · Human tier — docs/ as the equal surface
type: explainer
status: active
updated: 2026-07-28
description: The audience split that runs the whole system — .kol/ is agent context, docs/ is human context, equal citizens. The docs/ vault anatomy (documentation = the repo's subject vs operations = the repo's machinery, plus named siblings), and the .obsidian layer that makes it a real reading environment.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[06-docs-framework|06 — docs framework]]"
  - "[[09-routing|09 — routing]]"
---

# 07 · Human tier — docs/ as the equal surface

The system's audience law: **`.kol/` is for agents, `docs/` is for the human** — and the human surface is in no way less important. Study output, references, anything the user reads lands in `docs/`, never in agent state.

```
  <repo>/
  ├── .kol/               AGENT reads this   (context · memory · plans)
  └── docs/               HUMAN reads this   (the Obsidian vault)
      ├── INDEX.md            router
      ├── documentation/      the repo's SUBJECT — what the repo is about
      │                       (concept docs, tool catalog, guides)
      ├── operations/         the repo's MACHINERY — how the repo runs
      │                       (pipelines, workbench, packages, external deps)
      ├── <named siblings>/   boundary sets with their own names
      └── .obsidian/          seeded config — theme, graph, search defaults
```

## The two-axis split

| Axis | documentation/ | operations/ |
|---|---|---|
| Question | *What is this repo about?* | *How does this repo work?* |
| Examples | tool references, concept guides, design surveys | build pipeline, npm packages, deploy, CDN wiring |
| Fails when | machinery notes pollute subject docs | subject knowledge hides in ops files |

Named **siblings** hold what's neither purely subject nor machinery (cheat cards, script docs, initiatives, design spaces like this one).

## The .obsidian layer

- Seeded per repo by the scaffold so every vault opens with the same theme/behavior; machine-local, gitignored where it's regenerable.
- The glass lens ([[09-routing|09]]) makes all repo vaults one meta-vault — search, graph, backlinks across everything.

## Export notes

- Ships as: this split as a spec + the scaffold that stamps it + a seeded `.obsidian` starter.
- The pitch for strangers: most agent setups have no human tier at all — the operator reads raw state files. This module is the differentiator.
- Scrub: `.obsidian` seed carries no personal data; verify workspace files excluded.
