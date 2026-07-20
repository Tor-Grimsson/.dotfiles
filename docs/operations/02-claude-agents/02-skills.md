---
title: Skills
type: reference
status: active
updated: 2026-07-09
description: What Claude Code skills are, how they're sourced from kol-system (ARCHITECTURE §4) vs local-authored, the whole-dir symlink mechanism, and the 39 installed skills grouped by job.
aliases:
  - skills
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[01-agent-context-protocol|agent-context protocol]]"
  - "[[03-agents|subagents]]"
  - "[[operations/02-claude-agents/INDEX|Claude & Agents]]"
---

# Skills

A **skill** is a bundle of instructions (a `SKILL.md` + optional assets) that Claude Code loads on demand — invoked with `/<name>` or auto-triggered by its `description`. They live in `claude/skills/<name>/` and are symlinked into `~/.claude/skills/`.

## Sourcing (ARCHITECTURE §4)

Canonical source is `~/dev/projects/kol-system/claude/skills/` + `.../_framework/`. Curated copies live here in `claude/skills/`. The `kol-docs-fm`/`-md` skills (+ the `scaffold-docs-system` skill, which absorbed the old `kol-docs-lib`) each read their own **`kol-docs-{fm,md,lib}`** package (`claude/packages/`) so they have no external dependency — the repo stays portable to a machine without kol-system.

**No automated re-sync skill exists** (`init-agent-context-sync` was quarantined 2026-07-05 — zero real-world use found across 6+ repos; talking through an update and hand-editing the target repo proved simpler than the automated path). Re-pulling from kol-system, or pushing a template/framework change out to an already-scaffolded repo, is a manual/conversational step now.

