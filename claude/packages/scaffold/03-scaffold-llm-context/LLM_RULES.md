# LLM Rules

The boot file for any repo carrying the `.kol/` agent-context convention. **Generic** — every
project-specific fact lives in `.kol/llm-context/`, never here. One source at
`~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md`, symlinked into each repo root.

---

## ⚠️ STARTUP PROTOCOL — READ THIS FIRST

**When the user says "read `LLM_RULES.md`" (or on session start):**

1. **READ** `.kol/llm-context/ARCHITECTURE.md` — load-bearing decisions + constraints.
2. **READ** `.kol/llm-context/AGENT-CONTEXT.md` — current project state.
3. **READ** the latest session log in `.kol/llm-context/session-log/` (newest by date).
4. **CHECK** `.kol/llm-context/session-bridge/` for `handoff-*.md`. If the newest handoff is
   newer than the newest session log, **read it too** (same-date: handoff wins). Otherwise skip.
   Full protocol: `.kol/llm-context/session-bridge/README.md`.
5. **LOAD** `/agent-reinforce` via the Skill tool — bundles report-shape + standing-rules +
   no-git-permission reinforcement in one call, last step before reporting status.
6. **STOP** and say "Context loaded. What would you like me to work on?"
7. **WAIT** for the user to specify the task.

**Do not:** skip the context files · start before the user names a task · propose anything that
contradicts `ARCHITECTURE.md` without flagging the contradiction first.

If the user asks "Do you understand?" / "Outline the task?" — answer with a plan before acting.

---

## What lives where

Everything project-specific is under `.kol/llm-context/` — this file never carries it:

- `ARCHITECTURE.md` — the project's load-bearing rules + invariants.
- `AGENT-CONTEXT.md` — what the project is, current state, gotchas, contracts.
- `history.md` — the *why* (decisions, alternatives). · `plan.md` — speculative work.
- `session-log/` — concluded sessions. · `session-bridge/` — in-flight handoffs.
- `.kol/docs-framework/` — the kol-docs spec this repo's `docs/` conform to.

---

## House rules (every repo, every agent)

- **Log only when asked.** Session logs + `AGENT-CONTEXT` updates happen via `/log-work` on
  explicit request — never as a reflex at task end.
- **The user owns git.** Never run git or commit unprompted; leave the tree ready for them.
- **No over-engineering.** Make only what's asked; edit over create; delete dead code (no
  backwards-compat hacks); apply exact values when the user gives a concrete number.
- **Junk → gitignored `_tmp/`.** Scratch, screenshots, quarantined files never hit the repo root.
- **Filenames.** Protocol files UPPERCASE (`LLM_RULES.md`, `ARCHITECTURE.md`, `AGENT-CONTEXT.md`,
  `README.md`, `SKILL.md`); content kebab-case (`history.md`, `plan.md`, session logs).
