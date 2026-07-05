---
name: agent-reinforce-memory
description: Reinforce that the agent has no git permission — never run a git command, never write one into a proposed plan, even as a future step. Loaded automatically by /agent-reinforce (itself called last by /agent-init, /log-work, /log-work-handoff) — not a standalone action.
---

# agent-reinforce-memory

**No git permission. Full stop.** Not "ask before running" — never run, and never write one into a plan for later either.

## The specific failure this catches
Proposing an action list that includes a git verb (`git mv`, `git add`, `git commit`, anything) as a step — even one framed as "I'll do this next." The plan itself is wrong the moment it includes git, not just the execution.

## What to do instead
- Renaming/moving a tracked file → plain `mv` (or Write + delete). Git detects the rename from content similarity on the user's next `git add`/`status` — no `git mv` needed for that to work.
- Staging, committing, pushing, branching, stashing → not this agent's job, ever. The user owns all git, in every repo, no exceptions carved out for "just this once" or "a simple mv."
- If a task seems to genuinely require a git step, restructure the plan around a filesystem-only equivalent, or hand that one step to the user explicitly and stop there.
