---
name: feedback_two_subjects_two_sections
description: "One reply covering two separate things splits on the breather with both sections numbered and titled — never two tables butted together"
metadata:
  type: feedback
---

When a reply covers **two separate subjects**, do not stack two tables. Two tables with nothing
between them read as one continuous list of peers.

```
<lead — names BOTH subjects and says there are two>

**1 · <first subject>**
<its table>

__________

**2 · <second subject>**
<its table>
```

- **The lead announces the count** — he knows there are two before the first table.
- **Number and title each section** (`1 ·` / `2 ·`). A bare rule line says *something changed* without saying what.
- **Two is the ceiling.** Three subjects is two replies, or one reply whose real subject is what they have in common.
- **Reuse the breather** — the two-blank / two-`__________` / two-blank block the header card already uses. Do not invent a separator.
- This is a **body** break: it does not touch the footer or the where-we-are module, so the cross-repo `footer-gate.sh` is unaffected.

**Why:** 2026-08-01 — *"I guestion inserting 2 tsbles, if 2 issues in one respoonse OI think use intro
brether module and make super clear that 2 seperate things are bing listed."* Said of a reply that
reported a lobby-protocol change and a docs-framework change as adjacent tables under one title.

**How to apply:** count the subjects before writing. More than one → breather between them, both
numbered, and the lead states the count. Spec: `08-formats/03-body.md` § Two subjects, two sections.
Sibling: [[feedback_rank_or_its_noise]].
