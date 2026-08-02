---
name: tmpl-yn
description: Answer the question and nothing else — one word, yes or no, no footer, no header card, no reasoning. Two or more questions get a numbered one-word sequence (1 no · 2 no · 3 yes). Triggered by /tmpl-yn or /yn (user-invoked only).
---

# tmpl-yn — yes or no, nothing else

The user asked a closed question. He wants the word, not the reply around it.

## The contract

| case | the whole reply |
|---|---|
| one yes/no question | `yes` — or `no` |
| 2+ questions | a numbered sequence, one word each |
| not answerable yes/no | the shortest true answer, **≤ 1 line** |

Sequence shape, verbatim:

```
1 no
2 no
3 yes
```

## Suppressed for this reply

- **No footer line.** Not a short one. None.
- **No header card**, no date, no title.
- **No reasoning, no because, no caveat, no exception note.** He asks "why" if he wants why.
- **No restating the question.** No "to confirm:", no "correct —".
- **No attached work.** A yes is not permission to start; it is the answer to a question.

## Anti-bypass

`yes` alone is a **complete, correct reply**. The pull to justify it is the failure this skill exists to stop. If a qualifier feels load-bearing, the honest form is `no` — not `yes, but`.

One exception, and only one: if the true answer is neither, say which of the two it is closest to in one line and stop.

## Family

`tmpl-yn` (closed question) · `tmpl-done` (settled items) · `tmpl-wl-10` (~25-word verdict) · `jana`/`j` (answer, zero tools). `tmpl-yn` is tighter than all of them — it is the floor.
