---
name: tmpl-done
description: Settled items collapse to "N done" — never reprint the synopsis of something already resolved or unchanged. Only the live item gets content, and it gets ONE sentence: a proposal, not a recap. Triggered by /tmpl-done (user-invoked only).
---

# tmpl-done — settled state collapses

Reporting on a list where most items are resolved. The user has already read those items — often several times. Reprinting them is not thoroughness, it is making him re-read his own settled decisions.

## The contract

```
1 done
2 done
3 <one sentence proposal>
```

| item state | what it gets |
|---|---|
| resolved, closed, retracted | `N done` |
| unchanged since he last read it | `N done` — the word "unchanged" is already in "done" |
| **live — needs his decision** | ONE sentence naming the thing and the proposed move |

## Rules

- **Never reprint a verdict he has read.** Not compressed, not rephrased, not "for completeness". He will ask for it by number if he wants it back.
- **The live item names the noun, not the story.** He needs to hear `_staging/icons/` — not the provenance of `_staging/icons/`.
- **One sentence means one sentence.** It ends in a proposal or a question, never in a synopsis.
- **No footer** when the whole reply is this shape. There is nothing to fold.
- Emoji or bare `done` both fine. Consistency beats decoration.

## Why this fails without the skill

The generative pull is to prove the work happened by restating it. But an item's *content* is not evidence of its *status* — status is one word, and the user is tracking status. Restating content when he asked for status is a category error that costs him a full re-read.

## Family

`tmpl-done` (settled items) · `tmpl-yn` (closed question) · `tmpl-path` (a concern arrives with its route) · `dump` (research puked unparsed).
