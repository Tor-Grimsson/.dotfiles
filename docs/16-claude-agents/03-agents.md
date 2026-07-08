---
title: Subagents
type: reference
status: active
updated: 2026-07-03
description: The 4 kol-* design-system subagents in claude/agents/ — color, layout, docs, typography specialists for the kolkrabbi monorepo — how they're defined and invoked.
aliases:
  - subagents
  - agents
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[02-skills|skills]]"
  - "[[16-claude-agents/INDEX|Claude & Agents]]"
---

# Subagents

A **subagent** is an agent type the main agent can delegate to via the Task tool — it runs in its **own context window** with its own tools, returns a result, and doesn't pollute the main thread. Repo-defined ones live in `claude/agents/<name>.md` (symlinked to `~/.claude/agents/`); the harness also ships built-ins (`general-purpose`, `Explore`, `Plan`) that aren't repo-tracked.

## Definition shape

A `.md` file with frontmatter:

| Field | Purpose |
|---|---|
| `name` | invocation id (e.g. `kol-color-agent`) |
| `description` | when to delegate to it (drives auto-selection) |
| `tools` | optional tool allowlist (default: inherit) |
| `model` | optional model override |

Body = the subagent's system prompt (specialization, mode, rules). Whole-dir symlink → a new agent file is live without a `bootstrap.sh` edit.

## The 4 kol-* agents

All four are **kolkrabbi design-system specialists** — scoped to the kolkrabbi monorepo, Analysis + Implementation (Read & Write):

| Agent | Specialization |
|---|---|
| `kol-color-agent` | Tailwind CSS, color-system architecture, design tokens (palette / theme work) |
| `kol-div-agent` | page structure, layout architecture, responsive patterns (structural components) |
| `kol-docs-agent` | the design system's numbered docs, kept in sync with the codebase |
| `kol-type-agent` | typography — type scales, font stacks, typography CSS from tokens to components |

## Invoking

The main agent delegates via the Task tool (`subagent_type: kol-color-agent`), or the harness auto-selects by `description` when a task matches. Launch several in one message to run them concurrently.

## Skills vs subagents

- **[[02-skills|Skill]]** = instructions loaded into the *current* context. Cheap, inline, no separate window.
- **Subagent** = a *separate* context window for scoped, parallelizable, or context-heavy work. Use when you want isolation or fan-out.
