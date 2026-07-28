---
name: feedback-terse-verdict-first
description: "For yes/no or \"does this make sense\" sanity-check questions, give the bare verdict — no justification paragraph unless asked why"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 87a3f20f-1f69-4b8b-92a6-f75f27aadd7a
---

When the user asks a sanity-check question about an existing design ("wouldn't it make sense if X went to Y instead?", "is this logical?"), answer with the verdict alone ("No — root is correct.") and stop. Do not append the reasoning paragraph even at the "one sentence of why" size global CLAUDE.md normally calls for.

**Why:** Told directly — "so no and then just an avalanche of text?? I dont need that 'no' was enough" — after a reply that led with "No" but followed with four paragraphs on PATH/circularity/dotfiles conventions. The verdict was the answer; the reasoning was unwanted overhead, not confirmation-checkpoint material.

**How to apply:** If they push back or ask "why" after the verdict, give the reasoning then — don't front-load it. This is stricter than the global "pick one, one sentence of why" rule for this user in this kind of exchange; when in doubt on a pure sanity-check question, cut the sentence of why and wait to see if it's wanted. Related: [[feedback_no_unrequested_options]] (same instinct — don't pad a direct answer).
