# Playbook — agent-system outline (the wholesale)

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`. Prior arcs: kol-claude-memory build 🏁 · memory-glass scaffold.

**Goal:** Outline the entire agent operating system as an interconnected docs suite in `docs/operations/systems/agent-system/` (working title — umbrella name OPEN, glass bag) — every module, skills + hooks included, ASCII diagrams, export/scrub notes per module. Design first; extraction later.

**Standing rules (non-negotiable):**
- Umbrella + module public names come from the three-family naming system (Glass/Ubu/Alice) — never invented ad hoc, never decided without the user.
- Published persona = **Ubu Roi**, never Grim.
- Naming system documented TWICE: `.kol/llm-context/NAMING.md` (agents) + `docs/operations/systems/agent-system/10-naming.md` (user).
- No git, no provisioning.

---
## Entries

[09:04 GMT · 2026-07-28] · setup · playbook + inventory
  what → new playbook (3rd arc); inventory: 43 skills · hooks = agent-reinforce/footer-gate/goal-loop/doc-sync-reminder + 2 reinforce payloads + statusline · packages = kol-cdn/kol-docs/kol-packages/scaffold · 4 kol-* subagents · .kol = llm-context/llm-memory/llm-plan
  note → suite shape: INDEX + 10 modules (init/context/journaling/memory/plans/docs-framework/human-tier/behavior/routing/naming)

[09:07] · suite · 11 docs written ✓
  what → docs/operations/systems/agent-system/ complete: INDEX (master diagram + module table + export rules) + 01-init (boot chain) 02-context (red-queen trim) 03-journaling (4 log skills) 04-memory (pointer to shipped cog) 05-plans (parking lot verbs) 06-docs-framework (kol-docs spec + package rule) 07-human-tier (docs/ split + .obsidian) 08-behavior (persona/ponytail/4 hooks, Ubu Roi in export) 09-routing (lenses + search ladder) 10-naming (three families)
  what → NAMING.md agent copy at .kol/llm-context/ · docs root INDEX +1 sibling row
  note → every module doc carries export notes (bag candidate, ship-form, scrub); 04-memory links kol-claude-memory/ instead of duplicating · umbrella name left OPEN throughout

[10:22] · goal · /kol-goal armed — the jabberwocky export
  what → umbrella NAMED by user: **jabberwocky** (after a 20-option bag round; glasshouse/wonderland/looking-glass all rejected; gh search: no real clash, top hit 205★ printer toolhead) · humpty-dumpty chambered · bags pruned English-only · orthography rule set (compounds hyphenate, canonicals one word) · NAMING.md + 10-naming + memory synced
  what → /jana skill read + logged (user signal: just answer, zero tool calls) · goal file live (.active-goal.md, max 30)
  note → USER DIRECTIVE for this run: assume memory-glass/kol-glass are WRONG (built under the old misread) — phase 0 is a bug-hunting audit, not a victory lap · account for ALL 43 skills + ALL hooks · finish with the master ASCII system map (his review outpoint)

[10:25] · phase-0 · audit done — 6 defects found + fixed ✓
  what → BUG1 INDEX titled "# glass" (name drift) → memory-glass · BUG2 flatten() locale-dependent ([[:alnum:]] under UTF-8 ≠ harness keying) → LC_ALL=C + explicit A-Za-z0-9 · BUG3 basename collision silently overwritten in link_into → warn on live-target replacement · BUG4 _global linked then pruned same run when tier missing (lying counts) → guarded · BUG5 wire($HOME) creates a DANGLING symlink at the harness write path when global tier absent — breaks a stranger's memory writes outright → guarded + clear message · BUG6 .kol/llm-memory + claude/memory hardcoded (KOL namespace unconfigurable in a public template) → TIER_DIR/GLOBAL_TIER seam vars
  verify → bash -n both copies ✓ · kol-glass live run +1/-0 ✓ · flatten regression vs 3 real harness keys ✓ · README/SYSTEM/INDEX synced (seam vars, tier-dir note, kol-glass tracked-list reality incl. his README + .kol)
  note → BUG5 was exactly the class the user predicted ("what you did when you misunderstood is not CORRECT") — quickstart order assumed, never enforced

[10:32] · phase-1-4 · jabberwocky BUILT ✓ (35 files) + map + proofs
  what → ~/dev/projects/jabberwocky: README (pitch+diagram+adoption) · MANIFEST (44 skills, 7 hooks, 4 agents, 4 packages — every one statused: shipped/standalone/port-next/private/third-party) · 9 module dirs, each README+files: 01 LLM_RULES+ag-init · 02 three state templates+trim spec · 03 four journaling skills · 04 →memory-glass pointer · 05 parking-lot template · 06 docs spec (canon ▷port-next) · 07 human-tier spec (scaffold ▷port-next) · 08 UBU-ROI.md persona + 4 hooks + scrubbed payloads + goal/jana/clear-reply/bullet-reply/action-items + settings wiring · 09 lens pattern + search ladder + embedded reference sync.sh
  verify → token screen CLEAN (grim/biskup/clients: 0 outside intended github links) · bash -n all hooks ✓ · goal-loop /kol-goal→/goal renamed ✓ · md-link check ✓ (1 false positive traced) · DRY-RUN: templates stamped into scratch repo, boot-sequence files all present, scratch cleaned
  note → master map at docs/operations/systems/agent-system/00-system-map.md (review outpoint w/ checklist) · honest gaps tracked not hidden: 06 canon + 07 scaffold = port-next in MANIFEST

[10:56] · parent · kol-humpty-dumpty ✓ (user call — local organisation)
  what → mkdir ~/dev/projects/kol-humpty-dumpty · jabberwocky + memory-glass moved in · kol-glass sync re-run (+1, lens re-pointed, 0 broken) · path sweep: map, 04-sharing, parking lot, AGENT-CONTEXT(38), naming memory — append-only records (playbook/session-log/goal file) left as history
  note → process lesson banked earlier this exchange: a user structural ask that I counter-argue needs an explicit yes/no, not silence-as-agreement

[11:34] · self-host · BOTH EXPORTS RESTRUCTURED ✓ (plan approved after the import gotcha)
  what → user rejected v1 as "documents the system, doesn't instantiate it" — plan-mode restructure approved. BOTH repos now instances: LLM_RULES boot + .kol/{llm-context: ARCH/CONTEXT/HISTORY/bridge/log · llm-plan: real queues} + conforming docs/ vaults (INDEX routers, NN- frontmattered, wikilinks in-vault/md-links out) + tracked 3-json .obsidian seeds (03-kol-ds-shape, sync:false, runtime pattern-gitignored) + MIT LICENSE
  what → jabberwocky: docs/{documentation: 00+9 module docs · operations: manifest+publish-protocol}; MANIFEST.md→operations; module READMEs→1-line pointers; Stop-gates split .sh-wrapper+.py-logic (stdin, parity-proven byte-identical on block fixtures); kol-docs CANON shipped (modules/06/canon, path-swept, 02-obsidian rewritten copy-only); .obsidian self-instantiated from module-07 seed · memory-glass: SYSTEM.md→docs/{01-system,02-repo-contract,03-portability}; root INDEX→vault home note; seed at ROOT (clone root IS the vault)
  verify → token screen (caught+scrubbed: "Grim" inside canon example vault log!) · embed byte-sync ✓ · frontmatter lint ✓ · link check ✓ (1 syntax-example false positive) · LLM_RULES template/instance identical ✓ · INDEX at every level ✓ · fake-HOME functional: CAUGHT SHIPPING BLOCKER — bash-3.2 set -u + empty EXCLUDE=() = unbound-variable death on stock macOS; fixed with ${EXCLUDE[@]+…} in 3 copies; rerun: idempotent (run2 all zeros), wires correct · live kol-glass sync +1 (jabberwocky docs/ lensed)
  note → audit tally now 7 sync.sh defects + 1 persona leak · map + checklist updated · remaining ▷: stamping/reading skills, parked in jabberwocky's own lot

[12:10] · category-folders · FLAT VAULTS REBUILT ✓ (user catch: docs categories are FOLDERS)
  what → user spotted both vaults shipped loose NN-topic.md files — the system's practice (dotfiles 14 categories, the canon's own _example trees) is category FOLDERS (INDEX + contiguous numbered docs, growth room); I took "subfolders XOR loose files" as license for the lazy branch
  what → jabberwocky: documentation/{00-overview,01-init,02-context,03-journaling,04-memory,05-plans,06-docs-framework,07-human-tier,08-behavior,09-routing}/ (INDEX + 1–4 docs each; 08/03-embedded-scripts built FROM payload so byte-equal by construction) + operations/{01-manifest,02-publish}/ · memory-glass: documentation/{01-system,02-repo-contract,03-portability}/ + operations/01-sync/ · flat files deleted · all wikilinks vault-qualified · README/module-pointer/sync.sh links re-wired · ARCHITECTURE in both gains the category-folders law (with the violation date)
  verify → INDEX at every navigated level ✓ · NN contiguous per folder ✓ · frontmatter lint ✓ · md links resolve ✓ · wikilinks ALL RESOLVE ✓ · embeds byte-equal ✓ · token screen clean ✓
  note → jabberwocky vault now 33 docs / memory-glass 17; map synced

[12:48] · ponytail-fork · evaluation compiled ✓ + skills doctrine corrected
  what → USER DOCTRINE locked: ALL skills ship (none pointless — dependency-bound not owner-bound), neutral gls-*/glass-* prefixes, disabled-by-default with "needs:" lines; jabberwocky skills-manifest rewritten (16 → port-with-rename; ponytail + /j accounting gap closed)
  what → docs/operations/07-ponytail-fork/ (INDEX + 01-inventory + 02-mechanics + 03-fork-plan + 04-deps-license) compiled FROM DISK: installed 4.8.1 at plugins/cache, marketplace git clone, state file .ponytail-active="full" · runtime core = manifest + 2-hook wiring (SessionStart matcher incl clear|compact + UserPromptSubmit) + 5 stdlib-node scripts + 6 SKILL.md · injected text is BUILT from skills/ponytail/SKILL.md filtered per mode (the drift-proof trick worth stealing) · 10 other-platform adapters + MCP server + dev bulk (benchmarks py/js) · MIT © Dietrich Gebert — fork clean w/ attribution
  note → fork name: user floated Humpty-Dumpty (Alice bag; coexists with private kol-humpty-dumpty folder) — OPEN until he calls it · fork execution = separate phase, steps staged in 03-fork-plan · operations INDEX +row 07

[13:50] · humpty-v1 · goal armed — CLEAN-ROOM BUILD (fork scrapped by user)
  what → doctrine locked by user: humpty-dumpty = OUR plugin, not a fork. Law 1 use-what-we-have (one trusted way off the wall) · Law 2 don't-improvise-reference (inconsistency breeds mold; reference-count = dependency-by-proxy; the forgotten thing is main-content geometry, not buttons) · Law 3 (my fill-in, accepted) high-reference → promote to canon · + the 4-level MUZZLE STEPPER (loose/standard/strict/muzzle) folding the accumulated discipline stack into one dial, signal skills stay as one-shot overrides, tracker suggests step-up on repeated muzzling
  what → clean-room discipline: write from OUR 02-mechanics spec + OUR OWN prior code (footer_gate.py idioms); logic in PYTHON (different language from upstream = strongest expression separation); upstream source not reopened
  note → v1 scope (ponytail ladder applied): plugin core + 3 skills (doctrine w/ level-gated inject blocks · match · survey-as-skill, standalone surveyor script deferred) + lawful repo shell · live footer-gate level-scaling = documented v2 wiring, not touched (his dotfiles)

[13:55] · humpty-v1 · BUILT + TESTED ✓ (34 files)
  what → ~/dev/projects/kol-humpty-dumpty/humpty-dumpty: plugin.json + hooks.json (SessionStart matcher incl clear|compact + UserPromptSubmit) · engine humpty_lib/activate/track.py + 2 wrappers (our pair pattern, python stdlib) · doctrine SKILL.md with marker blocks (level 1 laws · 2 report-shape · 3 strict · 4 hard-caps + cadence compact/full — injection BUILT from the skill, drift-proof) · humpty-match + humpty-survey skills · lawful shell (LICENSE MIT ours, LLM_RULES, .kol ARCH/CONTEXT/HISTORY/lot, category-folder docs vault 11 docs)
  verify → py_compile + bash -n ✓ · fixtures: cumulative level blocks ✓ dial persistence ✓ muzzle full-law/turn ✓ standard cadence every-3rd ✓ nudge suggester at correction #2 ✓ fail-open on garbage ✓ · frontmatter + wikilinks ALL RESOLVE ✓ · token screen: only intended author field; zero upstream-name mentions (clean-room hygiene held)
  what → syncs: 03-fork-plan SUPERSEDED note · NAMING.md + 10-naming: humpty-dumpty ASSIGNED (Alice) · map: humpty block added · kol-glass sync +1 (humpty docs lensed)
  note → remaining = HIS: local plugin install (docs/operations/01-develop) + git for all three repos · v2 parked: footer-gate level-scaling, surveyor script, adapters
