# Playbook — agent-behaviour consolidation (dotfiles → humpty)

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`. Prior arcs: agent-system outline 🏁 · humpty v1→v4 (in humpty's own playbook).

**Goal:** Every piece of agent-behaviour machinery currently split between `~/.dotfiles/claude/` and `kol-dumpty/humpty/` lands in **humpty**. Dotfiles keeps only what is bound to this machine or to KOL. Three systems that must stay in dotfiles as live instances — lobby, agent-drop/`_inbox`, log-work/init — additionally get extracted as **shippable concept packages**.

**Standing rules (non-negotiable):**
- Sorting criterion is **"is it agent behaviour?"**, never "is it a duplicate?" — duplication is evidence the split was accidental, not the test.
- Nothing is deleted. Dotfiles originals go to `_tmp/<date>-<what>/`.
- Repo publishing/visibility is **out of scope** — decided later, not this arc.
- `statusline.sh` moves (it reads humpty's own `.humpty-active`); `jq` dependency accepted by the user, overriding humpty's zero-dependency stance.
- No git, no provisioning.

---
## Entries

[07:03 GMT · 2026-08-03] · setup · playbook + goal armed
  what → new playbook (successor to the 2026-07-28 agent-system outline arc) · `/kol-goal` armed, 13 items, max 30
  what → inventory settled across 7 turns of research: hooks 7 (6 move + statusline now 7th) · skills ~35 move of 70 · scripts 1 merge (`agent-grant`→`humpty-grant`) · 3 concept packages
  note → two findings that changed the plan: `rm-gate.sh` is registered NOWHERE (`grep -rn` = 0 hits) so the never-delete law is prose-only; `goal-loop.sh:45` hardcodes `cwd/.kol/llm-context/` and needs memory-glass's `TIER_DIR` seam to ship
  note → user corrections logged: routing work to jabberwocky was wrong (it is a sibling repo, not a destination) — the model is **stays in dotfiles AND ships as a concept**; and statusline was wrongly kept in dotfiles by quoting humpty's own `sl-ponytail/04` verdict instead of reading the file
  note → the install mechanism for the statusline badge is ponytail's self-install nudge, already on humpty's owed-debt list (`11-verdict-ledger.md`) — a plugin cannot write `settings.json`'s `statusLine` key itself

[07:15] · T1-T4 · token gate genericized · 4 hooks ported · 2 merges closed ✓
  what → T1 `humpty_tokens.py` off hardcoded `--kol-*`: namespace is now DISCOVERED (dominant `--<ns>-*` in the repo), `VENDOR_NS` skips tailwind/webkit internals so a Tailwind repo is not told to reuse `--tw-ring`. Verified live: an `--acme-*` repo now gates, which the old version silently never did
  what → T2 dangling `~/.dotfiles/...` pointer cut from `skills/laws/SKILL.md`; `grep` for personal paths across skills/commands/hooks/bin/manifest/README = 0 hits
  what → T3 the `.kol` hardcode is a SEAM now — `HUMPTY_CTX_DIR` (memory-glass's `TIER_DIR` pattern, referenced not invented), fixed in BOTH places: `goal-loop.sh:45` and `humpty_lib.ESCAPE_PATHS`; escape hatch keeps a bare-filename fallback so it matches under any convention
  what → T4 ported to humpty's wrapper+py pair convention, each unit-tested: `humpty_footer` (4/4 cases) · `humpty_goal` (4/4: active-blocks · foreign-session-inert · done-with-unticked-REFUSED · cap-releases) · `humpty_rm` (7/7) · `humpty_docsync` (2/2)
  note → git-gate is SUPERSEDED, not ported — `humpty_gate.py` is strictly broader (4 pipelines vs 2, off|read|full vs binary). It had ONE thing humpty lacked: command-substitution detection. Ported as `SUBST` → downgrades to `ask`, verified `git status`=allow · `git status $(curl …)`=ask · `git commit`=deny
  note → agent-reinforce's MECHANISM is redundant (humpty_track already injects on cadence, and drift-proof from SKILL.md). Its PAYLOAD had 6 rules SKILL.md lacked — never-mention-git, one-record-is-a-label-block, sentence case, sync-docs-same-turn, ports-task-scoped, the .kol/docs audience split — all folded into the level=2 inject block + the compact cadence. All 11 marker blocks still parse, levels cumulative (1→633w, 4→2381w)
  note → two more proofs the split was accidental: `humpty_lib.NOT_THE_USER` already filters `goal-loop|footer-gate` by name, and `ESCAPE_PATHS` existed only to keep goal-loop's escape writable. humpty was already maintaining state for hooks it did not ship

[07:29] · T5-T14 · consolidation COMPLETE · fixtures 192/0 ✓
  what → T5 `statusline.sh` → `bin/humpty-statusline`; renders identically to the user's screenshot, grant badge now names EACH open pipeline (`[GRANT git,downloads 5m]`) instead of implying only git
  what → T6 self-install nudge in `humpty_activate.py` — ponytail's idea, owed since `sl-ponytail/04`, taken. Reads settings.json, stays silent when `statusLine` is set, emits the exact key when unset. A NUDGE, never a write; ponytail's `isShellSafe` allowlist reused for the embedded path
  what → T7 `rm-gate` registered for the FIRST TIME. T8 `agent-grant` superseded by `humpty-grant` (same interface, per-pipeline); tmux `prefix g` + `ref/humpty.md` + `ref/tmux.md` repointed, `ref --lint` 17 cards clean
  what → T9 35 skills COPIED (not moved) into humpty/skills — 37 total, all frontmatter valid, token screen clean. `output/SKILL.md` had 3 personal paths, genericized
  what → T10 the whole `hooks` key removed from `settings.json` (diff verified: only `hooks` removed, only `statusLine` changed, permissions + plugins byte-identical) · T11 11 files quarantined with a receipt table
  what → T13 `concepts/` — 3 specs (lobby · drop-queue · journal), each naming its seams and its live instance. Pattern ≠ instance; that split is the rule the whole arc produced
  what → T14 humpty README anatomy resynced (6 events, 4 new engine files, statusline + concepts rows); dotfiles AGENT-CONTEXT chain +1, trimmed to 5
  note → **fixtures found a fake pass.** Group 13's `mode()` helper was never defined — `command not found` left `$out` empty and `[ -z "$out" ]` read that as OK. Four asserts, green, testing nothing. First fix pointed at `humpty_mode.py`, which does NOT exist (quarantined 2026-08-01); `2>/dev/null` hid that and the asserts stayed vacuous. Correct fix: point at `humpty-mode.sh`, the deliberate tombstone, so the assert verifies it STAYS inert
  note → closed the lobby receipt's 📌 remainder in passing: `yona/SKILL.md:23` plus TWO injected cadence blocks (jana, rosa) claimed "the gate enforces it". No gate since 2026-08-01 — the injected text was lying to the model every session. Zero false enforcement claims left in shipped text
  note → OPEN, user's call: the 35 skills are live in BOTH places. A plugin skill is namespaced, so shipping them renames `/tmpl-clear` → `/humpty:tmpl-clear`. Copied rather than moved so he decides, not me
  note → hooks are DEAD until a restart: `settings.json` no longer registers them and `hooks.json` is only read at plugin load

[08:30] · phase 2 · scope set — packages, memory drift, the unexamined suite
  what → arc continues; /kol-goal re-armed with 12 items covering what the consolidation surfaced but did not touch
  note → **the rule for this phase, from the user:** a thing SHIPS as a concept AND keeps its dotfiles copy. No moving the sisters into the plugin — that is what broke jana/rosa/yona. Duplicate copies across repos are fine and explicitly not a concern
  note → memory-glass is NOT verified current: last touched 2026-07-28, and live sampling shows only 2 of 6 project memory dirs are symlinks — `sync.sh` has not been re-run as repos were added. The repo describes a system only partially applied
  note → `docs/operations/systems/agent-system/` is 13 docs, the original design suite jabberwocky was exported FROM, never examined since. Includes `10-naming.md` (the Glass/Ubu/Alice three-family system). Its canon-vs-superseded status is the biggest unexamined thing left
  note → corrected scope: `claude-npm` + `upig` are publishing-specific (pnpm vs the registry), NOT generic and NOT design-system — their own group. `export-specs` ships as a concept. DS skills (`claude-kol-ds`, `kolds`, `kolds-ref`) skipped

[08:42] · P1-P12 · phase 2 complete — 8 concepts, 2 docs superseded, fixtures renamed ✓
  what → P1 **I was wrong twice on memory.** First called it done without checking; then called opt-in "drift". Verified properly: EVERY repo with a `.kol/llm-memory` tier IS wired (6/6 symlinks); the unlinked ones never opted in, which is the documented membership model working. memory-glass README is accurate, nothing to correct. Finding: humpty/jabberwocky/memory-glass themselves have no memory tier — a choice, not a bug
  what → P2 ruled the 13-doc `agent-system/` suite: **8 canon · 2 superseded · 1 needs-a-pass**. They describe the PRIVATE SOURCE; jabberwocky describes the EXPORT — two views, not duplicates, so nothing retires for having a twin. `08-behavior` + `11-grant` marked superseded with their file maps repointed at humpty; verdict table written into the suite INDEX
  what → P3 naming ported to humpty — merged the three-family SYSTEM (Glass/Ubu/Alice, the lookup rule, orthography, seed bags) into the glossary I wrote earlier, which had only the assigned names
  what → P4 `fixtures.sh` → `tests.sh`, banners `FIXTURES OK` → `TESTS OK`, 4 live refs synced. **Historical records deliberately NOT rewritten** — session logs, playbooks and `_results/` are dated archives of what happened
  what → P5 delete law is now shippable doctrine in humpty's level-2 inject block; `CLAUDE.md` keeps its copy; `ref/humpty.md` gained a `## delete` section, `ref --lint` 17 cards clean
  what → P6-P10 five more concepts written (04-docs-spec · 05-scaffold · 06-cdn · 07-export-specs · 08-publishing), each carrying an explicit STRIP LIST so the mechanical work is defined rather than discovered
  what → P11-P12 concepts README covers all 8 with a dependency order (04 first — 05 points into it); dotfiles `systems/INDEX.md` gained a dependency-in-use table; `claude-harness/INDEX.md` notes the hooks left the repo
  note → the CDN credential model needed no work — rclone owns creds in its own config, which is strictly better than the `.env` seam I was asked to add. Said so rather than building the worse thing
  note → three couplings were already correct and are recorded as such: rclone creds (06), `AGENT_DROP_DIR` (02), `HUMPTY_CTX_DIR` (03/05)
  note → **all 8 concepts are SPECS. No strip list is executed.** Stated at the top of the concepts README so nobody mistakes them for packaged

