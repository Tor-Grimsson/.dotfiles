---
name: init-agent
description: Load the repo's agent context (ARCHITECTURE, AGENT-CONTEXT, latest session log) for a new session
disable-model-invocation: true
allowed-tools: Read, Glob, Bash
---

# Agent Initialization

Load the agent-context protocol for the current repo. Works in any repo that carries it.

## Locate the context directory

Check in order, use the first that exists:

1. `.kol/llm-context/` (**the current convention** — machinery at repo root, hidden)
2. `.claude/llm-context/` (legacy, vault-style merged into the Claude dir)
3. `.llm-context/` (legacy, at repo root)
4. `docs/llm-context/` (legacy, scaffolded-repo style)

If none exists, say "No agent context found here (looked for `.kol/llm-context/`, `.claude/llm-context/`, `.llm-context/` and `docs/llm-context/`)." and stop.

## Steps

1. Run `uname -m` to name the machine — `arm64` = Apple-Silicon **MBP**, `x86_64` = Intel **iMac**. Detect it; never ask which machine.
2. Read `<ctx>/ARCHITECTURE.md` — load-bearing decisions and constraints
3. Read `<ctx>/AGENT-CONTEXT.md` — current project state
4. Find the most recent session log in `<ctx>/session-log/` (sort by date) and read it
5. Check `<ctx>/session-bridge/` for `handoff-*.md`. If the newest handoff's timestamp is newer than the newest session log, read it too — it carries in-flight state the log doesn't. Otherwise skip.
6. Say "Context loaded — on the **\<iMac|MBP\>**. What would you like me to work on?" — if context was found at a **legacy** location (2–4), append: "This repo uses the legacy context layout — `/kol-migrate-structure` converges it to `.kol/`."
7. **STOP and WAIT** — do not start any work until the user specifies a task

If you find yourself proposing something that contradicts ARCHITECTURE.md, flag the contradiction to the user before acting. Those rules can be broken — but only deliberately.
