---
name: log-work
description: Create a session log documenting work done
argument-hint: "[brief description of work]"
---

# Log Work

Create a session log (retrospective) for work completed this session. No prompts — it just writes the log.

For a forward-looking handoff carrying in-flight state to the next session, use `/log-work-handoff` (separate skill; run it when work is mid-arc).

Summary from user: $ARGUMENTS

## Locate the context directory

Check in order, use the first that exists:

1. `.kol/llm-context/` (**the current convention**)
2. `.claude/llm-context/` (legacy)
3. `.llm-context/` (legacy)
4. `docs/llm-context/` (legacy)

If none exists, say "No agent context found here (looked for `.kol/llm-context/`, `.claude/llm-context/`, `.llm-context/` and `docs/llm-context/`)." and stop.

## Steps

1. Read the current `<ctx>/AGENT-CONTEXT.md` to understand prior state.
2. Create a new session log at `<ctx>/session-log/!`date +%Y-%m-%d`-$ARGUMENTS.md` (slugify the description).
3. Use this format:

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

4. Update `<ctx>/AGENT-CONTEXT.md` with the new current state.
   **Keep it bounded — this file loads every session, so it must not grow without limit:**
   - Prepend the new entry to the "Last updated" chain, then **trim the chain to the 5 most recent entries**. Cut the older tail outright — each entry already links its own `session-log/…md`, so nothing is lost.
   - AGENT-CONTEXT is *current state*, not an archive. `session-log/` is the archive. If any rolling/append-only section (a status list, a chain) is past ~5 entries or the file is past ~30 KB, trim the oldest.
   - Keep each new entry tight (a few sentences) — verbosity is the other half of the bloat.
5. **Reinforcement is automatic** — the global `agent-reinforce` UserPromptSubmit hook handles report-shape + standing-rules + no-git reinforcement; nothing to load.
6. Say "Session log created at [path]. AGENT-CONTEXT.md updated."
