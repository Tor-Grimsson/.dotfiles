---
name: feedback_message_format_drift
description: "Stop dropping the CLAUDE.md report-shape rules (fenced header card, tables-first, footer line) partway through a long working session"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 87a3f20f-1f69-4b8b-92a6-f75f27aadd7a
---

Global `CLAUDE.md` specifies a report shape for substantive replies: a fenced header card (date, breather, title as the fence's last line), a 1–2 sentence plain-language lead, tables/checkboxes for parallel facts, and a footer line ending in "say \"show noise\" to expand." This is not optional styling — it's a standing instruction, same weight as any other rule in that file.

**Why:** during one 2026-07-05 dotfiles session I followed it for the first couple of replies, then dropped it for roughly a dozen substantive replies in a row (docs reorg, SSH tool comparisons, recommendations) reverting to plain prose/tables with no header card. User had to call it out explicitly, angrily, and pair it with a second complaint (doc-sync lapses, see [[feedback_sync_doc_on_source_edit]]) — the pattern is: rules given once at session start erode under momentum over a long task-heavy conversation, not because they're forgotten but because they're not re-checked per-reply once execution mode takes over.

**How to apply:** before sending any reply longer than a couple of lines, check: (1) does this need the fenced header card (skip only for genuine one-liners), (2) are parallel facts in a table, not stacked prose. Re-check this on *every* substantive reply for the rest of a long session, not just the first few — the failure mode is drift after many tool-heavy turns, not misunderstanding the rule. If a long execution-heavy stretch is coming (many file edits, several tool calls), that is exactly when to be more deliberate about the final reply's shape, not less.

**Recurred same day, later in the same long session** (git-troubleshooting stretch — skip-worktree testing, doc fixes): several replies in a row went back to plain prose paragraphs with no header card and no tables for parallel facts (list of docs fixed, test results). User: "you have just waterfall dumped text without any rhyme or reason." Confirms this isn't a one-off — a single long session can drift back into it a *second* time after an earlier correction already landed. Don't treat one fix as durable for the rest of the session; the check in the paragraph above needs to run on literally every substantive reply, including ones deep into a technical debugging back-and-forth where structure feels like it would slow the exchange down. It's exactly those replies (dense findings, multiple file changes, test results) that most need a table instead of a wall of prose.
