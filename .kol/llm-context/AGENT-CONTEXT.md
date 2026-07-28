---
_template:
  version: 1
  path: .kol/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# dotfiles — Agent Context

Current state + operational reference for `~/.dotfiles`. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing rules see `ARCHITECTURE.md`. For the *why* see `HISTORY.md`. For speculative work see `../llm-plan/`.

**Last updated:** 2026-07-28 (40) (**nvim-now retired — references swept, dashboard label fix**) — user scrapped `nvim-now/` + its artifacts (symlink, `ref/nnow.md`, `bin/ref-nnow`, `nnow` alias; features already merged into daily nvim 2026-07-20 via nmix); agent swept every live reference: `bin/ref` + `ref-pick` (6 cards now), `ref/{nvim,system}.md`, `.zshrc`, `bootstrap.sh`, docs ×5 (12-nvim-from-scratch keeps a retirement note as the learning record). **`bin/kol-theme`'s nvim leg is a guarded no-op** — revives when the daily `nvim/` adopts the selector (`themes/*/nvim.lua` shelved). Alpha dashboard relabeled `SPC` → `<Leader>` (binds derive from the label, unchanged). Verified: bash/zsh `-n`, headless boot, help-lint all clean. See `session-log/2026-07-28-nvim-now-retired-references-swept.md`. — Prior: 🏁 2026-07-28 (39) (**MILESTONE — the jabberwocky family: the agent OS exported**) — four artifacts under `~/dev/projects/kol-humpty-dumpty/`: **jabberwocky** (OS umbrella: 9 module payloads, category-folder vault, full manifest — all 44 skills + hooks + ponytail + /j accounted; skills doctrine settled: dependency-bound, `gls-*` prefixes, ship-everything), **memory-glass** (7 audit fixes incl. the dangling write-path link + bash-3.2 EXCLUDE blocker; self-hosting + category folders), **humpty-dumpty** (clean-room plugin, python/bash, zero upstream obligations: the three reuse laws + 4-level muzzle stepper `/humpty 1..4`, persisted, step-up suggester; fixture-tested, 34 files), plus kol-glass lensing them all. Both export vaults rebuilt twice on user review (self-hosting; category folders) — laws codified in their ARCHITECTUREs. Ponytail fork superseded (evaluation kept: `docs/operations/07-ponytail-fork/`). Names all user-assigned; **published persona = Ubu Roi**. **Install + live-test + publishing deferred by user** → `session-bridge/handoff-2026-07-28-1418-humpty-install-and-publish.md`; speculative work parked in the owning repos' lots. Map: `docs/kol-agent-system/00-system-map.md`. See `session-log/2026-07-28-MILESTONE-jabberwocky-family-export.md`. — Prior: 2026-07-28 (38) (**agent-system outline · naming system · memory-glass template**) — the wholesale reframe: the export is the whole agent OS, not just memory. `docs/kol-agent-system/` written (INDEX + 10 module docs, diagrams + export notes each; link-check clean). **Three-family naming system** set: Glass=state · Ubu Roi=actors · Alice=motion — names picked from bags, never invented; **published persona = Ubu Roi, never Grim**; umbrella name OPEN (glass bag, user's call); agent copy at `.kol/llm-context/NAMING.md`. **memory-glass** public template built at `~/dev/projects/kol-humpty-dumpty/memory-glass` (claude-glass renamed; README reframed harness-agnostic — Claude = reference harness, one seam) — user publishes. Memory system proven live: 3 writes through the redirect (2 global-tier here, 1 kol-website). User review of the suite pending. See `session-log/2026-07-28-agent-system-outline-naming-memory-live.md`. — Prior: 🏁 2026-07-28 (37) (**MILESTONE — kol-claude-memory: repo-backed shared memory + kol-glass vault**) — Claude memory relocated into git: **global tier** `claude/memory/` (21 cross-repo facts; home key `-Users-biskup` symlinked in) + **repo tier** `.kol/llm-memory/` (3 dotfiles facts), 5 more repos seeded (`_kol-quick` 3 · `kol-chess` 1 · `kol-ds-ui` 5 · `kol-studio` 3 · `kol-website` 4, each index opens with a global-pointer line); all 7 `~/.claude/projects/<key>/memory` paths are now **symlinks into repos**. Vault renamed **kol-symlink → kol-glass**, two lenses (`repos/` 36 docs · `memory/` 7 tiers) + idempotent `sync.sh` (seam: ROOTS/DOTFILES/EXCLUDE; membership = `.git ∨ docs/ ∨ .kol/llm-memory/`; macOS grep needs `memory/*/`), pushed **private** (github.com/Tor-Grimsson/kol-glass — INDEX carries the client roster, public ruled out). Design+build docs `docs/kol-claude-memory/` (5, synced); build journal `playbook/2026-07-28-kol-claude-memory-build.md`. Dead-key triage + shareable scaffold **parked** (`llm-plan/01-parking-lot.md`); MBP = one `sync.sh` run, documented routine. See `session-log/2026-07-28-MILESTONE-kol-claude-memory-system.md`. — Prior: 2026-07-28 (36) (**clip-drop --desc · menu preview fix · tab-highlight pending verdict**) — `bin/clip-drop.sh`: `--desc TEXT` (annotation under the capture's embed; menu prompts `description (Enter = skip)` on all md paths) + `--preview ''` on the menu fzf (global bat file-preview errored on menu labels — user hit live). `08-system.md` synced. Tmux active-tab block highlight (`bg=#fabd2f,fg=#1d2021,bold`) applied in `.tmux.conf` + `themes/gruvbox/tmux.conf` — built off a question without authorization (process violation, memory hardened); user closed it as a non-issue, style stays. **Tailscale doc synced:** `docs/kol-cli/06-tailscale-jellyfin.md` repointed `thordurs-imac`/`100.91.192.16` → **`biskup`/`100.116.173.43`** throughout (12 refs) + node-identity note (stale admin-console duplicate). tmux `studio` cleanup confirmed done (one clean 8-window session). **Open threads: ZERO — user-confirmed; reloads/reboots are his own routine, not tracked items.** See `session-log/2026-07-28-clip-drop-desc-tab-highlight.md`.

