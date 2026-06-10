---
name: init-agent
description: Load project context for a new session
disable-model-invocation: true
allowed-tools: Read, Glob, Bash
_template:
  version: 2
  path: .claude/skills/init-agent/SKILL.md
  sync: replace
---

# Agent Initialization

Follow these steps exactly:

1. Run `uname -m` to identify the machine: `arm64` = Apple-Silicon **MBP** (`/opt/homebrew`), `x86_64` = Intel **iMac** (`/usr/local`). Never ask the user which machine they're on — detect it.
2. Read `~/.dotfiles/docs/llm-context/ARCHITECTURE.md` — load-bearing decisions and constraints
3. Read `~/.dotfiles/docs/llm-context/AGENT-CONTEXT.md` — current project state
4. Find the most recent session log in `~/.dotfiles/docs/llm-context/session-log/` (sort by date)
5. Read that session log
6. Check `~/.dotfiles/docs/llm-context/session-bridge/` for `handoff-*.md` files. If the newest handoff's timestamp is newer than the newest session log's timestamp, also read that handoff — it carries in-flight state. Otherwise skip. See `session-bridge/README.md` for the full protocol.
7. Say "Context loaded — on the **\<iMac|MBP\>**. What would you like me to work on?" (name the machine from step 1)
8. **STOP and WAIT** — do not start any work until the user specifies a task

If you find yourself proposing something that contradicts ARCHITECTURE.md, flag the contradiction to the user before acting. Those rules can be broken — but only deliberately.