**Local-authored exceptions** (hand-written in dotfiles, so they *won't* ride a kol-system re-sync): `export-specs`, `kol-lobby`, `kol-lobby-icon`, `kol-bucket-r2`, `kol-bucket-b2` (the last renamed from the old `kol-bucket`), `kol-cdn-overview`, `kol-docs-overview`, `kol-press-research`, `kol-docs-fm`/`-md` + `scaffold-docs-system` (forked from upstream `kol-docs`), `kol-type-conform`, `claude-clear`, `claude-bullet`, `keys-add`, `claude-npm`, `claude-kol-ds`, `log-work-playbook`, `log-work-milestone`, `kol-appliant`, `kol-goal`, `scaffold-dev-stack` (headless base). Fine for personal-workflow skills; move canonical copies upstream if they ever need sharing. (The former `agent-output-format` / `agent-reinforce-rules` / `agent-reinforce-memory` / `agent-reinforce` skills became the global `agent-reinforce` UserPromptSubmit hook, 2026-07-08.)

> **Divergence note:** the former upstream `init-scaffold` (KOL-wired) now lives here as `scaffold-dev-stack-kol`, and the plain-base skill is `scaffold-dev-stack`. A kol-system re-sync still ships an upstream `init-scaffold` — reconcile it into `scaffold-dev-stack-kol`, don't let it clobber the headless base or reintroduce the old name.

> **Divergence note:** the upstream single `kol-docs` skill was split locally into a russian-doll trio — `kol-docs-fm` (frontmatter) ⊂ `kol-docs-md` (one whole doc) ⊂ `scaffold-docs-system` (whole repo docs system, formerly `kol-docs-lib`) — each reading its own `kol-docs-{fm,md,lib}` package (the old `kol-docs-framework` was split into them and retired). A kol-system re-sync still ships a single `kol-docs`; reconcile it into `kol-docs-md`, don't let it re-add the old name.

## Symlink mechanism

`bootstrap.sh` does `ln -sfn claude/skills ~/.claude/skills` — a **whole-directory** symlink. So a new skill subdir is live the moment its files exist; **no `bootstrap.sh` edit needed**. Same for `agents/`, `hooks/`, `commands/`, `output-styles/`.

Skill *dependencies* (CLI helpers a skill shells out to) live in `claude/packages/` and are copied to `~/.local/bin` by bootstrap.

## The installed set (42)

**2026-07-05 rename/restructure:** the naming logic switched from an accidental `init-`/`kol-` prefix to grouping by *what gets scaffolded* — `scaffold-*` for building fresh, plain skill-specific names otherwise. `init-agent-context-sync` and `kol-migrate-structure` were quarantined to `_tmp/` (repo root) rather than renamed — no real-world use found for either, and `migrate-structure` had zero supporting evidence either way once asked directly. **`kol-migrate-structure` was restored the same day** — promoted back out of `_tmp/` into `claude/skills/`. `init-agent-context-sync` remains quarantined (nothing under `_tmp/` is tracked, `.gitignore`'d).

| Group | Skills |
|---|---|
| **Agent-context & reinforcement** (10) | `agent-init` (renamed from `init-agent` 2026-07-05) · `log-work` · `log-work-handoff` · `log-work-playbook` (append a live work-journal entry to `.kol/llm-context/playbook/` — terse, real-timestamped, append-only; the mid-work sibling of `log-work`) · `log-work-milestone` (capstone log that closes a process/arc — resolves/parks open threads instead of listing them; the closure sibling of `log-work`) · `scaffold-llm-context` (was `init-agent-context` — now *only* `.kol/llm-context/` + the `LLM_RULES.md` symlink) · `scaffold-docs-system` (was `kol-docs-lib` — now also owns `.kol/docs-framework/` scaffolding, absorbed from the old `init-agent-context`) · `scaffold-dev-stack` · `scaffold-dev-stack-kol` · `kol-migrate-structure` (converge a legacy `docs/llm-context`/`.claude/llm-context`/`.llm-context` layout onto `.kol/` — an **orchestrator**: relocates old content, then delegates the boot symlink to `scaffold-llm-context` + framework/docs to `scaffold-docs-system`, 2026-07-08; no longer reimplements them). **Reinforcement is no longer a skill** — report shape + standing rules + no-git now inject via the global `agent-reinforce` **UserPromptSubmit hook** (`claude/hooks/agent-reinforce.sh`, 2026-07-08; full on turn 1, compact every ~5 turns), which re-grounds mid-session where the old 4-skill bundle couldn't |
| **Docs** (3) | `kol-docs-fm` (frontmatter only) ⊂ `kol-docs-md` (one whole doc — 9 archetypes, folder law) ⊂ `scaffold-docs-system` (above — whole repo docs system). Each reads its own `kol-docs-{fm,md,lib}` package. `kol-docs-overview` — orientation-only front door: the **whole** repo structure in one read — `.kol/` (llm-context agent state + the symlinked `LLM_RULES` boot file), the `docs/` vault (subject + operations), the `.obsidian` model, what's seeded from dotfiles, and **who-owns-what** across the scaffolders (broadened from docs-only 2026-07-08), no authoring |
| **Buckets** (3) | `kol-bucket-b2` (Backblaze CDN) · `kol-bucket-r2` (Cloudflare R2 / kol-media) — both action (ls/tree/upload/sync/rm). `kol-cdn-overview` — orientation-only sibling: where things live, no commands |
| **Design system / brand** (5) | `kol-lobby` — stage a component into the DS lobby as a spec · `kol-lobby-icon` — promote a repo's icon UP into kol-icon-set: clean (currentColor, strip export junk, normalise name), check (stroke-weight, keyline, false/expanded stroke, name collision), drop into the set. The icon-SVG sibling of `kol-lobby` — emits the cleaned SVG, not a spec, since an icon needs no re-authoring · `kol-press-research` — press/mention/timeline research emitting brand-manifest entries (judgment half of the `kol-scrape` CLI) · `kol-type-conform` — enforce the KOL type protocol (JetBrains mono, the wrap/no-wrap line-height fault line) on ported or authored code · `claude-kol-ds` — mandatory orientation gate: read EVERY theme+framework CSS file (the `kol-theme.css` `@import` cascade) + foundations docs and produce a design-system overview *before* any edit/answer in kol-design-system |
| **Media / art** (4) | `glif-art` · `algorithmic-art` · `export-specs` · `vcap-capture` |
| **GSAP animation** (8) | `gsap-core` · `-frameworks` · `-performance` · `-plugins` · `-react` · `-scrolltrigger` · `-timeline` · `-utils` |
| **Utility** (6) | `claude-clear` (restate the last reply, tighter) · `claude-bullet` (reformat the last reply into bullets/lists/checks) · `keys-add` (maintain the `keys` keybind reference — add/fix an entry in `keys/keybinds.md` the right way) · `claude-npm` (check a JS project's deps for updates — detect the PM, run `outdated`, report current→wanted→latest; read-only) · `kol-appliant` (bring a tool up to / audit it against the kol-appliant doc standard — the 5-point contract + DoD; enforces `03-kol-docs-system-setup/01-kol-appliant-tool-standard`) · `kol-goal` (the "ralph loop" — `/kol-goal <x>` sets a goal the `goal-loop` Stop hook won't let you stop on until `/kol-goal done`; cap-backstopped) |

Count check: 12 + 3 + 3 + 5 + 4 + 8 + 4 = 39.

## Adding a skill

Create `claude/skills/<name>/SKILL.md` with `name` + `description` frontmatter. It's live immediately (whole-dir symlink). Local-authored skills should note in their session log that they won't ride the kol-system re-sync.

## Related
- [[03-agents|Subagents]] — the other capability layer (separate context windows, invoked via the Task tool).
- [[04-hooks-and-tools|Hooks & tools]] — the wiring (statusline, plugins, MCP) around the skills.
