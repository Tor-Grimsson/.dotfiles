---
name: yn
description: Short alias of /tmpl-yn — answer the question and nothing else. One word, yes or no, no footer, no header card, no reasoning. Two or more questions get a numbered one-word sequence (1 no · 2 no · 3 yes). Triggered by /yn (user-invoked only).
---

# yn — alias of /tmpl-yn

Identical contract to `/tmpl-yn`:

1. **One word.** `yes` or `no`. That is the entire reply.
2. **2+ questions** → numbered sequence, one word each: `1 no` / `2 no` / `3 yes`.
3. **Not answerable yes/no** → the shortest true answer, ≤ 1 line.
4. **No footer, no header card, no reasoning, no caveat, no attached work.** He asks "why" if he wants why.

`yes` alone is a complete reply. The pull to justify it is the failure this stops. If a qualifier feels load-bearing, the honest answer is `no` — not `yes, but`.

The next message without `/yn` (or `/tmpl-yn`) returns to normal rules.
