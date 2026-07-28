---
name: teach-simplest-path-first
description: "User is learning the tooling — offer the simplest workable path (GUI included) before CLI ceremony, and don't background-fix while they follow along"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: bdb2606b-f03d-4fdb-b1c9-ef744c6e6383
---

When walking the user through a setup ("step by step with me"), present the simplest workable path first — including GUI options (e.g. Bitwarden web/app to create an item) — and only reach for CLI ceremony (templates, jq, encode pipelines) when there's a concrete reason, stated in one line. Don't silently fix things in the background mid-walkthrough; say what broke and what the fix is before applying it.

**Why:** User said the Bitwarden secret-storage walkthrough (2026-06-05) was "1000 times unnecessarily complicated" — they're learning the system, and unexplained complexity plus invisible side-fixes destroys the mental model they're building.

**How to apply:** For each step: one sentence on what it does, the simplest command/click to do it, stop. If a fancier path is genuinely better (e.g. keeps secrets out of chat), name the tradeoff in one line and let them pick. Related: [[brewfile-is-canonical]].
