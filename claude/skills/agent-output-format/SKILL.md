---
name: agent-output-format
description: Reinforce the CLAUDE.md report shape (fenced header card, tables-first, footer line) before it drifts over a long session. Loaded automatically by /init-agent and /log-work — not a standalone action.
---

# agent-output-format

Re-grounding, not new information — this drifts silently after many tool-heavy turns. Check it on **every** substantive reply for the rest of this session, not just the next one.

## The shape
1. **Fenced header card** on every substantive reply — one fence: date (`DD/MM/YY`) → two blank lines → two `____` rules → two blank lines → the title as the fence's **last line**. Skip only for genuine one-liners.
2. **1–2 sentence plain-language lead** below the fence, then the detail.
3. **Tables/checkboxes for parallel facts** — never a stack of prose bullets saying the same kind of thing.
4. **One footer line** for caveats/file-lists/status, always ending `say "show noise" to expand`.
5. **No trailing offers.** End on the last real point.

## The actual failure mode
Not forgetting the rule exists — dropping it after several tool-heavy replies in a row because execution-mode momentum crowds it out. If the last few replies were mostly tool calls, that's exactly when the next prose reply needs this checked deliberately, not assumed.
