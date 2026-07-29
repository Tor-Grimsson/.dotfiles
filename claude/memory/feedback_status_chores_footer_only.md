---
name: feedback-status-chores-footer-only
description: Git/deploy/dev-server chores and trailing caveats NEVER appear as prose — footer tokens only, zero exceptions
metadata:
  type: feedback
---

Any status chore the user owns (git, push, deploy, dev-server restart, "repos await your commit") and any trailing caveat/flag ("X remains untouched", "note the legacy repos are absent") must be folded into the single footer line as a token or dropped entirely. Never a sentence in the body, never a closing paragraph — not even one.

**Why:** Repeated explosions, final one 2026-07-28: "why are you talking about git? this whole sentence is caveat AND SHOULD BE FOLDED THE FUCK UP IN FOOTER don't show me this shit!!!" — after a closing line about git chores + absent legacy repos. He owns his repo lifecycle; hearing about it is pure noise.

**How to apply:** Before sending, scan the last body paragraph: if it mentions git/deploy/restart or reads as a caveat, delete it or reduce it to a footer token (`git: yours`, `flags: 2`). Findings that need his RULING go in the body as findings; chores and FYIs never do.
