---
name: log-work-handoff
description: Create a session-bridge handoff carrying in-flight state to the next session
disable-model-invocation: true
argument-hint: "[brief description of work]"
_template:
  version: 1
  path: .claude/skills/log-work-handoff/SKILL.md
  sync: replace
---

# Log Work — Handoff

Write a forward-looking session-bridge handoff for work that's mid-arc, so the next session resumes with in-flight state intact.

This does **not** write a session log — that's `/log-work` (the retrospective). They're independent; run either or both.

Summary from user: $ARGUMENTS

## Steps

1. Read `.kol/llm-context/AGENT-CONTEXT.md` and the newest `.kol/llm-context/session-log/` entry to ground the handoff in current state.

2. Create a session-bridge handoff at `.kol/llm-context/session-bridge/handoff-!`date +%Y-%m-%d-%H%M`-$ARGUMENTS.md`. The `HHMM` in the name lets the startup protocol's "newer wins" rule compare it against the session log unambiguously. Format:

```
# Handoff — YYYY-MM-DD HH:MM

## Goal of the current arc
[One or two sentences on what this push is aiming at.]

## Last actions taken (causal trail, newest first)
- [Recent action]
- [Prior action]
- [etc.]

## Current state / open decision points
- [Where we are, what's blocking, what's been deferred]

## Next intended action
- [What the next session should do first]

## Working memory not yet in AGENT-CONTEXT
- [Observations, half-formed ideas, anything that doesn't earn a place in the long-lived doc but matters now]
```

3. Say "Handoff created at [path]."

## Notes

- The handoff is forward-looking; the session log (`/log-work`) is the retrospective. Independent skills — run either or both.
- See `.kol/llm-context/session-bridge/README.md` for the full protocol (filename rules, the next-session read-rule, lifecycle).
- The user can edit or overwrite the handoff afterward. Old handoffs accumulate as natural history; never auto-delete.
