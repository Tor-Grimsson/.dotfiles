---
name: drop-resolved-tangents
description: "Once a workaround/fix closes a problem, stop elaborating on the underlying mechanism — answer follow-ups on it minimally or flag the irrelevance instead of chasing the thread"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 266ef8cf-c005-4468-a753-d554c4784fdf
---

When the user confirms a workaround already resolves an issue (e.g. "yank works with v mode, don't need any clipboard provider tools"), the underlying broken mechanism (nvim's own `unnamedplus`/`dd`/`y` register path, in that case) is now moot for their actual workflow. A literal follow-up question about that mechanism ("is `dd` also yank?", "are those normal mode?") can still get answered, but answering it flatly — without noting it no longer matters — just keeps a dead thread unwinding.

**Why:** Called out directly: "so you are just creating noise, as we have just been talking about visual mode yank." Two follow-up turns spent on nvim's normal-mode `dd`/`x`/`cw`/`daw` semantics were technically correct but disconnected from the resolved problem (tmux visual-mode copy, not nvim's internal registers).

**How to apply:** After a topic is confirmed resolved/moot, either (a) answer a direct follow-up in one line and explicitly tag it as no-longer-relevant, or (b) ask whether they want the tangent at all before elaborating. Related: [[feedback_terse_verdict_first]] (bare verdicts on sanity checks) — this is the same over-explaining instinct applied to *drifting into resolved side-topics* rather than justifying an answer.
