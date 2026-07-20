---
name: kol-goal
description: Set a persistent goal that the goal-loop Stop hook enforces — while active, the agent is blocked from stopping and re-prompted to keep working until the goal is done. Use /kol-goal <description> to start, /kol-goal done to finish, /kol-goal blocked <reason> to escape, /kol-goal status to check. The "ralph loop" for a task that must run to completion without stopping. (Named /kol-goal, not /goal, to stay unambiguous.)
---

# kol-goal — the non-stop work loop

Sets an **active goal** that the `goal-loop` Stop hook (`claude/hooks/goal-loop.sh`) enforces: while a goal is active, any attempt to stop is **blocked** and the goal is re-injected, so work continues until the goal is explicitly finished. This is the "ralph loop." State lives at `.kol/llm-context/.active-goal.md` (ephemeral, gitignored).

## Commands

**`/kol-goal <description>`** — start.
1. Write `.kol/llm-context/.active-goal.md`:
   ```
   status: active
   iter: 0
   max: 30
   goal: <description>
   ```
2. Then **immediately start working** and keep going — don't stop to ask for approval on sub-steps; the hook blocks stopping anyway. Break blockers yourself; escape only via `/kol-goal blocked` if you truly need the user.

**`/kol-goal done`** — the goal is fully, verifiably complete.
- Set `status: done` in the file (or delete it). Releases the Stop hook → you may stop and report. **Only mark done when genuinely met — don't game the loop.**

**`/kol-goal blocked <reason>`** — a real blocker; you need the user.
- Set `status: blocked` and append the reason. Releases the hook so you can stop and surface the blocker.

**`/kol-goal status`** — print the current goal file (status · iter · goal).

## Rules
- One goal at a time; a new `/kol-goal <x>` overwrites the active one.
- The iteration cap (`max`, default 30) is the runaway backstop — at the cap the hook releases (`status: capped`) so it can't loop forever.
- The hook is inert when no goal file exists, so a stray file left `done`/`blocked`/`capped` won't trap future replies.
