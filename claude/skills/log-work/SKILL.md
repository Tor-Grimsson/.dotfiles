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

1. `.claude/llm-context/` (vault-style, merged into the Claude dir)
2. `.llm-context/` (vault-style, at repo root)
3. `docs/llm-context/` (scaffolded-repo style)

If none exists, say "No agent context found here (looked for `.claude/llm-context/`, `.llm-context/` and `docs/llm-context/`)." and stop.

## Steps

1. Read the current `<ctx>/AGENT-CONTEXT.md` to understand prior state
2. Create a new session log at `<ctx>/session-log/!`date +%Y-%m-%d`-$ARGUMENTS.md` (slugify the description)
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
5. Say "Session log created at [path]. AGENT-CONTEXT.md updated."
