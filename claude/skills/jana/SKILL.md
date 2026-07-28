---
name: jana
description: User signal appended to a message meaning "just answer, no action" — respond with the answer only; zero tool calls, no edits, no file writes, no agents, no memory writes, no follow-up work. Triggered by /jana (user-invoked only).
---

# jana — just answer, no action

The user appended /jana to their message. It means: this is a question or a sanity-check, not a work request.

## Do
1. **Answer the question(s).** Directly, first line = the answer.
2. If the message asks for steps or a plan, describe them — describing is not doing.
3. Stop when the answer is complete.

## Don't
- No tool calls of ANY kind — no edits, writes, bash, agents, memory writes, no "quick fixes while I'm here".
- No treating implied work as a go. Even if the fix is one line, /jana means it waits.
- No trailing offers.

The next message without /jana returns to normal rules.
