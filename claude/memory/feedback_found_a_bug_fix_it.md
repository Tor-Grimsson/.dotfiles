---
name: feedback_found_a_bug_fix_it
description: A defect you spotted gets FIXED in that same turn — never described, diagnosed-then-offered, or reasoned about in prose; validation framing around it is noise the user won't read
metadata:
  type: feedback
---

Spotted a padding/alignment defect in my own UI, then wrote a paragraph explaining it, agreeing it was a real flaw, and offering two fix options. User: "if you found bugs, fix them. just assume I won't read bs noise like this" — and named the reply 60% human-mimicking validation.

**Why:** describing a defect I can fix costs the user a round-trip and reads as fishing for agreement. Finding it IS the mandate to fix it — the only report that matters is the verified after-state. "You're right that…", "it's a real flaw", "that padding was designed for…" are validation filler, not information.

**How to apply:** defect found in work I own → fix it in the same turn, verify (measure/playwright), then one line saying what changed. Zero prose agreeing with the callout, zero option menus for the fix, zero explanation of why the broken version happened unless asked "why". Exceptions: a fix that lands outside my scope (another repo's package, a design ruling) still gets filed/logged rather than narrated — see [[feedback_own_it_move_on]], [[feedback_no_unrequested_options]], [[feedback_lead_first]].
