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

4. Update `<ctx>/AGENT-CONTEXT.md` with the new current state
5. Say "Session log created at [path]. AGENT-CONTEXT.md updated."
