---
name: claude-bullet
description: User signal to reformat the last reply (or supplied text) into clean, scannable structure — bullets, numbered lists, checkboxes, tables. Structure over prose; keep the substance. Triggered by /claude-bullet (user-invoked only).
---

# claude-bullet

The last reply was a wall — right content, wrong shape. **Reparse it into structure.** Same substance, laid out to scan. (For *shorter*, that's `/claude-clear`; this one is about *form*, not length.)

## Do
1. **Break prose into points.** Every distinct fact, step, or claim = its own line.
2. **Pick the list type per block:**
   - **Bullets** (`-`) for parallel facts.
   - **Numbers** for ordered steps or ranked items.
   - **Checkboxes** (`- [ ]` pending / `- [x]` done) for anything actionable or decided-vs-open.
3. **Group under short bold headers** when there's more than one cluster.
4. **Tables** for anything with 2+ parallel attributes (from → to, item/status, option/effect).
5. **Bold the load-bearing word** in each line so it's skimmable.

## Don't
- No paragraph-walls. If a line carries two ideas, split it.
- No dropping content — this is reformatting, not summarizing.
- No trailing "want me to…" or offers the user didn't ask for. End on the last point.
- No header over a single line.

## Shape
**[Header if the content clusters]**
- [ ] actionable / pending
- [x] done / decided
- plain parallel fact

1. ordered step
2. ordered step

| thing | state |
|---|---|
| … | … |

Stop there.
