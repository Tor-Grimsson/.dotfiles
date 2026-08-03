# 🏁 Milestone: humpty published, installed and verified on both machines

**Date:** 2026-08-03
**Agent:** Claude Code (Grim) — MBP
**Arc:** Get agent behaviour out of `~/.dotfiles/claude/hooks/` and into a plugin that installs anywhere, then prove it on a machine with no dev checkout.
**Delivered:** `humpty@humpty` v0.5.0 installs itself from the shared settings on any machine that pulls dotfiles, and both enforcement gates were confirmed denying live on the MBP. The arc's last stale doc and its one outstanding lobby remainder are closed.

## What closed

- **MBP install** → done. Not by running the handoff's `/plugin install`: `claude/settings.json` declares `extraKnownMarketplaces.humpty` (`github: Tor-Grimsson/ubu-roi`) plus `enabledPlugins["humpty@humpty"]`, so the startup after the pull fetched and cached it unaided. The handoff's step 3 was dead wiring — its own settings change had already automated it.
- **The untested fallback path** → done, and it was the thing the handoff called most likely to surprise. This machine has no `kol-dumpty/` at all, so `bin/kol-statusline` had to fall through to `~/.claude/plugins/cache/humpty/humpty/0.5.0/bin/humpty-statusline`. It did.
- **Gate verification** → both deny. `humpty-gate` refused a gated read with the unlock hint; `humpty-rm` refused `rm -rf` against a repo path with the full NOTHING IS DELETED law.
- **Statusline `:strict` suffix** → not a defect, closed as correct. The suffix renders only for levels 1/3/4; level 2 (standard, the default) prints the bare name. Dial since set to strict (3/4).
- **`docs/operations/systems/agent-system/12-setup-a-to-z.md`** → corrected, was marked needs-a-pass. §2 now documents the declarative install (and the `settings.local.json` dev override whose *absence* is the correct state elsewhere); §7 repoints the statusline from the retired `claude/hooks/statusline.sh` to `bin/kol-statusline`, and says why it is a locator rather than the renderer.
- **Lobby receipt `mode-self-arms-from-its-own-docs`** → 📌 remainder closed. `claude/skills/yona/SKILL.md:23` claimed a gate enforced the mode; that gate was removed 2026-08-01, so a file read as law had carried a false sentence for two days. Rewritten. Humpty's own ledger row untouched — the user's call, unchanged.
- **18 skills shadowed in both repos** → parked, `llm-plan/01-parking-lot.md`. Explicitly the user's ruling, twice unmade.
- **8 concepts, 0 packaged** → parked, same file. Deferred by the user twice; the arc shipped without them.
- **Seven TUI file managers on trial** → parked, same file. Carried unchanged from 2026-08-01; not a task until the user says so.

## The arc (brief)

- Agent behaviour left `claude/hooks/` entirely — 7 hooks + the statusline moved to humpty, `settings.json` lost its `hooks` key (`session-log/2026-08-03-agent-behaviour-consolidation-to-humpty.md`).
- `bin/humpty-payload` was written to *generate* the public surface rather than hand-copy it, gated on five pre-flight checks; skills were cut 35 → 18, and running the payload standalone caught 11 asserts the dev repo passes (`session-log/2026-08-03-ubu-roi-published-marketplace-split.md`).
- The recurring failure mode across the whole arc: **a skill or hook pointing at something that does not ship.** Eight `output-l*` skills pointed at a register in `docs/`; `humpty_stop.py` imported from `docs/` too. Both would have been broken on any marketplace install.
- This session closed it from the other side — the consumer machine — which is the only place the packaging claim could actually be tested.
- One correction of my own worth keeping: the first delete-gate probe targeted `/tmp/`, which is on the gate's scratch allowlist. It permitted correctly; the probe was wrong. Re-probed against a repo path.
