---
name: feedback_footer_fold_bar_too_high
description: "Bar for 'load-bearing enough to surface inline' is much higher than it feels in the moment — default to folding into the footer count"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 64b8a754-24f9-4ed7-864c-b79cdc14a3be
---

CLAUDE.md's report shape says: fold caveats/side-notes into ONE footer line, and "surface a caveat inline only when load-bearing — it changes the user's next action." When judging that in the moment, the bar was set too low.

**Why:** in a 2026-07-05 dotfiles session (docs→wikilink conversion), two findings got written out as full inline bullets with headers ("Two things flagged, not fixed") — a stale pre-existing anchor bug, and an inconsistent wikilink in `TOOLING.md`. Both felt worth explaining at the time. User: "you should have folded those fucking caveats you pinned to the bottom into the footer, its UNHELPFUL NOISE." Neither finding required the user to *do* anything differently in their next message — they were discoveries worth a mention, not decisions or blockers. That's exactly the footer's job (`caveats: 2 · say "show noise" to expand"`), not the body's.

**How to apply:** default to the footer count. Only break a caveat out into the body if the user cannot safely proceed without seeing it *right now* — e.g. a change that didn't apply, a decision that needs their input before the next step. "Found a pre-existing bug while doing X" or "noticed an inconsistency" is footer material even when it's genuinely true and genuinely found — mention it exists (the count), don't narrate it inline. See [[feedback_message_format_drift]] for the related (but distinct) failure of dropping the report shape's structure entirely.
