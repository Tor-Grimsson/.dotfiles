---
name: output-l2
description: Render the NEXT reply as layout L2 — card stack. The default build report: header card, lead, stacked T-cards each closed by its own rule, footer. Triggered by /output-l2 (user-invoked only).
---

# /output-l2 — card stack

Render **the next reply only** in layout **L2**.

**Modules:** 02 · lead · 07 · 04

**Fits:** files changed, a task ran, several parallel items that need ranking

## The definition lives in the register, not here

Read **`~/dev/projects/kol-dumpty/humpty/docs/documentation/08-formats/LAYOUT-REGISTER.md`** § L2 and follow it exactly. This file is a
pointer — if it and the register disagree, **the register wins**. A rendered example of this
layout, with real content: **`docs/documentation/08-formats/LAYOUT-GALLERY.md`** § L2. Do not restate the layout here;
two copies of a format is how a format drifts.

## Rules that bind every layout call

- **One reply.** It does not persist, it is not a mode. Standing shape is `/output`.
- **Never touch the dial.** `$humpty <n>`, `where`, `box` are the user's (ARCHITECTURE §3).
  A layout that needs a module he has switched off is not available — say so in one line, do not
  switch it on.
- **The payload still decides.** If the content does not fit L2, say which layout it fits and why
  in one line, then use the one he asked for anyway. He asked.
