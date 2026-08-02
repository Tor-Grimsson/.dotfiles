---
name: feedback_examples_are_copy_pasteable
description: "Examples must be typeable verbatim — never a `$` prompt prefix or any convention the reader has to strip before the line works"
metadata:
  node_type: memory
  type: feedback
---

Write every command example so it can be copied and run as-is. **No `$` prompt prefix, no `>` continuation markers, no `user@host:~$`.** If command and output must both be shown, label them in a table or put the output in a separate block — never inside the same block behind a sigil the reader must mentally remove.

**Why:** 2026-08-01, in an `emo`/`emojify` walkthrough written *because* the user asked for examples, every line was prefixed `$`. He then had to ask what `$` meant — *"funny to give examples to someone learning adding stuff he should know to retract? what the logic here just mayhem?"* An example that needs decoding is not an example; it silently assumes the exact knowledge the example exists to supply.

**How to apply:** Command block = only commands, ready to paste. Output goes in its own block or a two-column table (`type this` / `you get`). Applies to chat replies, docs, and ref cards alike. Related: [[teach-simplest-path-first]], [[feedback_clarity_over_cleverness]].