## Status at a glance

- Repo holds shell/git/ssh/editor configs **plus** a reconciled `Brewfile`, a per-tool docs catalog, and the repo-backed `~/.claude` config.
- 2026-07-08 (3): **TUI cockpit + git category + lazygit.** lazygit reconciled (brewfile + `bind C-g` popup + catalog + git card). Fixed a reorg miss — stale `docs/NN-` paths in extensionless configs (`brewfile-cli`/`.tmux.conf`/`.zshrc`/kol-cdn wrappers) repointed. Built the fastfetch shell-home (chafa portrait logo, `fastfetch/`) + `21-chafa` doc. New **`18-tui-shell-layout`** category (fastfetch-home + tmuxinator `home`/`torrent` dashboards + a paths/URLs bookmark system: `prefix C-b` open, `B` add-cwd, `A` typed popup, 3 helper scripts + `tmux/bookmarks.txt`). New **`17-git`** category (general `01-git` + gh/lazygit/worktrees moved from dev-languages, ponytail 13→12). `bind C-d` layout popup. New tracked dirs: `fastfetch/`, `tmuxinator/`, `tmux/bookmark*`. Parked mpd+rmpc / AeroSpace-Ctrl-Alt / status-trim in `plan.md`. **tmux binds live after `prefix r`.** See `session-log/2026-07-08-tui-cockpit-git-category-buildout.md`.
- 2026-07-08 (4): **`keys` keybind-reference tool + `keys-add` skill.** `keys [tag …]` bat-prints your own keybinds filtered by tag — `bin/keys` + `keys/keybinds.md` (new tracked dir; a hand-kept flat `## #tag` list seeded from the live tmux/aerospace/nvim/bookmark/git/gh/ssh binds; cataloged `scripts/19-keys.md`). New **`keys-add`** skill maintains it (format + tag taxonomy + config-sync discipline); skill catalog **35→36**. See `session-log/2026-07-08-keys-keybind-reference-tool-skill.md`.
- **The user owns all git** — agent never commits; advise and hand off.

---


*(older status bullets trimmed 2026-07-11 — the archive is `session-log/`; see also `llm-plan/01-parking-lot.md` § AGENT-CONTEXT trim)*

## Repo layout

