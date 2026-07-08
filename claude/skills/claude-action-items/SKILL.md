---
name: claude-action-items
description: User signal to strip the last reply down to a runbook — one flat numbered list of the exact steps to do, verb-first, in order, with the real paths/commands/values on each line. Throws away the why, the caveats, and the options; keeps only what to do. Triggered by /claude-action-items (user-invoked only).
---

# claude-action-items

The last reply *suggested* things — now cut everything that isn't a step and give the **runbook**: one flat numbered list, verb-first, in the exact order to do them. No why, no caveats, no options. Just do-this-then-that. (claude-bullet keeps all the content and restructures it; claude-clear shortens it; **this one throws away everything that isn't an action**.)

## Do
1. **Extract only actions.** Every concrete do-able step becomes a line. Drop rationale, background, "how it works", reassurance.
2. **One flat numbered list, 1..N**, in execution order. No section headers, no sublists unless a step genuinely branches.
3. **Verb first, imperative.** "Open Dashboard", "Tick the box", "Save" — not "You could open…".
4. **Put the exact path / command / value on the step** — the click-path, the shell command, the setting value. Concrete, never "configure X".
5. **Fold a required choice into its step:** "If media is on a NAS, skip step 3 and set a 30-min scheduled scan instead." No separate options menu.
6. **Last action = last line.** If verification is a real step, it's the final number.

## Don't
- No explaining *why* — only *what* and *how*. They'll ask if they want the reasoning.
- No caveats as prose — a caveat survives only if it changes an action, and then it lives *inside* that step.
- No header, intro, or outro. First line is step 1 (or a one-line goal if the target is ambiguous).
- No trailing "want me to…". End on the last step.
- Don't invent steps that weren't in the suggestion — this is extraction, not new advice.

## Shape
[Optional one-line goal — only if the target isn't obvious.]

1. Verb + object + exact path/command.
2. Verb + object + value.
3. If <condition>: do X instead.
4. …
9. Final step / verification.

Stop there.
