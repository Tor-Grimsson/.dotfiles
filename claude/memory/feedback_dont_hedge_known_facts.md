---
name: dont-hedge-known-facts
description: "Don't present facts already established in loaded session context as tentative; state them as settled"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 266ef8cf-c005-4468-a753-d554c4784fdf
---

Don't hedge on facts already established in loaded context (`AGENT-CONTEXT.md`, session logs, or earlier in the same conversation) — state them as settled, not as a fresh inference.

**Why:** Called out sharply ("goldfish donut") after saying acyr's tmux clipboard config "should be covered since you just synced" — when the just-loaded AGENT-CONTEXT session log (read at [[agent-init]] time, same session) had already confirmed acyr fully synced to origin after an hour-long rebase resolution. Hedging on a fact read moments earlier reads as not having retained it.

**How to apply:** `/agent-init` loads ARCHITECTURE/AGENT-CONTEXT/session-log at session start — treat facts stated there as ground truth for the rest of the session, not things to re-verify or hedge on. Only hedge when something is genuinely unconfirmed (not yet verified live) or explicitly marked stale ("Open" item, "not yet done") in that same context.
