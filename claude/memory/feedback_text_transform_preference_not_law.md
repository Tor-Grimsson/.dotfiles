---
name: feedback-text-transform-preference-not-law
description: The no-auto-text-transform rule is a soft preference, not law — never flag existing uppercase/transform usage as a violation
metadata:
  type: feedback
---

The "no auto text-transform" guidance (CLAUDE.md) is a restrictive default for NEW component authoring, not a conformance law. Existing `uppercase` utilities / `text-transform` in markup or DS classes are not violations and must not be flagged, reported, or "carried" as findings.

**Why:** 2026-07-28, after I flagged a Tailwind `uppercase` on a typeface name as breaking "the no-transform law": "I think this law you mention is outdated, or at least wasn't meant as the word of god. it's a restrictive thing."

**How to apply:** Don't audit for text-transform. When authoring new components, still prefer authored-case strings; when the user or existing code uses transforms, that's design intent — leave it and say nothing.
