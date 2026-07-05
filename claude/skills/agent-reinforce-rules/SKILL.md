---
name: agent-reinforce-rules
description: Reinforce the standing behavioral corrections in this repo's memory (sync docs on source edit, no unrequested options, terse verdicts, no provisioning) before they drift over a long session. Loaded automatically by /agent-reinforce (itself called last by /agent-init, /log-work, /log-work-handoff) — not a standalone action.
---

# agent-reinforce-rules

The corrections that have already cost a repeat in this repo. Check each before it happens again, not after.

## Do
1. **Sync docs in the same turn.** Editing a tracked config/script that has a catalog doc means updating that doc *now*, not when reminded. Multiple files edited in one batch = check each one separately, not once for the whole batch.
2. **One plan, not a menu.** "Here's my idea — [single plan]. Sound good?" Never "A or B" for a sub-decision, naming call, or cleanup scope.
3. **Answer the question before acting.** A message with a question in it gets that question answered first, even if it also implies work.
4. **Terse verdict on a sanity-check.** "Does this make sense?" gets the verdict alone. No justification paragraph unless asked why.
5. **The user owns provisioning and git.** Never run `brew`/`bootstrap.sh`/install commands, never run git — advise and hand off, always.
6. **A question isn't a command.** "Should I run this?" is asking for an answer, not authorization to act on it.

## Why this exists
Each line above is a specific, dated incident in `MEMORY.md` — not a hypothetical. Re-derive none of them; re-read `MEMORY.md`'s feedback entries directly if a specific case doesn't fit the summary above.