[09:44] · phase 3 · ubu-roi named — the publishing surface
  what → **name locked: `ubu-roi`** (persona from the Ubu family, repeating vowels, types clean). It becomes the PUBLIC publishing surface — humpty stays the private dev repo and keeps everything; ubu-roi receives ONLY plugin payload, generated by a sync script so it cannot drift
  what → rejected: hoisting `.kol/`+`docs/` up to `kol-dumpty/`. Both humpty and jabberwocky were deliberately rebuilt to be SELF-HOSTING (jabberwocky's history records the first cut rejected for describing a vault system while not being one), and `/ag-init` reads `.kol/` at repo root — hoisting breaks boot AND the property the repos were rebuilt for
  what → skill audit delegated to the agent: read all 35, emit a keep/drop list with a reason each, and keep a FULL copy in `_tmp/` as the safety net before any cut
  note → **correction I owed twice:** `statusLine` SHIPS — `bin/humpty-statusline` is payload. What does not ship is the user's own `settings.json` entry pointing at a dev path, and his tmux `prefix g` binding. Listing those three together as one "fragile paths" phase was the error; they are a shipped script, a machine config, and a keybinding
  note → prefix question answered from what we already have: humpty ALREADY matches `$humpty`/`st`/`stf`/`stfu` as raw prompt text in the tracker. Plain-text signals need no `/humpty:` prefix; only TYPED slash commands do; model-invoked skills are never typed at all
  note → concepts deferred until the dependency work lands — user's call, not a gap

[09:55] · A3 · the cut — 35 skills to 15
  what → user ruled: drop 5 duplicates + 3 absorbed · QUARANTINE tmpl-wl-* (extreme limit, keep recoverable) · COLLAPSE 8 output-l* into ONE `layouts` skill with the layouts as data · `kol-goal` → `humpty-goal`
  note → **his callout, taken:** eight near-identical skills to express eight layouts is noise I created and should have collapsed on sight. Layouts are plugin modules, data not skills — one skill, layouts in files beside it
  note → `yn` was already ruled a drop in an earlier session and I re-surfaced it as an open question. Same finding twice, second time as if new
  what → A3-A9 DONE. 13 skills quarantined + 7 layout skills collapsed → 18 remain. `kol-goal`→`humpty-goal` (CMD constant + humpty_lib comment). `bin/humpty-payload` built: 5 pre-flight checks, allowlist not denylist, COPY never move. `ubu-roi` staged — 67 files, zero dev material
  what → `README.public.md` added to humpty and staged AS ubu-roi's README, so the published front page is generated too and neither README has to hedge about its audience
  note → **the collapse was a BUG FIX, not tidying.** All 8 `output-l*` skills pointed at `docs/…/LAYOUT-REGISTER.md`. `docs/` does not ship. So every layout skill on a marketplace install pointed at a missing file — and `humpty_stop.py` imported `format-check.py` from `docs/` the same way. Register + 8 modules + both scripts are now bundled inside `skills/layouts/`
  note → **running the payload standalone is what found it.** 11 asserts failed there that pass in the dev repo. "Tests green" in a repo that carries dev tooling says nothing about what a user installs — the generator now runs the suite as a gate, and `humpty-payload --check` is the pre-publish command
  note → the delete gate blocked ME clearing `__pycache__`. Added bytecode/lint caches to its scratch list — they regenerate from source, so gating them only forced an argument with the gate. Found by using the tool, not reading it
  note → the leak scanner matched its own grep pattern on run 1 and a `.pyc` on run 2. Both fixed in the scanner (`-I`, `--exclude-dir`, self-exclusion) rather than by deleting the evidence
