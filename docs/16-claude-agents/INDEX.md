---
title: Claude & Agents
type: index
status: active
updated: 2026-07-05
description: The repo's own Claude Code / agent layer — the agent-context protocol, skills, subagents, hooks, and MCP tools. Distinct from the numbered tool catalog; this documents how `~/.claude` (repo-backed per ARCHITECTURE §3) is wired.
tags:
  - project/dotfiles
  - domain/ai/llm
---

# Claude & Agents

Everything under `claude/` is the **agent layer** of this repo — the Claude Code config that `bootstrap.sh` symlinks into `~/.claude/`. Per `ARCHITECTURE.md` §3, **git is the source of truth** for it (not iCloud); editing `~/.claude/<x>` edits the repo. Per §4, skills are sourced from kol-system and bundled self-contained.

This section explains that layer. It is **not** part of the tool catalog (the other numbered categories document installed CLI tools + the supabase/cloudflare guides) — it documents the repo's own AI tooling.

## What's in `claude/`

| Path | Holds |
|---|---|
| `CLAUDE.md` | global personality + working rules ("Grim") |
| `settings.json` | permissions, statusline, plugins, voice/effort/tui |
| `skills/` | 35 Claude Code skills (whole-dir symlink) |
| `agents/` | 4 `kol-*` subagents |
| `hooks/` | `statusline.sh` (the only hook) |
| `commands/`, `output-styles/` | present but empty |
| `packages/` | skill dependencies → `~/.local/bin` |

## Docs

| # | Doc | Covers |
|---|-----|--------|
| 01 | [[01-agent-context-protocol|Agent-context protocol]] | how a session loads project state + logs work — `LLM_RULES.md`, `.kol/llm-context/`, the `scaffold-*`/`agent-init`/`log-work` skills, the AGENT-CONTEXT chain |
| 02 | [[02-skills|Skills]] | what skills are, kol-system sourcing (§4) vs local-authored, the symlink mechanism, the installed set |
| 03 | [[03-agents|Subagents]] | the 4 `kol-*` design-system subagents + how they're defined and invoked |
| 04 | [[04-hooks-and-tools|Hooks & tools]] | the statusline hook, `settings.json` config, plugins (ponytail/rust-analyzer), and MCP tools (playwright/glif) |
| 05 | [[05-working-rules|Working rules]] | the `CLAUDE.md` "Grim" rule-sections (Tone / Answering / Report shape / …) — section map + change log |
| 06 | [[06-claude|Grim — the persona]] | the character `CLAUDE.md` casts — name, personality, how he works, how his output reads |
| 07 | [[07-output-formats|Output formats]] | the reply skeleton + a gallery of named worked layouts (one-liner / build report / findings / recommendation / staged) — the visual reference for the Report-shape rules |

## Related
- [[13-ponytail|ponytail]] — the Claude Code plugin catalogued under Dev & Languages (the laziness layer, always-on via a SessionStart hook).
