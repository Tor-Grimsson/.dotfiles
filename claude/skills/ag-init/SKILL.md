---
name: ag-init
description: Load the repo's agent context for a new session — ARCHITECTURE, AGENT-CONTEXT, latest session log, the docs index, and any lobby receipts owed back to this repo
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
3. Read `<ctx>/AGENT-CONTEXT.md` — current project state. Then, if `docs/documentation/INDEX.md` exists, read it (and `docs/INDEX.md` if present) — the vault index. This is **awareness, not study**: it maps what the repo has documented so the laws can be found by name before anything is improvised. `.kol/` carries history and state; `docs/` carries the rules. No index → silent, no error, no mention.
4. Find the most recent session log in `<ctx>/session-log/` (sort by date) and read it
5. Check `<ctx>/session-bridge/` for `handoff-*.md`. If the newest handoff's timestamp is newer than the newest session log, read it too — it carries in-flight state the log doesn't. Otherwise skip.
6. **KOL-update check** (guard: only if `package.json` declares an `@kolkrabbi/*` dependency — otherwise skip silently). Check for newer published versions: `pnpm outdated "@kolkrabbi/*"` if `pnpm-lock.yaml` exists, else `npm outdated "@kolkrabbi/*"`. Registry unreachable (offline) → note it in one line, move on. **Report only — never bump or install in this step.**
7. **Receipts — what this repo filed elsewhere** (guard: only if `lobby/outbox/` exists — otherwise skip silently). Read every stub. Two classes matter and nothing else does: a receipt whose **`Remainder here:` is not `none`** (📌 — the destination closed the ticket and left work **here**), and one still at 🔵 🟡 🟠 (filed, no news — so it does not get re-filed today). A 🟢 with `Remainder here: none` is history; stay silent on it. **Report only** — never start the remainder, never change a state, and never call anything "open" the ledger has not. Protocol: `~/.dotfiles/docs/operations/systems/lobby/02-lifecycle.md` § The return receipt.
8. **Reinforcement is automatic** — the global `agent-reinforce` UserPromptSubmit hook (dotfiles `claude/hooks/agent-reinforce.sh`) injects report-shape + standing-rules + no-git reinforcement on a cadence (full on turn 1, compact every ~5 turns). Nothing to load here; it re-grounds mid-session, which the old skill bundle couldn't.
9. Say "Context loaded — on the **\<iMac|MBP\>**. What would you like me to work on?" — if context was found at a **legacy** location (2–4), append: "This repo uses the legacy context layout — run `/kol-migrate-structure` to converge it onto `.kol/`." If step 6 found stale KOL packages, add a line listing them (`name current→latest`) and ask whether to update before starting — apply the bump + install **only on the user's explicit OK**. **If step 5 read a handoff, print its summary here** (goal of the arc, open decision points, next intended action) — don't just silently fold it into context; the user needs to see what's outstanding without asking. **If the docs index was read**, name the sections that govern the work at hand in one line — pointers, not a summary of the index. **If step 7 found receipts, print them here as their own short table** — 📌 remainders first, then still-open filings. This is the one class of pending task a repo has **no other record of**: it was decided in someone else's session, in someone else's ledger.
10. **STOP and WAIT** — do not start any work until the user specifies a task

If you find yourself proposing something that contradicts ARCHITECTURE.md, flag the contradiction to the user before acting. Those rules can be broken — but only deliberately.
