---
name: log-work-handoff
description: Create a session-bridge handoff carrying in-flight state to the next session
argument-hint: "[brief description of work]"
---

# Log Work — Handoff

Write a forward-looking session-bridge handoff for work that's mid-arc, so the next session resumes with in-flight state intact.

This does **not** write a session log — that's `/log-work` (the retrospective). They're independent; run either or both.

Summary from user: $ARGUMENTS

## Locate the context directory

Check in order, use the first that exists:

1. `.kol/llm-context/` (**the current convention**)
2. `.claude/llm-context/` (legacy)
3. `.llm-context/` (legacy)
4. `docs/llm-context/` (legacy)

If none exists, say "No agent context found here (looked for `.kol/llm-context/`, `.claude/llm-context/`, `.llm-context/` and `docs/llm-context/`)." and stop.

## Steps

1. Read `<ctx>/AGENT-CONTEXT.md` and the newest `<ctx>/session-log/` entry to ground the handoff in current state.
2. Create a handoff at `<ctx>/session-bridge/handoff-!`date +%Y-%m-%d-%H%M`-$ARGUMENTS.md` — the `HHMM` lets the startup "newer wins" rule compare it against the session log. Format:

```
# Handoff — YYYY-MM-DD HH:MM

## Goal of the current arc
[One or two sentences on what this push is aiming at.]

## Last actions taken (causal trail, newest first)
- [Recent action]
- [Prior action]

## Current state / open decision points
- [Where we are, what's blocking, what's been deferred]

## Next intended action
- [What the next session should do first]

## Working memory not yet in AGENT-CONTEXT
- [Observations, half-formed ideas that matter now but don't earn a place in the long-lived doc]
```

3. **Load `/agent-reinforce`** via the Skill tool — reinforcement, last thing before reporting, not first.
4. Say "Handoff created at [path]."

## Notes

- The handoff is forward-looking; the session log (`/log-work`) is the retrospective. Independent skills — run either or both.
- See `<ctx>/session-bridge/README.md` for the full protocol (filename rules, the next-session read-rule, lifecycle).
- The user can edit or overwrite the handoff afterward. Old handoffs accumulate as natural history; never auto-delete.
