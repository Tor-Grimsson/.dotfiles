---
name: log-work
description: Create a session log documenting work done this session
disable-model-invocation: true
argument-hint: "[brief description of work]"
_template:
  version: 3
  path: .claude/skills/log-work/SKILL.md
  sync: replace
---

# Log Work

Create a session log (retrospective) for the work just completed. No prompts — it just writes the log.

For a forward-looking handoff carrying in-flight state to the next session, use `/log-work-handoff` (separate skill; run it when work is mid-arc).

Summary from user: $ARGUMENTS

## Steps

1. Read the current `.kol/llm-context/AGENT-CONTEXT.md` to understand prior state.

2. Create a new session log at `.kol/llm-context/session-log/!`date +%Y-%m-%d`-$ARGUMENTS.md` (slugify the description). Format:

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

3. Update `.kol/llm-context/AGENT-CONTEXT.md` with any changes to long-lived state (status, what works, key files, contracts, etc).
   **Keep it bounded — this file loads every session start, so it must not grow without limit:**
   - If the "Last updated" state is a rolling chain of session entries, prepend the new entry then **trim to the 5 most recent**; cut the older tail. Nothing is lost — each entry links its own `session-log/…md`, which is the archive.
   - AGENT-CONTEXT is *current state*, not history. If any append-only section runs past ~5 entries, or the file exceeds ~30 KB, trim the oldest.
   - Keep each entry tight (a few sentences). Verbosity is the other half of the bloat.

4. Say "Session log created at [path]. AGENT-CONTEXT.md updated."

## Notes

- The session log is past-tense and archival. For the forward-looking bridge to the next session, run `/log-work-handoff`.
