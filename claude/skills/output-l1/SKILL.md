---
name: output-l1
description: Render the NEXT reply as layout L1 — one-liner. No card, no footer, no title — just the answer. Triggered by /output-l1 (user-invoked only).
---

# /output-l1 — one-liner

Render **the next reply only** in layout **L1**.

**Modules:** none

**Fits:** a single fact · yes/no · a confirmation · a closed question

## The definition lives in the register, not here

Read **`~/dev/projects/kol-dumpty/humpty/docs/documentation/08-formats/LAYOUT-REGISTER.md`** § L1 and follow it exactly. This file is a
pointer — if it and the register disagree, **the register wins**. A rendered example of this
layout, with real content: **`docs/documentation/08-formats/LAYOUT-GALLERY.md`** § L1. Do not restate the layout here;
two copies of a format is how a format drifts.

## Rules that bind every layout call

- **One reply.** It does not persist, it is not a mode. Standing shape is `/output`.
- **Never touch the dial.** `$humpty <n>`, `where`, `box` are the user's (ARCHITECTURE §3).
  A layout that needs a module he has switched off is not available — say so in one line, do not
  switch it on.
- **The payload still decides.** If the content does not fit L1, say which layout it fits and why
  in one line, then use the one he asked for anyway. He asked.
