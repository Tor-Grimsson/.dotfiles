---
name: ag-init
description: Load the repo's agent context (ARCHITECTURE, AGENT-CONTEXT, latest session log) for a new session
allowed-tools: Read, Glob, Bash, Skill
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
6. **KOL-update check** (guard: only if `package.json` declares an `@kolkrabbi/*` dependency — otherwise skip silently). Check for newer published versions: `pnpm outdated "@kolkrabbi/*"` if `pnpm-lock.yaml` exists, else `npm outdated "@kolkrabbi/*"`. Registry unreachable (offline) → note it in one line, move on. **Report only — never bump or install in this step.**
7. **Load `/agent-reinforce`** via the Skill tool — bundles report-shape + standing-rules + no-git-permission reinforcement in one call. Last thing before reporting status, not the first — everything above must already be loaded.
8. Say "Context loaded — on the **\<iMac|MBP\>**. What would you like me to work on?" — if context was found at a **legacy** location (2–4), append: "This repo uses the legacy context layout — run `/kol-migrate-structure` to converge it onto `.kol/`." If step 6 found stale KOL packages, add a line listing them (`name current→latest`) and ask whether to update before starting — apply the bump + install **only on the user's explicit OK**. **If step 5 read a handoff, print its summary here** (goal of the arc, open decision points, next intended action) — don't just silently fold it into context; the user needs to see what's outstanding without asking.
9. **STOP and WAIT** — do not start any work until the user specifies a task

If you find yourself proposing something that contradicts ARCHITECTURE.md, flag the contradiction to the user before acting. Those rules can be broken — but only deliberately.
