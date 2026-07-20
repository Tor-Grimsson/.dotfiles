---
_template:
  version: 1
  path: LLM_RULES.md
  sync: notify-only
---

# LLM Rules for dotfiles

---

## ⚠️ CRITICAL STARTUP PROTOCOL - READ THIS FIRST ⚠️

**WHEN THE USER SAYS "read `LLM_RULES.md`" YOU MUST:**

1. **DETECT THE MACHINE** — run `uname -m`: `arm64` = Apple-Silicon **MBP** (`/opt/homebrew`), `x86_64` = Intel **iMac** (`/usr/local`). Never ask the user which machine they're on.
2. **READ** `.kol/llm-context/ARCHITECTURE.md` — load-bearing decisions and constraints
3. **READ** `.kol/llm-context/AGENT-CONTEXT.md` — current project state
4. **READ** the latest session log from `.kol/llm-context/session-log/` (sort by date, most recent first)
5. **CHECK** `.kol/llm-context/session-bridge/` for `handoff-*.md` files. If the newest handoff has a timestamp newer than the newest session log, **also READ that handoff** — it carries in-flight state the session log doesn't. Otherwise skip. See `.kol/llm-context/session-bridge/README.md` for the full protocol.
6. **Reinforcement is automatic** — the global `agent-reinforce` UserPromptSubmit hook injects report-shape + standing-rules + no-git + ports reinforcement on a cadence (full on turn 1, compact every ~5 turns). Nothing to load; it re-grounds mid-session, which the old skill bundle couldn't.
7. **STOP** and say "Context loaded — on the **\<iMac|MBP\>**. What would you like me to work on?" (name the machine from step 1)
8. **WAIT** for the user to specify their task

**DO NOT:**
- Skip reading the context files
- Start working before the user specifies a task
- Propose anything that contradicts `ARCHITECTURE.md` without flagging the contradiction first

**IF THE USER ASKS "Do you understand?" or "Outline the task?":**
Respond with a clear plan of what you'll do BEFORE taking any action.

---

## 🔔 Protocol update — 2026-07-11

The documentation + llm-context protocol has been **unified** across the kol-system repos (most sync repos have upgraded). Two layout changes landed here:

- **Plans moved to their own peer folder** `.kol/llm-plan/` — one `NN-slug.md` per plan (`01-parking-lot.md` is the backlog). No longer a single `llm-context/plan.md`.
- **`history.md` → `HISTORY.md`** — uppercase marks it a system/protocol file, alongside `ARCHITECTURE.md` / `AGENT-CONTEXT.md`.

The driving skills and protocol docs (`kol-docs-*`, `kol-migrate-structure`, `scaffold-*`, `docs/operations/02-claude-agents/`) reflect the unified shape.

---

# LLM Agent Onboarding

Welcome to **dotfiles** — macOS configuration + tooling catalog for two machines (Intel iMac + Apple-Silicon MBP).

## Quick Start

1. **Read this file** to understand the project structure
2. **Read** `.kol/llm-context/ARCHITECTURE.md` for load-bearing decisions
3. **Read** `.kol/llm-context/AGENT-CONTEXT.md` for current project state
4. **Check** `.kol/llm-context/session-log/` for the most recent session log
5. **Follow** the conventions and guidelines below

## Project Overview

Shell/git/ssh/editor configs, a reconciled `brewfile-cli` + `brewfile-gui`, a per-tool docs catalog under `docs/`, and the repo-backed `~/.claude` config (symlinked from `claude/` by `bootstrap.sh`).

### Tech Stack

- zsh (+ oh-my-zsh / p10k)
- Homebrew via `brewfile-cli` (CLI/TUI formulas) + `brewfile-gui` (casks + VS Code extensions)
- bash scripts (`bootstrap.sh`, `bin/`, `scripts/`)
- symlink-based install — no framework, no manager

## Directory Structure

```
dotfiles/
├── brewfile-cli                       CLI/TUI formulas — safe to run standalone on a foreign box
├── brewfile-gui                       GUI casks + VS Code extensions — daily-driver machines only
├── bootstrap.sh                     installer: brew bundle + symlinks + macos/defaults.sh
├── TOOLING.md                       tooling audit: drift, portability, open items
├── claude/                          repo-backed ~/.claude (CLAUDE.md, settings, skills, agents, packages)
├── meta/                            secrets/setup docs
├── macos/                           defaults baseline
├── shell/ git/ ssh/ iterm/ vscode/ mpv/ nvim/ bin/ scripts/
├── .kol/
│   ├── llm-context/                 agent-context protocol (hidden at repo root)
│   │   ├── README.md
│   │   ├── ARCHITECTURE.md          load-bearing decisions
│   │   ├── AGENT-CONTEXT.md         current state, open items, gotchas, contracts
│   │   ├── HISTORY.md               decision history — the "why"
│   │   ├── session-log/
│   │   └── session-bridge/
│   └── llm-plan/                    speculative plans — one NN-slug.md per plan
├── docs/
│   └── INDEX.md + 01-…17-…/         per-tool reference catalog (kol-docs)
└── LLM_RULES.md                     this file
```

## LLM Context Protocol

This project uses **session logs** to maintain context across agents and sessions.

### Reading Context

**Always read the latest session log** in `.kol/llm-context/session-log/` before starting work. Session logs are named:
- `YYYY-MM-DD-brief-description.md`

Sort by date to find the most recent.

### Writing Context

When you complete significant work:
1. Create a new session log in `.kol/llm-context/session-log/`
2. Use the format: `YYYY-MM-DD-brief-description.md`
3. Include: session metadata, changes made, current state, next steps
4. Update `AGENT-CONTEXT.md` if the project's current state changed

Or use the `/log-work` skill to automate this.

## Working Conventions

### Code Style

- **No over-engineering** — Make only requested changes
- **Remove unused code** — Delete completely, no backwards-compat hacks
- **Edit over create** — Prefer modifying existing files
- **Use existing patterns** — Follow established naming and structure
- **Apply exact values** — When user specifies a concrete number, use it

### Filename Conventions

- **Protocol/system files UPPERCASE:** `LLM_RULES.md`, `ARCHITECTURE.md`, `AGENT-CONTEXT.md`, `HISTORY.md`, `README.md`, `SKILL.md`.
- **Content files kebab-case:** plans (`llm-plan/NN-slug.md`), session logs.

### Link Form

- **This file and `TOOLING.md` are root, GitHub-facing — standard markdown links (`[text](path.md)`), never wikilinks.** `docs/**` is the Obsidian vault — wikilinks there, including heading anchors (literal heading text, never a GitHub kebab-slug — Obsidian doesn't resolve those). Full rule: `claude/packages/kol-docs/kol-docs-lib/01-structure.md`.

### Non-goals

- **Never run provisioning** — no `brew bundle`/`install`/`upgrade`, no `bootstrap.sh`. Prepare changes, the user runs them.
- **Never open ports/servers for the user** — task-scoped ports only (playwright, test harnesses), closed surgically (own PID only) when the task ends. The user runs his own servers; hand him the command.
- **No hardcoded brew prefixes** — Intel = `/usr/local`, Apple-Silicon = `/opt/homebrew`.
- **Secrets never as literals in tracked files** — env-var refs only, sourced from Bitwarden.

### Git Workflow

- **Never run git** — the user owns all git operations
- Leave the working tree ready for the user's commit
