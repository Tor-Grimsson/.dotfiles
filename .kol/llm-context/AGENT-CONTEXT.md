---
_template:
  version: 1
  path: .kol/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# dotfiles — Agent Context

Current state + operational reference for `~/.dotfiles`. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing rules see `ARCHITECTURE.md`. For the *why* see `HISTORY.md`. For speculative work see `../llm-plan/`.

**Last updated:** 2026-07-20 (28) (**nmix merged into the daily nvim — overlay retired**) — User call: the graft is permanent. **Oil + harpoon + the nnow QoL keymaps now live in `nvim/lua/grim` directly** (deviations kept: `<leader>d` = diagnostic-float, `<leader>-` = decrement, tree owns `nvim <dir>`; behavior changes now default: `x` no-yank, visual `p` keeps yank, visual `J/K` move lines). **`nvim-mix/` deleted end-to-end** (config, `~/.config` symlink, `nmix` alias, bootstrap block, `ref-nmix` + card) — ref family back to 7 cards. Boot-verified: 45 plugins, all merged binds bound, tree intact. Daily still has no code-action key (nnow-only). `nnow` stays as the from-scratch lab. See `session-log/2026-07-20-nmix-merged-into-daily-nvim.md`. — Prior: 2026-07-15 (27) (**ref-* card family · widget linking · desk geometry · cmd-alt-b sticky**) — **The `keys` pattern became a family:** `bin/ref` dispatcher + six cards — keys · tmux · files · widgets · system · nvim (tmux = keys data scoped to #tmux; a card is now file + optional base tag) — with **`ref-*` alias scripts as the canonical names** (user's naming; bare `keys`/`files` kept as short aliases; help-lint taught the exec-alias pass rule). `ref-system` holds `#window-snapping` (⇧⌥⌘D/E aerospace off/on) + `#theme` sections; **one card per nvim config** — `ref-nvim` = DAILY (extracted from `nvim/lua/grim`), `ref-nnow` = from-scratch (modes as tags), `ref-nmix` = overlay additions + not-grafted/deviation ledgers; **per-card `--help`** prints the card's own live section list; all cards terse-passed (one-line intros, `ctrl-x` notation). **NEW `nvim-mix/` config (alias `nmix`)** — daily + nnow overlay, no copies (daily on rtp, lazy imports grim+mix, rtp.reset off): Oil + harpoon + QoL grafted, `<leader>d`/`<leader>-` stay daily (diagnostics/decrement), boot-verified 45 plugins, bootstrap+symlink wired. **tmux gruvbox yellow**: window names `#d79921`, current `#fabd2f`, message bar `bg=#d79921` — theme file + fallback in lockstep. **Widgets:** final type 12px/17px/11px, width 280, and **notes is position-LINKED below bookmarks** (both top:48; render computes bookmarks' height from the shared bookmarks.txt + GAP 12 margin — constant gap at any list length; wrapper pointer-events:none, card re-enables; bmOffset mirrors bookmarks' metrics — change together). Bar stays 14px. **aerospace:** outer.right 304 · outer.top 48 (tiles align with widget column); **cmd-alt-b** → new `bin/bookmarks-toggle` sticky (own `kitty/kol-bookmarks.conf`); sticky rule now `kol-(notes|bookmarks)` → **layout floating** (T-move dropped). **tmux:** `prefix c` = plain append (RIGHT end, live-tested); **second prefix `§`** (prefix2, C-a primary, `§ §` = literal §); sessionx `prefix O` added to ref-keys. **Pending user:** `aerospace reload-config` · `prefix r`+`I` · Übersicht refresh ×2. **Process note logged to memory: user names are binding — two builds deviated from stated names this session and were corrected.** See `session-log/2026-07-15-ref-family-widget-linking-desk-tuning.md`. — Prior: 2026-07-15 (26) (**process widget solved — first-load race, self-heals, no fix**) — The missing focused-app icon root-caused: `index.jsx` bakes its init command **once at module load** from localStorage (`Settings.get()` is sync) while `Settings.init()` (the async `~/.simplebarrc` import) hasn't landed — a cold/wiped store boots that cycle on the default `/opt/homebrew/bin/aerospace` (wrong arch on the iMac) → the same `"displays": ,` parse error → process widget gone until an aerospace-hook refresh re-mounts it warm. Proven by bisect: all widget commands green via same-origin POST to `/run/`; browser first load reproduced the exact repeating error, reload (warm store) rendered the widget fully. Self-healed natively mid-session (the (24) hooks). **Nothing changed in config** — steady state is stable; recurrence after any future store wipe = one workspace switch. Doc: `07-ubersicht.md` new troubleshooting bullet. (Side: btop's `2.1.210` rows = `claude` CLI procs shown by version string.) See `session-log/2026-07-15-process-widget-first-load-race.md`. — Prior: 2026-07-15 (25) (**tmux-resurrect · kitty main config · simple-bar login-item PATH · process widget OPEN**) — **tmux survives reboots:** resurrect+continuum in `.tmux.conf` (`@continuum-restore on`; save `prefix S` — default C-s is sesh's; restore `prefix C-r`) — **user must still `prefix r` + `prefix I`**. **kitty got a main config** (`kitty/kitty.conf`, NEW — there was none): shift+enter→ESC+CR soft-enter for Claude Code, JetBrains Mono 14, kol-theme include; bootstrap + kol-theme wired, live symlinks in `~/.config/kitty/`. **simple-bar "JSON error" root-caused:** Übersicht is a login item now → launchd's brew-less PATH → stock `$(which aerospace)` empty → init-aerospace.sh emitted `"displays": ,`; fixed with `aerospacePath: "$(PATH=/opt/homebrew/bin:/usr/local/bin:$PATH which aerospace)"` (env-prefix form does NOT work — the init script execs `$1`). **OPEN: the process widget (focused-app, bar left) doesn't render** — all CLI-side evidence green (queries, ids, settings, displayIndex); failure is WebView-only. Pick up via Übersicht Debug Console or same-origin POST to `/run/` — full diagnostic trail + suspect ranking in the log. See `session-log/2026-07-15-tmux-resurrect-kitty-main-simplebar-path.md`. — Prior: 2026-07-15 (24) (**desk tuning — bar joins kol-theme · event hooks · fastfetch · Finder floats**) — **simple-bar = kol-theme's 7th surface** (per-theme `simplebar` block jq-merged into `.themes`, written THROUGH the `~/.simplebarrc` symlink — never `mv`). **Bar lag root-caused:** the bar never polls and its only hook targeted a widget id from an older simple-bar (`…spaces-widget…` — doesn't exist; `|| true` ate it); now `exec-on-workspace-change` + new **`on-focus-changed`** both refresh `simple-bar-index-jsx` (DOM-verified). **Workspace-letter user widget `(T)`** shipped past two traps: `refreshFrequency: false` → `setInterval(0)` → `/run` flood; and under `widgetsBackgroundColorAsForeground` an empty `backgroundColor` = **invisible ink** (text painted in bar-bg — the desktop's `sb_cmd_*` cache held `"(T)\n"` all along) → `--accent`. Also: **fastfetch** de-guttered (`--align center` baked 19 spaces; now `-f symbols --align left`) + restyled (hardware/software sections, ANSI-yellow keys = theme-aware, battery/locale out); **Ghostty 14pt**; **Finder floats** (combined rule — aerospace runs only the FIRST match, old W rule folded in); **wifi `<redacted>`** = Sequoia SSID-as-location → `hideNetworkName`; **bookmarks paths now COPY to clipboard** (~-form, pbpaste-verified) not Finder-reveal. User-confirmed visible/working. See `session-log/2026-07-15-desk-tuning-bar-hooks-fastfetch-finder.md`.

---

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

- [x] ~~**Port the never-bigger size guard to the rest of the `vid-` family (2026-06-20).**~~ — closed 2026-07-05 (user call).
- [x] ~~**`vid-convert.sh` — same anamorphic SAR bug as `vid-reframe.sh` (fixed 2026-06-19).**~~ — closed 2026-07-05 (user call).
- [ ] **MCP work (DEFERRED — gated handoff).** The scattered MCP threads (glif `GLIF_API_TOKEN`→env, BWS-vs-`~/.secrets`, the no-`ANTHROPIC_API_KEY`-on-Claude-Code rule, headless-absence caveat) are consolidated into a **conditional, init-gated handoff**: `session-bridge/handoff-2026-06-14-1919-mcp.md`. It's dormant — the startup protocol reads it (newer than the session log) but its activation gate says to ignore it unless the session is doing MCP work. Pick it up only then. (Logged 2026-06-14, iMac.)
- [x] ~~**Shift+Enter → newline in Claude Code under tmux — finish the verify (iMac).**~~ — closed 2026-07-05 (user call).
- [x] ~~**MBP iTerm not on the shared custom-folder plist — Option-arrows / Natural-Text-Editing keys dead → vi-mode feels like "broken vim" (run this ON THE MBP).**~~ — closed 2026-07-05 (user call).
- [x] ~~**Anthropic API key → canonical copy in Bitwarden**~~ — **done 2026-06-09** (in the vault). **2026-06-09:** key now lives locally in `~/.secrets` (new file, `chmod 600`) as `export ANTHROPIC_API_KEY=…`, sourced by `.zshrc`; `llm` reads it from the env (also still in llm's keystore `llm keys path` — harmless dup; delete that line for single-source if wanted). `~/.secrets` is untracked + local → recreate on the MBP by pasting from the vault. **⚠️ 2026-06-10 (MBP): do NOT do this on a machine running Claude Code via subscription** — an exported `ANTHROPIC_API_KEY` makes `claude` bill the API instead of the Max/Pro subscription (the bug the user hit). MBP has no `~/.secrets` (confirmed absent) — keep it that way. Only set the key where a non-Claude-Code tool actually consumes the API (`llm` on the iMac). Glif not needed on the MBP either.
- [x] ~~**Secrets delivery — evaluate Bitwarden Secrets Manager (BWS) when dev secrets grow.**~~ — closed 2026-07-05 (user call).
- [x] ~~**`crush` has no catalog doc**~~ — **removed from Brewfile instead 2026-06-09** (unused — user thought it was a browser). Also dropped the orphaned `charmbracelet/tap` (glow is brew-core). User runs `brew uninstall crush` + `brew untap charmbracelet/tap`. Catalog count unaffected (was never documented).

- [x] ~~mbp caveman purge~~ — **EXECUTED + verified 2026-06-05** (agent ran it directly). `settings.json`+`hooks/` symlinked to repo, plugin cache/marketplace/registry stripped, old settings parked at `~/_temp/settings-caveman-bak.json`. MBP `~/.claude` now fully on repo truth. Caveman speech clears on next session restart.
- [x] ~~Resolve p10k / zsh-plugin duplication~~ — **DONE 2026-06-09: brew on both, omz copies dropped.** **2026-06-09:** a kol-claude session added `fzf-tab`/`zsh-autosuggestions`/`zsh-syntax-highlighting` via the **omz-clone** path (`plugins=()` + git clones, *not* in bootstrap → won't reproduce on MBP). `fzf-tab` confirmed a **brew formula** (1.3.0), so brew-on-both covers all three. **zsh-plugin half RESOLVED 2026-06-09 — went brew** (sourced in `.zshrc`, added to Brewfile, removed from `plugins=()`); user runs `brew bundle` + drops the omz clones. The **p10k** half is now also resolved — `ZSH_THEME=""`, theme `source`d from `${HOMEBREW_PREFIX}/share/powerlevel10k/`; user drops the `custom/themes/powerlevel10k` symlink/clone. See `session-log/2026-06-09-fzf-stack-zsh-plugins.md`.
- [ ] Decide pipx → uv consolidation; decide whether brew `node` stays on the MBP (pnpm self-manages it). **2026-06-05: Python variants 4 + 5 found on the MBP** — miniconda (`conda init` block in shared `shell/.zshrc` pollutes iMac PATH) and python.org framework 3.13 (its installer had written PATH lines through the symlink into tracked `shell/.zprofile` — repo file cleaned + brew shellenv arch-guarded same day; MBP uninstall steps in TOOLING.md § Python).
- [ ] `brew upgrade` on each machine when convenient (the bundle install/upgraded the iMac on 2026-06-04 but lots stay outdated).
- [ ] Optional adds called out in TOOLING.md: czkawka (already in), tdf (PDF TUI), fclones (faster exact dedup).
- [ ] `rm -rf ~/.claude-server-commander` — orphaned Desktop Commander MCP logs (still present, confirmed in 2026-06-05 home audit).
- [ ] **Home-dir declutter (deferred 2026-06-05):** Finder `AppleShowAllFiles`→false (re-hide legacy `~/.tool` dotfiles); XDG env block in `.zshenv` to nest *future* tool state + `SHELL_SESSIONS_DISABLE=1` + relocate `.zcompdump`→`~/.cache/zsh/`. Do NOT force-migrate live `.cargo`/`.rustup`/`.npm`. Detail in `session-log/2026-06-05-home-config-audit-relink.md`.
- [x] ~~MiniMax token~~ — **closed 2026-06-05, user doesn't use MiniMax; do not re-raise.** ~~GLIF_API_TOKEN~~ — already in vault (kol-tokens `Glif`, **in NOTES not password**). ~~`.claude-server-commander`~~ deleted.
- [ ] **Vault dedup (user's call):** B2/rclone items overlap (`Backblaze B2 Credentials` = account master vs `rclone – kolkrabbi — b2` = app key, prefixes baked in). Agent's accidental 3rd item already deleted. See `meta/SECRETS_TO_MOVE.txt`.
- [x] ~~MBP home-config audit~~ — done 2026-06-05 (`meta/HOME-CONFIG-AUDIT.md` § MBP audit). Far cleaner than expected: only `~/.claude` diverged.
- [x] ~~Jackett key rotation~~ — **closed by user decision 2026-06-05** (LAN-only service, not worth rotating). Key lives in the vault (`kol-tokens/Jackett`); do not re-raise.
- [ ] **`~/.zshrc-bak`: ported 2026-06-05** (aliases, `bws`, history, `EDITOR`, cargo, iTerm2 — all in `shell/.zshrc` now, which was also rewritten clean). Delete the `-bak` once the user has lived with the new shell for a bit. iMac-only note: p10k is symlinked into `~/.oh-my-zsh/custom/themes/` from `/usr/local/share` (machine-local).
- [ ] Review then maybe re-add the skills cut on 2026-06-04 (client-normalise, init-client/editor/repo, publication-mirror). **Caveman is permanently out** (plugin, hooks, and skill all removed).

---

## Known gotchas

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
- **Tool docs: lookup first, prose after.** Order = Summary (2 lines max) → deps table → numbered Setup steps → commands block → flags table → *then* Why/Win/Future narrative. Never lead with essay prose. **State dependencies head-on in a table** (command → does → needs) — "one package, two commands, only one needs mpv" said sideways in prose cost a 3-rewrite back-and-forth on 2026-06-06. Canonical example: `docs/documentation/06-media-av/06-edge-tts.md`.
