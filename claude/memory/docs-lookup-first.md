---
name: docs-lookup-first
description: "Reference/tool docs must be lookup-first (tables, steps, commands up top), narrative prose below; dependencies stated head-on in a table"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c4e36298-b1c2-4906-bbc4-03cff86bfcb7
---

Tool/reference docs: lookup material first — short summary, deps table (command → does → needs), numbered setup steps, commands block, flags table — then any why/win/future narrative at the bottom. Dependencies must be spelled out explicitly in a table, never sideways in prose ("plays via mpv" buried in a sentence reads as "different deps").

**Why:** edge-tts doc (2026-06-06, ~/.dotfiles) took 3 rewrites — first essay-prose, then lookup-only, user landed on "both is better, lookup in the front then more detail as you go" and was confused by a dependency mentioned in passing.

**How to apply:** in any doc with an install/usage component, lead with scannable tables and numbered steps; one explicit "what needs what" table when a package ships multiple commands or has runtime deps. Canonical example: `~/.dotfiles/docs/06-media-av/06-edge-tts.md`. Also recorded as a contract in that repo's AGENT-CONTEXT.md.
