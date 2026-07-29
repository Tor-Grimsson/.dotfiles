---
_template:
  version: 1
  path: .kol/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# dotfiles — Agent Context

Current state + operational reference for `~/.dotfiles`. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing rules see `ARCHITECTURE.md`. For the *why* see `HISTORY.md`. For speculative work see `../llm-plan/`.

**Last updated:** 🏁 2026-07-28 (46) (**MILESTONE — the export, published: jabberwocky family live**) — the 14:18 install-and-publish handoff closed same-day, every leg: **humpty** v0.4.0 installed + enforcing live + published · **memory-glass** published public · **jabberwocky** published private after its own six publish gates ran ALL GREEN mechanically (token screen · embed byte-sync · template/instance conformance · dogfood · seed hygiene · functional incl. footer-gate fixtures) · kol-glass lens vault healed post-rename (+3 linked, dead `humpty-dumpty` name pruned). Handoff marked ✅ RESOLVED in place; playbook `2026-07-28-export-publish-arc.md` closed 21:16→21:50. Publish tooling became infrastructure: `ref-keys git new` = verbatim chain + one-paste `&&` line + rescues A/B, all earned live. No open threads; follow-ons parked in the owning repos' lots. See `session-log/2026-07-28-MILESTONE-export-published.md`. — Prior: 2026-07-28 (45) (**statusline colored · 7d dropped · memory-glass ready**) — `claude/hooks/statusline.sh`: every field gruvbox-colored (model purple 175 · cwd blue 109 · ctx aqua 108 · tok yellow 179 · 5h orange 208, beside the 214/234 humpty block) and the **7d weekly-quota field removed** (user request); syntax + sample render verified. **memory-glass publish-readiness pass done solo** — scrub zero-hit, README seam mismatch fixed (`$HOME/dotfiles` vs `.dotfiles`), READY; log in its own `.kol`. Export-publish arc playbook opened at `playbook/2026-07-28-export-publish-arc.md`. — Prior: 🏁 2026-07-28 (44) (**MILESTONE — agent-grant: keyed windows in the NO-GIT wall**) — `prefix g` (or `agent-grant [min]`, default 15m) opens a **self-expiring window of read-only git + downloads**; press again = revoke. The git deny left `settings.json` `permissions.deny` (now empty) for a new **PreToolUse gate** `claude/hooks/git-gate.sh`: closed → deny with unlock hint; open → allow read-only git (`log/show/diff/status/blame/…` + `clone/fetch`) and `wget`/`curl`; git writes denied **always**; chains/`$(…)`/multiline smuggling → "ask" (the parser only downgrades, never widens; bare-path `/usr/bin/git` falls to the normal prompt). Flag = expiry epoch at `~/.claude/.agent-grant` (untracked, self-deleting, no timers); reinforce injects "window open, Nm left" per turn; statusline badge `[GRANT git Nm]`; `bind g` + keys `#tmux #claude` + `02-tmux.md` synced. 18-case verdict battery green; live bug caught (heredoc ate hook stdin → env handoff). Docs: `docs/kol-agent-system/11-grant.md` + INDEX + map; porting note at kol-dumpty `lobby/agent-grant.md`. Gate arms on next Claude Code restart, bind after `prefix r` (user routine). No open threads. See `session-log/2026-07-28-MILESTONE-agent-grant-permission-window.md`. — Prior: 2026-07-28 (43) (**humpty live — statusline block, git-new card**) — ponytail disabled, stale `.ponytail-active` flag deleted; `claude/hooks/statusline.sh` badge slot is now the **`humpty-dumpty` block** in tmux active-tab yellow (256-color 214/234 — this statusline mangles truecolor, learned live; `:strict`/`:muzzle` suffix off-default; reads the plugin's `.humpty-active`). `keys/keybinds.md`: new **`## #git #new`** — the verbatim 4-step init→publish chain + rescues A (dead origin → remove + re-run) and B (repo exists → remote via `gh repo view --json url`), born from the user's live failure trail; `#gh` grew repo create/rename/browse/url-print lines. `12-ponytail.md` badge note retired. **Humpty v0.4.0 installed + published** (github.com/Tor-Grimsson/humpty) — arc sealed in the humpty repo's own context (`kol-dumpty/humpty`, renamed from kol-humpty-dumpty this session); the humpty leg of `session-bridge/handoff-2026-07-28-1418` is closed, jabberwocky/memory-glass legs remain there. — Prior: 2026-07-28 (42) (**alpha dashboard — hint overlap fixed, hints yellow**) — session 40's `SPC` → `<Leader>` relabel made the right-aligned hints outgrow alpha's stock 50-cell button width (`<Leader> wr` overprinted the "Restore Session…" label). Fix in `nvim/lua/grim/plugins/alpha.lua`: post-buttons loop sets `width = 60` + `hl_shortcut = "YellowItalic"` (hints were theme-`Keyword` red since gruvbox-material landed 13/06, tokyonight-cyan before — never yellow; the remembered yellow = the tmux/gruvbox `#fabd2f` + KOL `#FFCF33`, both on record). History traced via GitHub API, no local git. Headless boot clean; user confirmed visually. See `session-log/2026-07-28-alpha-dashboard-width-yellow-hints.md`.## Status at a glance

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
