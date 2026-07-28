---
title: 01 · Init — how an agent boots
type: explainer
status: active
updated: 2026-07-28
description: The boot chain — bootstrap.sh symlinks ~/.claude from the dotfiles repo, LLM_RULES.md symlinks into every repo from the scaffold package, /ag-init loads ARCHITECTURE + AGENT-CONTEXT + latest log and detects the machine. Multi-machine and multi-repo by construction.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[02-context|02 — context]]"
---

# 01 · Init — how an agent boots

Two symlink chains make every repo and every machine boot identically: git is the single source of truth, iCloud is never config.

```
BOOT CHAIN

  dotfiles repo (git)                          any repo
  ├── bootstrap.sh ──symlinks──▶ ~/.claude/*   ├── LLM_RULES.md ──▶ dotfiles claude/packages/
  │   (CLAUDE.md · settings · skills ·         │      scaffold/03-scaffold-llm-context/LLM_RULES.md
  │    hooks · agents · packages)              └── .kol/llm-context/  ← what /ag-init reads
  │
  └── same repo on both machines (Intel /usr/local · ARM /opt/homebrew)
      → no hardcoded brew prefixes, ever
```

## The `/ag-init` sequence

1. Locate the context dir — `.kol/llm-context/` (current), three legacy locations checked in order.
2. `uname -m` → name the machine (arm64 = MBP, x86_64 = iMac). Detect, never ask.
3. Read `ARCHITECTURE.md` (load-bearing decisions) → `AGENT-CONTEXT.md` (current state) → newest session log.
4. Check `session-bridge/` for a handoff newer than the newest log — read it if so.
5. Package-update check (guarded), then report and **stop — wait for a task**.

## Files & skills

| Piece | Path | Role |
|---|---|---|
| `bootstrap.sh` | dotfiles root | Installs + symlinks everything; recreates all links on a new machine |
| `LLM_RULES.md` | every repo root (symlink) | The boot file an agent hits first; source lives in `claude/packages/scaffold/` |
| `ag-init` skill | `claude/skills/ag-init` | The init sequence above (alias: `agent-init`) |
| `scaffold-llm-context` skill | `claude/skills/` | Scaffolds `.kol/llm-context/` + boot symlink into a new repo |
| `kol-migrate-structure` skill | `claude/skills/` | Converges legacy layouts onto `.kol/` |

## Export notes

- Alice-bag candidate (motion): boot/init. Working title until assigned.
- Scrub: bootstrap.sh carries repo-specific link lists — export as pattern + example, not verbatim.
- The multi-machine section (two arches, one repo, no prefixes) ships here — it's the init module's portability story.
