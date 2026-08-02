---
name: dump
description: User signal that the last reply was a RESEARCH DUMP — findings puked unparsed, the answer buried under evidence, defect walls and option lists the user has to mine themselves. Re-emit as a verdict first, then at most one supporting block. Triggered by /dump (user-invoked only).
---

# dump — you puked the data instead of parsing it

The failure this names: research came back, and instead of **answering the question**, the agent printed everything it found — defect walls, gap tables, numbered paths, "one thing needs your ruling" — leaving the user to do the parsing the agent was asked to do.

Related but different: `/stfu` = human-coded noise (validation, apology, emotional handling). `/dump` = *technical* noise — real findings, zero synthesis.

## Re-emit shape

1. **The verdict, one line.** What is true / what to do. Not "here's what I found".
2. **At most ONE supporting block** — the table or list that carries the decision. Everything else is dropped, not folded, not appendixed.
3. **Say what you already know is the user's call** in one line, if any. No menus, no "my instinct is…" essays.
4. Paths and line numbers only where the user must go there themselves.

## The laws underneath it

- **Findings are not a report.** Research output is raw material; the deliverable is the conclusion drawn from it.
- **The user knows their own repos.** Do not narrate what they built back to them as discovery. If they said they know, they know.
- **Volume is not rigor.** Ten defects listed is not better than the one that blocks them.
- **Lead with the answer, always** — burying it under evidence is the same failure as burying it under prose.

## After a /dump call

The next reply re-emits the substance in ≤ 8 lines unless the user asks to expand. If a real fork exists, it is ONE question line at the end — never a survey.
