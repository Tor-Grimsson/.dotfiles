---
name: log-work
description: Create a session log documenting work done
disable-model-invocation: true
argument-hint: "[brief description of work]"
---

# Log Work

Create a session log for work completed this session.

Summary from user: $ARGUMENTS

## Locate the context directory

Check in order, use the first that exists:

1. `.kol/llm-context/` (**the current convention**)
2. `.claude/llm-context/` (legacy)
3. `.llm-context/` (legacy)
4. `docs/llm-context/` (legacy)

If none exists, say "No agent context found here (looked for `.kol/llm-context/`, `.claude/llm-context/`, `.llm-context/` and `docs/llm-context/`)." and stop.

## Steps

1. Read the current `<ctx>/AGENT-CONTEXT.md` to understand prior state
2. **Ask via `AskUserQuestion`:** "Also write a session-bridge handoff?" — **Yes — mid-arc** (carries in-flight state forward to the next session) or **No — concluded** (session log suffices). The session log is always written; this only controls whether a handoff is also written.
3. Create a new session log at `<ctx>/session-log/!`date +%Y-%m-%d`-$ARGUMENTS.md` (slugify the description)
4. Use this format:

```
# Session: [Brief Description]

**Date:** YYYY-MM-DD
**Agent:** [Your identifier]
**Summary:** [One-line description]

## Changes Made

### Files Modified
- path/to/file — [what changed]

### Features Added/Removed
- [Feature description]

## Current State

### Working
- [What's functional now]

### Known Issues
- [Any problems discovered]

## Next Steps
1. [Recommended next task]
2. [Follow-up work]
```

5. (If **Yes** in step 2) Create a handoff at `<ctx>/session-bridge/handoff-!`date +%Y-%m-%d-%H%M`-$ARGUMENTS.md` — the `HHMM` lets the startup "newer wins" rule compare it against the session log. Format:

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

6. Update `<ctx>/AGENT-CONTEXT.md` with the new current state.
   **Keep it bounded — this file loads every session, so it must not grow without limit:**
   - Prepend the new entry to the "Last updated" chain, then **trim the chain to the 5 most recent entries**. Cut the older tail outright — each entry already links its own `session-log/…md`, so nothing is lost.
   - AGENT-CONTEXT is *current state*, not an archive. `session-log/` is the archive. If any rolling/append-only section (a status list, a chain) is past ~5 entries or the file is past ~30 KB, trim the oldest.
   - Keep each new entry tight (a few sentences) — verbosity is the other half of the bloat.
7. Say "Session log created at [path]. [Handoff at [path] | Handoff skipped — work concluded.] AGENT-CONTEXT.md updated."
