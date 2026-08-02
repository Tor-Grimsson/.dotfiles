# 🏁 Milestone: the lobby system — cross-repo tickets with a ledger law

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Arc:** Turn four ad-hoc `lobby/` folders into one system — a ticket protocol, a docs home on the systems shelf, a `lobby-*` skill family that ports a conversation rather than a screenshot, and a card.
**Delivered:** 8 skills, 6 docs, 1 card, 1 script, 4 restructured lobbies, and a state protocol that absorbs both pre-existing dialects instead of overwriting either.

## What closed

- **No conversation→task writer** → **done.** Four writers (`/lobby-dotfiles` · `/lobby-humpty` · `/lobby-web` · `/lobby-ds`), each carrying the destination's own rules — humpty's verbatim-quote law, kol-website's consumer test, kol-ds-ui's spec-not-source rule.
- **Two incompatible ledger dialects** → **resolved, not flattened.** They were perpendicular axes: humpty tracked *evidence* (`filed→researched→addressed→verified`), kol-ds-ui tracked *authority* (`NEEDS RULING`/`parked`). The protocol keeps both — one ladder 🔵🟡🟠🟢⚪, one orthogonal 🔴 `needs-ruling` flag, and a **bar for closing set per repo**. humpty's measurement bar survives untouched as the estate's strictest.
- **`clip-drop.sh` never wrote a ledger row** → **done.** It now writes to `inbox/` and appends 🔵 `filed` in the same action. The gap that left `ShowSansItalicDisplay` invisible for a day is closed at the source.
- **Readers knew only `INDEX.md`** → **done.** `/lobby-list`, `/lobby-hygiene`, the router and `bin/lobby` all check `LEDGER.md` too.
- **`/lobby`'s known-lobbies table 3 rows behind reality** → **done.** Everything reads the registry (`files/folders.md` § lobby); nothing carries a copy — the same drift class that had cost `ref-pick` three cards.
- **`kol-` prefix meant two different things** → **done.** Family renamed to `lobby-*`; the suffix is the destination.
- **`/lobby-ds` and `/lobby-icon` wrote to a path that does not exist** → **done.** `kol-apparat/kol-design-system` was dead; repointed to `kol-ds-ui` across **6** skills. This went first — everything else was decoration while the writers pointed at nothing.
- **"Stale" undefined** → **done.** `staged:` on every entry, 30/90-day thresholds that *surface candidates only*. Law 4 holds: stale is the user's call.
- **Two lobbies had no ledger table** → **done.** dotfiles and kol-website rewritten; all four now carry States · Queue · Closed · Archived · History.
- **Skills renamed but bodies left describing the old layout** → **done.** Caught on audit after I'd already called the arc finished; 5 skill bodies plus `files/folders.md` and `docs/INDEX.md` repaired.
- **Magnet's 11 contested `ctrl-alt` chords** (carried in from the desk arc) → **closed as not-a-problem**, user's ruling: AeroSpace registers first and wins, so nothing misfires.

## The arc (brief)

- Opened on "improve the lobby system, cross-repo messages with context". The read-only sweep found 4 skills, 1 script, 4 lobbies — and 10 gaps, the worst being that both design-system writers pointed at a repo that had been renamed months earlier.
- The design insight was refusing to pick a winner between the two ledger dialects. They measure different things; collapsing them would have lost an axis whichever way it went.
- A humpty mode gate (`/rosa`, then `/jana`) self-armed mid-build against the `goal-loop` Stop hook, producing an agent that could neither work nor quit — `hook-deafness` reproducing live, 11 iterations burned. Worth its own brief.
- The last failure was mine and instructive: asked "everything done?", I audited, found 5 stale skills, and *reported* instead of fixing. The audit was right; stopping at it was not.
- Spans `playbook/2026-07-31-lobby-system.md` and `session-log/2026-07-31-desk-scoping-ref-help-crash-safety.md`.

**No open threads.**
