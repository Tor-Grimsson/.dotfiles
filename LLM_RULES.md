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
6. **STOP** and say "Context loaded — on the **\<iMac|MBP\>**. What would you like me to work on?" (name the machine from step 1)
7. **WAIT** for the user to specify their task

**DO NOT:**
- Skip reading the context files
- Start working before the user specifies a task
- Propose anything that contradicts `ARCHITECTURE.md` without flagging the contradiction first

**IF THE USER ASKS "Do you understand?" or "Outline the task?":**
Respond with a clear plan of what you'll do BEFORE taking any action.

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
│   └── llm-context/                 agent-context protocol (hidden at repo root)
│       ├── README.md
│       ├── ARCHITECTURE.md          load-bearing decisions
│       ├── AGENT-CONTEXT.md         current state, open items, gotchas, contracts
│       ├── history.md               decision history — the "why"
│       ├── plan.md                  future exploration
│       ├── session-log/
│       └── session-bridge/
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

- **Protocol files UPPERCASE:** `LLM_RULES.md`, `ARCHITECTURE.md`, `AGENT-CONTEXT.md`, `README.md`, `SKILL.md`.
- **Content files kebab-case:** `history.md`, `plan.md`, session logs.

### Non-goals

- **Never run provisioning** — no `brew bundle`/`install`/`upgrade`, no `bootstrap.sh`. Prepare changes, the user runs them.
- **No hardcoded brew prefixes** — Intel = `/usr/local`, Apple-Silicon = `/opt/homebrew`.
- **Secrets never as literals in tracked files** — env-var refs only, sourced from Bitwarden.

### Git Workflow

- **Never run git** — the user owns all git operations
- Leave the working tree ready for the user's commit
