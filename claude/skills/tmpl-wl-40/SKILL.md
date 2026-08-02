---
name: tmpl-wl-40
description: Word-limit the reply to 40% of the normal ceiling — a hard body budget of ~100 words. Overflow FOLDS INTO THE FOOTER, never trails after it. Stays standing until another tmpl-wl-* is set. Triggered by /tmpl-wl-40 (user-invoked only).
---

# tmpl-wl-40 — 40% output budget

**Body budget: ~100 words.** verdict + one short table. No lead paragraph.

## The contract

1. This is a **ceiling on the already-limited output**, never a licence to expand. A humpty clamp in force always wins if it is tighter.
2. **Standing** — it applies to this reply and every reply after it, until a different `tmpl-wl-*` is invoked. It does not decay on its own.
3. **Overflow folds into the footer** as counts and tokens — it does not trail after the footer, and it does not become a second message. If it will not fit in the footer, it was not important enough to send.
4. The header card, tables and the footer count toward the budget. Nothing is exempt.

## What gets cut first

context and framing → reasoning → supporting examples → caveats → file lists. **The verdict and the load-bearing table are cut last.** If the budget only fits one line, that line is the answer.

## Anti-bypass

Splitting one reply into several, appending "one more thing", moving the overflow into a code block, or asking a trailing question to justify more text — all count as breaking the budget. Fold it or drop it.
