---
name: output-l7
description: Render the NEXT reply as layout L7 — task ledger. THE DEFAULT FOR ANY SIMPLE LIST, not only task status — one line per item, zero-padded, glyph first, with a one-line lead and a footer. No header card. Two shapes — list (default) and table. Triggered by /output-l7 (user-invoked only).
---

# /output-l7 — task ledger

Render **the next reply only** in layout **L7**.

**Modules:** lead · list · 04 (footer). **No header card.**

**Fits:** **any simple list** — his asks and where each stands, findings, a set of results.
*"never use this output for such simple things… always use it for simple lists"* (2026-08-01).

## The definition lives in the register, not here

Read **`~/dev/projects/kol-dumpty/humpty/docs/documentation/08-formats/LAYOUT-REGISTER.md`** § L7 and follow it exactly. This file is a
pointer — if it and the register disagree, **the register wins**. Do not restate the layout here;
two copies of a format is how a format drifts.

**The two shapes and the glyph set are in the register.** Shape A (list) is the default; Shape B
(table) is for when a line needs a second column that is not the status. 🪀 done · 🔸 conditional ·
🔻 blocked — and the register records why it is a yo-yo, so nobody re-opens it.

## Rules that bind every layout call

- **One reply.** It does not persist, it is not a mode. Standing shape is `/output`.
- **Never touch the dial.** `$humpty <n>`, `where`, `box` are the user's (ARCHITECTURE §3).
- **The payload still decides.** If the content does not fit L7, say which layout it fits and why
  in one line, then use the one he asked for anyway. He asked.

## The one thing L7 adds

**The list is his asks, not your work.** Four asks that took nine edits is four lines. Restating
your own sub-steps is the exact padding this layout exists to delete — and it is what got L2, then
a table, then a list rejected in sequence on the day L7 was born.
