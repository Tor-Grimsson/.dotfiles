# playbook — ref-card system (keybind audit → density law → the keys dissolution)

> append-only · real timestamps · one idea per line
> arc: make the reference cards actually usable — audit the binds they document, then rebuild the cards themselves

## 2026-07-29

- 23:53 · playbook opened retroactively at the arc's end — the day ran as one continuous build; entries below are the causal spine, timestamps from the log where exact ones weren't kept
- ~08:00 · ghost-cursor report (green boxes on Enter) → cursor config audited, none exists; traced to render/state, CLOSED later: gone after a reopen, no fix needed
- ~09:00 · five-layer keybind audit (macOS · aerospace · terminal · tmux · nvim) — iTerm audited by mistake, the live terminal is ghostty → memory `audit-the-live-tool` written
- ~09:30 · fixes: ghostty Cmd+← sent one Ctrl+A = the tmux prefix → doubled (`text:\x01\x01`); zsh flow-control off (Ctrl+S no longer freezes); user disabled macOS Ctrl+Space + Ctrl+arrows
- ~10:30 · ref-nvim rebuilt mode-first (modes/traps · per-mode · mac-translation · drill · plugins · admin) — the old sheet documented a config he no longer runs
- ~12:00 · render chain hardened through three user-reported failures: bat only highlights → glow renders · glow.yml `pager:true` ignored `--pager=false` → cat-pipe · pipe strips color → CLICOLOR_FORCE=1
- ~13:00 · `docs/scripts/ref-system/` built — the ref pipeline as a system folder (INDEX + 01-system…05-terminal), 22-ref absorbed, theme JSON vendored
- ~15:00 · nvim porting built: zshrc `nvim()` wrapper (predictable socket per tmux session) · `bin/nvim-port` · lualine socket badge · ref-nvim porting section
- ~16:00 · kitty.conf rewritten as a setting-for-setting ghostty mirror — the font drift (JetBrains vs Meslo) was the "nvim looks different in kitty" cause
- ~17:00 · **density law** from the user: cards are the muscle-memory surface, docs are the knowledge home — row = name + command, `[e]` blocks below the table, non-command rows EVICTED to a `doc:` fold. Pilot = system card
- ~18:00 · law rolled across all cards; `ref-git` born (create · branch · delete · lazygit · gh, single-word sections)
- ~19:00 · bookmarks widget: `## name` sections + short-path display with hover-reveal
- ~21:00 · chronic text-overload ported to `kol-dumpty/lobby/text-overload.md` + 2 evidence images — the muzzle system constrains shape, not density
- 23:00 · **the keys dissolution** (goal-loop): keybinds.md split into tmux · explorer · grep · media · desk · terminal · shell cards; keys retired entirely (no alias, user explicit); ref-add skill replaces keys-add + files-add; /yana alias born
- 23:53 · gates green: 11 cards render · dead names refused · 12 filters · 20 fold paths real · widths ≤79/100
- 23:55 · next: clip-drop → repo lobbies (screenshot an issue straight into kol-ds-ui / humpty). Finding en route: `kol-dumpty/lobby` sits in an UNTRACKED family folder — its two notes are backed by nothing
- 23:59 · built `clip-drop.sh --lobby WORD [NAME]` — NOT a new script and NOT hardcoded repos: substring-matches a path from the new `## lobby` section of `files/folders.md` (one catalog, two consumers: `files`/`to` + capture targets). Writes `<lobby>/<NAME>.md` (append-on-repeat) + image in `<lobby>/_assets/`
- 23:59 · `--menu` grows one `lobby: <repo> …` item per registered path — the tmux `prefix C-p` popup gains the flow for free; ss-save deliberately untouched (it's the name-it-up-front sibling)
- 23:59 · verified end-to-end with a stubbed pngpaste against a temp registry row (created → appended → collision-suffixed), registry reverted, test dir removed; bad/ambiguous/empty word paths all error correctly
- 23:59 · docs synced: 08-system (table row + a `--lobby` section) · ref-system card (lobby row + `[e]` block, last inline `[e]` row migrated to the block form) · ref-tmux clipdrop row

## 2026-07-30

- 00:20 · `/rosa` + `/s` skills born — jana's sister: research WITH tools, changes NOTHING (jana = answer, zero tools). Used immediately to scope the repo-map question read-only
- 00:35 · user callout: docs/ root had drifted into a dumpster — kol-agent-system · kol-claude-memory · kol-terminality sat as root "siblings" because an earlier INDEX rationalised them as "neither content nor machinery". Ignoring our own system = postponing a bigger fix
- 00:52 · **docs/ root cleaned**: new `operations/systems/` home (plain names, NO NN sequencing — sized to grow). Moved in: agent-system · claude-memory · terminality (from root) + claude-harness · docs-framework · cdn (from the numbered operations sequence). 39 files repointed; operations keeps 01/04/06/07 with gaps left rather than churning live links
- 00:52 · docs/INDEX rewritten to THREE shelves + the standing rule: **a system does not live at the root**
- 00:55 · **repo-map system built** — `systems/repo-map/`: INDEX (ASCII estate + two wiring diagrams: 1 publisher → 5 consumers, and the agent stack) · 01-repos (hand-kept meaning) · `bin/repo-map.sh` (read-only walk → generated block + drift, bucket-pattern)
- 00:55 · two bugs caught in the generator: `awk -v` can't take a multi-line block (→ sed splice), and brace-shorthand repo names in the map hid 6 repos from the drift grep (→ names written longhand, the map must be greppable by design). Re-run: 29 repos, 2 families, zero drift
- 00:57 · `/dump` skill written — the TECHNICAL half of word soup (research printed unparsed, answer buried under defect walls); distinct from stfu (human noise) and st/stf (length). Ported to `humpty/lobby/research-dump.md` — the repo that sources agent behaviour, asked three times, answered plainly this time
- 00:58 · `/s` → `/r` renamed (user's brainfart correction) · memory `lead-first` written (answer is the FIRST line, third strike)
- 02:10 · user's design call: **`tmpl-` = the output-contract namespace**, `kolds-` = the repo-reference namespace. Scattered one-offs become one family
- 02:30 · built 14 skills — tmpl-{present,ask,human,uncanny,hl,stfu,bullet,clear} · tmpl-wl-{100,80,60,40,10} · kolds · kolds-ref · lobby. bullet/clear copied from claude-* (old names kept as aliases); stfu is PLUGIN-owned (humpty:stfu) so tmpl-stfu is a local alias, not a rename
- 02:35 · `tmpl-wl-*` designed against the actual bypass: standing (no decay, unlike humpty's clamp), concrete budgets (250/200/150/100/25 words), overflow folds into the footer, explicit anti-bypass clauses (no reply-splitting, no "one more thing", no code-block smuggling)
- 02:38 · `/lobby` = the READ side (arriving agent checks repo root for lobby/, reports the queue, doesn't start work); `/kol-lobby` stays the WRITE side. Checked before naming — they're genuinely different halves
- 02:40 · three new ref cards: **ref-skill** (tmpl · wl · mode · kolds · lobby · maintain) · **ref-humpty** (dial · clamp · laws · gate · lobby) · **ref-repo** — the last one GENERATED by `repo-map.sh --card` from 01-repos.md, so doc and card can't drift
- 02:50 · **clip-drop rebuilt**: `~/_inbox` is the home, a bare word is a FOLDER inside it (never a path — that bug put `review/` inside kol-ds-ui), path-shaped words stripped to their last segment, `--dir` is the escape hatch. Named repo flags `--kol-ds-ui --humpty --kol-website --dotfiles` derive from the registry, so a new lobby row creates its flag with no code change. `--help` rewritten examples-first
- 02:51 · two lobbies created (dotfiles root + kol-website) with INDEX contracts; registry rows repointed off the untracked `kol-dumpty/lobby` onto `humpty/lobby`
- 02:52 · verified: 5 clip-drop behaviours incl. the `../escape` defence · repo flag end-to-end into dotfiles/lobby (then cleaned) · 14 ref cards render · 10 filter shapes
- 02:55 · ported to `humpty/lobby/tmpl-family.md` — with the real port question: `tmpl-wl-*` is honour-system, a Stop hook counting body words would make it enforceable (footer-gate proves the pattern)

──────────── MILESTONE: the ref-card system ──────────── [03:01]
  cards: 14 (7 born, 4 rehomed, keys dissolved) · skills: 17 new · scripts: 3 (nvim-port, repo-map, clip-drop rebuild)
  docs: systems/ home + repo-map system · humpty lobby: 3 ported notes
  threads: 2 resolved (lobby notes rehomed into tracked repos) · 2 parked (llm-plan/01-parking-lot.md)
  log: session-log/2026-07-30-MILESTONE-ref-card-system.md
  playbook closes here.

[~19:07] · cards · the law becomes a machine check — `ref --lint`
  ruling → user: "just put all the trial explorer in the same table and use space and ## inside with name of plugin .. as a seperator"
  what → ref/explorer.md rebuilt — seven scattered per-tool sections collapsed into ONE `## trial` table, groups marked `| ## vifm |` after a blank spacer row
  what → NEW in-table grouping convention: a blank row + `| ## name | what it is |`. That is now the ONLY legal use of a blank table row
  root → asked "do we have a skill for this?" — yes, ref-add, and it CONTRADICTED ITSELF: line 39 said "Spacer row between data rows" while lines 49-51 said a spacer is a category break, never per-row. Every session picked one at random. That is why the 385-row sweep on 2026-07-31 did not hold
  what → built `ref --lint` in bin/ref: per-row spacers · cells > 46 chars · dead `doc:` targets · card with no `## section`. Exit 1 on any violation
  why → a rule a human has to remember is a rule that decays; the 385 spacers regrew from a doc that taught them
  bug → first version was awk. macOS awk's length() counts BYTES, and these cards are full of `·` `→` `…` — a 42-char cell measured 49. Rewrote the whole lint in python3. NEVER measure a UTF-8 card with awk
  found → `ref/repo.md` is GENERATED by repo-map.sh --card, and the generator still emitted per-row spacers and cut cells at 120 chars MID-WORD ("the hooks that enforce the |"). Fixed the generator: word-boundary cut to 46 with a trailing …, spacers dropped. A generated card that violates the dialect re-breaks itself every run
  what → 80 raw violations → 0. 19 per-row spacers stripped from files/folders.md, 2 legitimate breaks in ref/lobby.md given `## read` / `## file` / `## clip-drop` markers, 32 cells shortened across 9 cards
  gate → `ref --lint` = "17 cards clean"; all 17 render; filters re-tested
  what → ref-add step 4 now RUNS the lint instead of promising a check; 02-cards gained a "The lint" section, 01-system/03-glow/INDEX synced
