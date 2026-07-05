---
title: Skills
type: reference
status: active
updated: 2026-07-05
description: What Claude Code skills are, how they're sourced from kol-system (ARCHITECTURE §4) vs local-authored, the whole-dir symlink mechanism, and the 30 installed skills grouped by job.
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

Canonical source is `~/dev/projects/kol-system/claude/skills/` + `.../_framework/`. Curated copies live here in `claude/skills/`. The `kol-docs-fm`/`-md`/`-lib` skills each read their own **`kol-docs-{fm,md,lib}`** package (`claude/packages/`) so they have no external dependency — the repo stays portable to a machine without kol-system. Re-pull with the `init-agent-context-sync` skill.

**Local-authored exceptions** (hand-written in dotfiles, so they *won't* ride a kol-system re-sync): `export-specs`, `kol-lobby`, `kol-bucket-r2`, `kol-bucket-b2` (the last renamed from the old `kol-bucket`), `kol-press-research`, `kol-docs-fm`/`-md`/`-lib` (forked from upstream `kol-docs`), `kol-migrate-structure`, `kol-type-conform`, `claude-clear`, `claude-bullet`, `init-scaffold` (headless base). Fine for personal-workflow skills; move canonical copies upstream if they ever need sharing.

> **Divergence note:** the former upstream `init-scaffold` (KOL-wired) now lives here as `init-scaffold-kol`, and the plain `init-scaffold` name is the local headless base. A kol-system re-sync still ships an upstream `init-scaffold` — reconcile it into `init-scaffold-kol`, don't let it clobber the headless base.

> **Divergence note:** the upstream single `kol-docs` skill was split locally into a russian-doll trio — `kol-docs-fm` (frontmatter) ⊂ `kol-docs-md` (one whole doc) ⊂ `kol-docs-lib` (whole repo docs library) — each reading its own `kol-docs-{fm,md,lib}` package (the old `kol-docs-framework` was split into them and retired). A kol-system re-sync still ships a single `kol-docs`; reconcile it into `kol-docs-md`, don't let it re-add the old name.

## Symlink mechanism

`bootstrap.sh` does `ln -sfn claude/skills ~/.claude/skills` — a **whole-directory** symlink. So a new skill subdir is live the moment its files exist; **no `bootstrap.sh` edit needed**. Same for `agents/`, `hooks/`, `commands/`, `output-styles/`.

Skill *dependencies* (CLI helpers a skill shells out to) live in `claude/packages/` and are copied to `~/.local/bin` by bootstrap.

## The installed set (30)

| Group | Skills |
|---|---|
| **Agent-context** (8) | `init-agent-context` · `init-agent-context-sync` · `init-agent` · `init-scaffold` · `init-scaffold-kol` · `log-work` · `log-work-handoff` · `kol-migrate-structure` — scaffold, sync, load, log, and converge repos onto the [protocol](01-agent-context-protocol.md) (`.kol/` layout). `init-scaffold` is the **headless** base (Vite + React + Tailwind 4, no design system); `init-scaffold-kol` is the same stack wired to the published `@kolkrabbi/kol-*` npm packages (AppShell/SideNav + the 4-point contract). `log-work` writes the retrospective session log (no prompts); `log-work-handoff` writes the forward-looking session-bridge handoff — split so `/log-work` never stops to ask |
| **Docs** (3) | `kol-docs-fm` (frontmatter only) ⊂ `kol-docs-md` (one whole doc — 9 archetypes, folder law) ⊂ `kol-docs-lib` (whole repo docs library — the `documentation/` vs machinery split, `.obsidian`, numbering). Each reads its own `kol-docs-{fm,md,lib}` package |
| **Buckets** (2) | `kol-bucket-b2` (Backblaze CDN) · `kol-bucket-r2` (Cloudflare R2 / kol-media) |
| **Design system / brand** (3) | `kol-lobby` — stage a component into the DS lobby as a spec · `kol-press-research` — press/mention/timeline research emitting brand-manifest entries (judgment half of the `kol-scrape` CLI) · `kol-type-conform` — enforce the KOL type protocol (JetBrains mono, the wrap/no-wrap line-height fault line) on ported or authored code |
| **Media / art** (4) | `glif-art` · `algorithmic-art` · `export-specs` · `vcap-capture` |
| **GSAP animation** (8) | `gsap-core` · `-frameworks` · `-performance` · `-plugins` · `-react` · `-scrolltrigger` · `-timeline` · `-utils` |
| **Utility** (2) | `claude-clear` (restate the last reply, tighter) · `claude-bullet` (reformat the last reply into bullets/lists/checks) |

## Adding a skill

Create `claude/skills/<name>/SKILL.md` with `name` + `description` frontmatter. It's live immediately (whole-dir symlink). Local-authored skills should note in their session log that they won't ride the kol-system re-sync.

## Related
- [Subagents](03-agents.md) — the other capability layer (separate context windows, invoked via the Task tool).
- [Hooks & tools](04-hooks-and-tools.md) — the wiring (statusline, plugins, MCP) around the skills.
