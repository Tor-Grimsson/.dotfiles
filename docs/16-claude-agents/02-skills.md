---
title: Skills
type: reference
status: active
updated: 2026-07-03
description: What Claude Code skills are, how they're sourced from kol-system (ARCHITECTURE §4) vs local-authored, the whole-dir symlink mechanism, and the 22 installed skills grouped by job.
aliases:
  - skills
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[01-agent-context-protocol|agent-context protocol]]"
  - "[[03-agents|subagents]]"
  - "[[16-claude-agents/INDEX|Claude & Agents]]"
---

# Skills

A **skill** is a bundle of instructions (a `SKILL.md` + optional assets) that Claude Code loads on demand — invoked with `/<name>` or auto-triggered by its `description`. They live in `claude/skills/<name>/` and are symlinked into `~/.claude/skills/`.

## Sourcing (ARCHITECTURE §4)

Canonical source is `~/dev/projects/kol-system/claude/skills/` + `.../_framework/`. Curated copies live here in `claude/skills/`. The `kol-docs` skill **bundles** `_framework/` so it has no external dependency — the repo stays portable to a machine without kol-system. Re-pull with the `init-agent-context-sync` skill.

**Local-authored exceptions** (hand-written in dotfiles, so they *won't* ride a kol-system re-sync): `export-specs`, `kol-lobby`, `kol-bucket-r2`, `kol-bucket-b2` (the last renamed from the old `kol-bucket`). Fine for personal-workflow skills; move canonical copies upstream if they ever need sharing.

## Symlink mechanism

`bootstrap.sh` does `ln -sfn claude/skills ~/.claude/skills` — a **whole-directory** symlink. So a new skill subdir is live the moment its files exist; **no `bootstrap.sh` edit needed**. Same for `agents/`, `hooks/`, `commands/`, `output-styles/`.

Skill *dependencies* (CLI helpers a skill shells out to) live in `claude/packages/` and are copied to `~/.local/bin` by bootstrap.

## The installed set (22)

| Group | Skills |
|---|---|
| **Agent-context** (5) | `init-agent-context` · `init-agent-context-sync` · `init-docs` · `init-scaffold` · `log-work` — boot, sync, load, scaffold, and log the [[01-agent-context-protocol\|protocol]] |
| **Docs** (1) | `kol-docs` — the kol-docs framework spec (frontmatter, 9 archetypes, tags, wikilinks) |
| **Buckets** (2) | `kol-bucket-b2` (Backblaze CDN) · `kol-bucket-r2` (Cloudflare R2 / kol-media) |
| **Design system** (1) | `kol-lobby` — stage a component into the DS lobby as a spec |
| **Media / art** (4) | `glif-art` · `algorithmic-art` · `export-specs` · `vcap-capture` |
| **GSAP animation** (8) | `gsap-core` · `-frameworks` · `-performance` · `-plugins` · `-react` · `-scrolltrigger` · `-timeline` · `-utils` |
| **Utility** (1) | `claude-clear` |

## Adding a skill

Create `claude/skills/<name>/SKILL.md` with `name` + `description` frontmatter. It's live immediately (whole-dir symlink). Local-authored skills should note in their session log that they won't ride the kol-system re-sync.

## Related
- [[03-agents|Subagents]] — the other capability layer (separate context windows, invoked via the Task tool).
- [[04-hooks-and-tools|Hooks & tools]] — the wiring (statusline, plugins, MCP) around the skills.
