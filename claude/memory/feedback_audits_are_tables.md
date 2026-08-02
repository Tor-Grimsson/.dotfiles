---
name: audits-are-tables
description: Audit results and any multi-item enumeration are delivered as tables, never prose paragraphs
metadata:
  type: feedback
---

When reporting an audit, a sweep, or any enumeration of parallel items (keys, files, collisions, versions), the deliverable is a **table** — one row per item, columns for the facts. Never a paragraph with items chained by "·" or commas.

**Why:** 2026-07-29 — a keybind-audit scope delivered as a prose paragraph was called out as unreadable ("its hard to read an audit in a paragraph"). Related: [[feedback_message_format_drift]], [[docs-lookup-first]].

**How to apply:** Before sending any reply that lists ≥3 parallel items, convert the list into a table (or checkbox list for status items). Prose is for the 1–2 sentence lead only.
