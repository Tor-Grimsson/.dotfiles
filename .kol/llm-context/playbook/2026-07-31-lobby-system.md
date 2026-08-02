# Playbook — the lobby system (cross-repo tickets)

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Session log: `session-log/2026-07-31-desk-scoping-ref-help-crash-safety.md`. Prior arc: ref-card system 🏁.

**Goal:** Turn the ad-hoc `lobby/` folders into a real system — one ledger law, four connected repos, a `lobby-*` skill family that ports a *conversation* (not just a screenshot), a docs home on the systems shelf, and a ref card.

**Standing rules (non-negotiable):**
- The ledger is the truth, never a raw `ls`.
- The ticket closes the SAME turn the work closes.
- Open · closed · stale · parked is the **user's** call, never the agent's.
- No entry without a ledger row.
- No git, no provisioning.

---
## Entries

[~15:40 GMT · 2026-07-31] · rosa · inventory before touching anything
  what → 4 skills (lobby read · kol-lobby DS-write · kol-lobby-icon · kol-lobby-hygiene) · 1 script (clip-drop.sh) · 4 registered lobbies · 2 INCOMPATIBLE ledger dialects
  found → humpty tracks EVIDENCE (filed→researched→addressed→verified), kol-ds-ui tracks AUTHORITY (parked/USER RULING/NEEDS RULING) — not competing, **perpendicular**
  found → 9 gaps: no conversation→task writer · clip-drop never touches a ledger (grep INDEX|LEDGER = 0) · hygiene reads INDEX.md but humpty's is LEDGER.md · /lobby's known-lobbies table 3 rows vs 4 · no shared vocabulary · "stale" undefined · 2 lobbies with no ledger table · kol- prefix means 2 different things
  proof of the clip-drop gap → kol-website's `ShowSansItalicDisplay.md` existed with NO row

[~16:10] · rosa · the 10th gap, and it was load-bearing
  found → `/kol-lobby` + `/kol-lobby-icon` both write to `kol-apparat/kol-design-system` — **the path does not exist**; repo renamed to `kol-ds-ui`
  found → 6 skills carried the dead path (kol-lobby, kol-lobby-icon, claude-kol-ds, scaffold-dev-stack-kol, kol-press-research, kol-type-conform)
  note → everything else was decoration while the writers pointed at nothing; this went first

[~16:30] · design · the protocol, settled
  decided → ONE ladder (filed→read→addressed→closed, + parked) · ONE orthogonal flag (needs-ruling) · ONE repo-local BAR for what closed COSTS
  decided → humpty's `verified` bar (a measurement in 06-measure/_results/) is the estate's strictest and STAYS; its state names stay too, only the emoji are shared
  decided → user: `lobby/inbox/` as the destination so INDEX.md can be the single ledger at root · emoji states · `/lobby-web` + `/lobby-ds` as the short names
  decided → drop the "quick-ref" doc — `ref-lobby` owns that; systems INDEX law is "nothing is written twice". Add `01-registry` instead (the most common real question: what belongs where)
  rejected → merging the two dialects into one list — loses an axis either way

[~17:00] · build · phase 1 shipped
  what → dead path killed across 6 skills, with a tombstone note in both lobby writers
  what → `inbox/` + `done/` + `archive/` + `_assets/` in all 4 lobbies; 11 entries moved
  what → 4 ledgers on emoji states — dotfiles + kol-website rewritten from scratch; humpty's LEDGER.md and kol-ds-ui's INDEX.md given the emoji column + inbox links + a history line WITHOUT touching a single existing ruling
  what → docs/operations/systems/lobby/ — INDEX · 01-registry · 02-lifecycle · 03-tooling · 04-conventions · 05-lookup; 8th system on the shelf
  what → ref/lobby.md + bin/ref-lobby (cards 16→17) · ref-skill § lobby de-staled

[~17:30] · block · the gate deadlock
  hit → humpty `/rosa` re-armed MID-BUILD with no prompt carrying it; then `/jana` did the same
  hit → goal-loop Stop hook forbids stopping; jana forbids tool calls; `/kol-goal blocked` needs a Write → **no legal move**, 11 iterations burned
  note → this IS `hook-deafness` reproducing live. Worth its own humpty brief: a self-arming mode gate against a no-stop Stop hook produces an agent that can neither work nor quit
  fix → user's next message cleared it (mode is turn-scoped); `$humpty 2` is the manual release

[~18:10] · build · phase 2 shipped, arc closed
  what → skills renamed: lobby-list · lobby-ds · lobby-icon · lobby-hygiene (kol- prefix dropped — it meant "DS-specific" in two and "generic" in a third)
  what → 4 NEW: `/lobby` router (AskUserQuestion, 2 steps + all-queues sweep) · `/lobby-dotfiles` · `/lobby-humpty` (verbatim-quote rule) · `/lobby-web` (the consumer test: is this really the site's, or a package's?)
  what → `bin/lobby` — registry-driven, `--counts`/`--paths`, fzf + glow preview, detects INDEX.md vs LEDGER.md; `prefix Ctrl+K`
  what → `clip-drop.sh` writes to `inbox/` AND appends a 🔵 filed row — closes the no-entry-without-a-row gap at the source
  what → `g-nav-dead-targets` filed as the first ticket written THROUGH the system: gapparat 12/12 · gclient 8/8 · gdev 6/7 targets dead (`kol-apparat/` and `kol-client/` don't exist)
  gates → 17 cards render · 5 filters hit · 6 scripts pass syntax · sweep reads all 4 lobbies · 8 skills resolve · stale `kol-lobby` refs swept from kolds + claude-harness

[~19:40] · cards · the spacer ruling, and a 385-row sweep
  ruling → user: "I proposed line breaks for CATEGORIES/SECTIONS within a table, as breathers" — not between every row
  found → 12 of 16 cards were EVERY-ROW (ratio 0.60–0.76 blank:content); ref-nvim alone carried 123 spacers
  what → stripped 385 spacer rows across 13 cards; backup in scratchpad first; all 17 render, 10 filters re-tested, 0 regressions
  what → ref/lobby.md 103→51 lines, 7→4 sections — law/bar/entry cut (43 lines of doctrine already verbatim in docs/operations/systems/lobby/02-lifecycle + 04-conventions)
  what → ref/llm.md + ref/textmodes.md rewritten to the same shape
  root → the every-row habit was DOCUMENTED: "spacer row between data rows" in 02-cards.md, echoed in 01-system, 03-glow, INDEX and the ref-add skill. Corrected all 5 — fixing the cards without fixing the spec would have regrown it
  note → measurement bug caught mid-flight: my first ratio script scored every card 0.00 because the separator regex (`[\s:|-]+`) also matched blank rows and `continue`d first. Required a dash to be present. Never trust a sweep that reports all-zero

[~19:55] · nvim · md/mc/mp
  what → <leader>md = markdown mode (was mm, a meaningless letter), <leader>mc = conceal toggle (was md), mp unchanged
  why → the pair had to split by WHERE each works: md lives in core/keymaps.lua because it must fire on a buffer that is not markdown yet; mc stays in after/ftplugin/markdown.lua because it is meaningless until markdown is on. Chicken-and-egg, now stated in the doc
  gate → verified headless on an unnamed buffer: md → ft=markdown wrap=true conceal=2, then mc → conceal=0
