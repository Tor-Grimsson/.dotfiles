---
name: init-docs
description: Load the repo's agent context (ARCHITECTURE, AGENT-CONTEXT, latest session log) for a new session
disable-model-invocation: true
allowed-tools: Read, Glob, Bash
---

# Agent Initialization

Load the agent-context protocol for the current repo. Works in any repo that carries it.

## Locate the context directory

Check in order, use the first that exists:

1. `.claude/llm-context/` (vault-style, merged into the Claude dir)
2. `.llm-context/` (vault-style, at repo root)
3. `docs/llm-context/` (scaffolded-repo style)

If none exists, say "No agent context found here (looked for `.claude/llm-context/`, `.llm-context/` and `docs/llm-context/`)." and stop.

## Steps

1. Read `<ctx>/ARCHITECTURE.md` — load-bearing decisions and constraints
2. Read `<ctx>/AGENT-CONTEXT.md` — current project state
3. Find the most recent session log in `<ctx>/session-log/` (sort by date) and read it
4. Say "Context loaded. What would you like me to work on?"
5. **STOP and WAIT** — do not start any work until the user specifies a task

If you find yourself proposing something that contradicts ARCHITECTURE.md, flag the contradiction to the user before acting. Those rules can be broken — but only deliberately.