| path | role |
|---|---|
| `brewfile-cli` + `brewfile-gui` | package manifest, **split 2026-07-04** (was unified `Brewfile`) — cli = formulas only, safe to run standalone on a foreign/SSH box; gui = casks + VS Code extensions, daily-driver machines only |
| `bootstrap.sh` | installer: `brew bundle` (both brewfiles) + TPM clone/install, then symlinks shell/git/ssh/vscode/iterm/mpv/tmux/**claude** + runs `macos/defaults.sh` |
| `TOOLING.md` | tooling **audit**: drift, reconciliation, cross-arch portability, open items |
| `docs/` | tooling **catalog**: 85 tools, 14 categories of kol-docs `reference` docs + root INDEX, plus standalone `## Guides` (e.g. `14-supabase/`) and `## Explorations` (design surveys, not-yet-built — e.g. `19-kol-tui-plugin/`) |
| `claude/` | repo-backed `~/.claude`: CLAUDE.md, settings.json, skills/, hooks/, commands/, agents/, output-styles/ |
| `meta/` | secrets/setup: `BITWARDEN-SETUP.md`, `SECRETS_TO_MOVE.txt` |
| `macos/defaults.sh` | macOS defaults baseline (Finder/keyboard/screenshots/Dock/…) |
| `shell/` `git/` `ssh/` `iterm/` `vscode/` `mpv/` `nvim/` `tmux/` `bin/` `scripts/` | the usual dotfiles configs + helper scripts |
| `.kol/llm-context/` | this agent-context protocol |
| `LLM_RULES.md` + `claude/skills/{init-agent,log-work}` | session-boot protocol — global skills; repo-local `.claude/` retired 2026-07-03 |

`claude/skills/`: **init-agent, log-work(-handoff), scaffold-{llm-context,docs-system,dev-stack,dev-stack-kol}, kol-migrate-structure, agent-{output-format,reinforce-rules,reinforce-memory}, kol-docs-fm/md, kol-lobby, kol-press-research, bucket-b2/-r2, export-specs, claude-clear, claude-bullet** (34 total; kol-docs-fm/md + scaffold-docs-system each read their own `kol-docs-{fm,md,lib}` package). **Renamed/restructured 2026-07-05** — `init-agent-context`→`scaffold-llm-context` (docs-framework split out), `kol-docs-lib`→`scaffold-docs-system` (absorbed docs-framework scaffolding), `init-scaffold(-kol)`→`scaffold-dev-stack(-kol)`; `init-agent-context-sync` + `kol-migrate-structure` quarantined to `_tmp/` same day, `kol-migrate-structure` **restored** later the same day (no evidence of real use for either, but the user wants the migration skill back). New: three lightweight `agent-*` reinforcement skills, auto-loaded by `/init-agent` + `/log-work`. **(Superseded 2026-07-08 — the three `agent-{output-format,reinforce-rules,reinforce-memory}` skills were replaced by the single global `agent-reinforce` UserPromptSubmit hook; they are no longer skills. See the skills doc + `01-agent-context-protocol`.)**

---

## Critical consistency seams

### Brewfile mirror — RETIRED
`Brewfile-mirror.txt` left the repo 2026-06-05; the byte-identical sync rule died with it. Single manifest now. (ARCHITECTURE §2.)

### ~/.claude symlinks
`claude/*` is symlinked into `~/.claude/`. Editing `~/.claude/CLAUDE.md`, `settings.json`, `skills/…` edits the repo. `bootstrap.sh` recreates the links.

### Cross-arch paths
Intel iMac = `/usr/local`, Apple-Silicon MBP = `/opt/homebrew`. No hardcoded prefixes in tracked files. (ARCHITECTURE §1.)

### kol-docs framework
`claude/skills/kol-docs-{fm,md,lib}/SKILL.md` read their canon from `claude/packages/kol-docs-{fm,md,lib}/`. Shared skill **dependencies** (frameworks, templates) live in `claude/packages/`, never inside a skill.

---

## Open items (live)

- (none — ledger cleared 2026-07-27; session-to-session threads live in the "Last updated" chain)

---

## Known gotchas

### ANTHROPIC_API_KEY vs subscription billing
Never `export ANTHROPIC_API_KEY` on a machine running Claude Code on a subscription — it silently bills the API instead of the Max/Pro plan (hit 2026-06-10 on the MBP). Set API tokens only where a non-Claude-Code tool consumes them (`llm` on the iMac reads it from `~/.secrets`).

### brew cask "adopt" failures
Newer Homebrew tries to *adopt* a pre-existing app and bails on version mismatch (hit on hiddenbar, openscreen 2026-06-04). Fix: `brew install --cask <name> --force`, or remove the old app first. **App Store apps** (have `_MASReceipt`) can't be adopted at all — delete the App Store copy, then cask-install.

### macfuse / pdf2image are intentionally NOT in the Brewfile
macfuse triggers a sudo/kext dance; pdf2image's binaries clash with poppler's symlinks. Both were dropped 2026-06-04. Install macfuse by hand if a fresh machine needs it.

---

## Contracts the next agent must not quietly break

- No hardcoded brew prefixes in tracked files.
- **Never run git** (user-owned) and **never run provisioning** (`brew bundle`/`install`/`upgrade`, `bootstrap.sh`) — prepare, then hand off.
- Don't track `~/.claude` runtime state (history/sessions/projects/caches) in the repo.
- Skill **dependencies** (kol-docs framework, init-agent-context + algorithmic-art templates, the `bucket` CLI) live in `claude/packages/` — never bundled inside a skill. Skills reference them at `~/.dotfiles/claude/packages/`.
- **Secrets never go in tracked files as literals** — only as env-var refs (`${VAR}`) sourced from Bitwarden. The glif MCP uses `${GLIF_API_TOKEN}`; the live token lives in Bitwarden, never the repo.
- **Claude memory is repo-backed (2026-07-28)** — global tier `claude/memory/`, repo tiers `.kol/llm-memory/`; every `~/.claude/projects/<key>/memory` is a symlink maintained by kol-glass `sync.sh`. Never replace one with a plain dir; a repo joins by gaining `.kol/llm-memory/`, then a `sync.sh` run. Memory content is tracked → tier repos stay private (or scrub before publishing).
- **Tool docs: lookup first, prose after.** Order = Summary (2 lines max) → deps table → numbered Setup steps → commands block → flags table → *then* Why/Win/Future narrative. Never lead with essay prose. **State dependencies head-on in a table** (command → does → needs) — "one package, two commands, only one needs mpv" said sideways in prose cost a 3-rewrite back-and-forth on 2026-06-06. Canonical example: `docs/documentation/06-media-av/06-edge-tts.md`.
