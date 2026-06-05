---
_template:
  version: 1
  path: docs/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# dotfiles — Agent Context

Current state + operational reference for `~/.dotfiles`. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing rules see `ARCHITECTURE.md`. For the *why* see `../history.md`. For speculative work see `../plan.md`.

**Last updated:** 2026-06-05

---

## Status at a glance

- Repo holds shell/git/ssh/editor configs **plus** a reconciled `Brewfile`, a per-tool docs catalog, and the repo-backed `~/.claude` config.
- Big 2026-06-04 reorg (two session logs): Brewfile reconciled; `~/.claude` fully consolidated into `claude/` (skills + agents + `packages/` deps + glif MCP, caveman removed); `kol-docs` is now a self-contained framework spec; `bin/` re-prefixed by domain + quarantined dups + `docs/12-scripts/` catalog; `meta/` + `macos/` documented.
- 2026-06-05: agent-context moved onto the canonical `/init-agent-context` layout — root `LLM_RULES.md`, `docs/llm-context/`, `docs/{history,plan}.md`, repo-local `.claude/skills/{init-agent,log-work}`. Session boot = `/init-agent` or "read LLM_RULES.md"; `-sync` can now track this repo.
- 2026-06-05 (2): Bitwarden chain live on the iMac (Keychain `bw-master` → `bwu`/`bwl`); iMac `~/.zshrc` restored to the bootstrap symlink (old file parked at `~/.zshrc-bak`, local aliases unported); Jackett key in vault (`kol-tokens/Jackett`), `tor-search` self-fetches it; bitwarden-cli + torrent docs rewritten.
- 2026-06-05 (3): **home-config audit + relink** (`meta/HOME-CONFIG-AUDIT.md` = the tracked-vs-noise map). Strays were real diverged files → reconciled + symlinked (`.zprofile`/`.gitconfig`/`.ssh/config`/nvim/mpv/p10k); newly tracked yazi, broot, Terminal.app prefs (`terminal/`, via `defaults import`); `shell/.zshrc` rewritten clean + `ZSH_DISABLE_COMPFIX=true`; rclone B2 key + Jackett key in vault; **leaked MiniMax token removed from `vscode/settings.json`** (live-minimal chosen as truth). bak/zcompdump cleaned, `~` strays → `~/_temp/`.
- 2026-06-05 (5, MBP): **MBP home-config audit** (`meta/HOME-CONFIG-AUDIT.md` § MBP audit). Most of the MBP already on repo truth (shell/git/ssh/vscode/bin symlinked); only `~/.claude` diverges. `claude/CLAUDE.md` ported to live-superset (now byte-identical both sides); `/Users/biskup` hardcodes fixed in `shell/.zshrc` aliases + `.claude/skills/init-agent`. iCloud-stranding warning dissolved (only a project-local `.claude` lives there). Remaining blocker: caveman settings/hooks decision (below).
- 2026-06-05 (6, MBP): **handoff verification + caveman purge prep.** Last session's items confirmed landed (bbrew gone, Obsidian back, settings.reconciled applied, server-commander deleted); hiddenbar not reinstalled, parked skills remain. Voice settings ported to repo `claude/settings.json`; full caveman purge (live settings → repo symlink + plugin/registry strip) handed off, **not yet run**.
- 2026-06-05 (7, MBP): **claude settings cleanup + iTerm drift fix.** 6 dead keys stripped from `claude/settings.json` (`mcpServers` is *ignored* in settings.json — glif/playwright re-registered user-scope in `~/.claude.json`, `claude mcp add` lines added to bootstrap). iTerm root cause found: custom-folder mode was on **auto-save**, silently writing live state over the repo plist every quit → save-mode now Manually (`NoSync*` keys pinned in bootstrap), fresh deliberate snapshot + startup arrangement set. New loop: change setting → Save Now → commit. **Open:** `GLIF_API_TOKEN` not exported in shell yet — glif MCP fails auth until the vault-to-env hookup.
- 2026-06-05 (4): **universal `--help` + inline comments + per-family docs across all 32 `bin/` scripts** (6 parallel family agents; gold standard = `fs-rm-folder-smart.sh`). Fixed 5 latent bugs surfaced in the pass (vid output-name collision → distinct suffixes, prores `nullglob`, missing `hvc1` tags, art-process old-name echo, ss-save shebang). The in-repo `bin/_bak/` quarantine **moved out to `~/_temp/bin_bak/`** — superseded scripts no longer live in the repo (convention updated in `12-scripts/INDEX.md`).
- 2026-06-05 (8, iMac): **two-machine sync** — iMac stash `-u`/rebase/pop onto the MBP's pushed work, clean (`.zshrc` auto-merge verified). User committed `c177baf`: new `docs/13-terminal-browsers/` (carbonyl, w3m), `carbonyl()`/`hn` in `.zshrc`. Both machines verified on `c177baf`.
- 2026-06-05 (9, iMac): **Quick Action generator** — `bin/qa-make.sh` stamps Finder Quick Actions from one line (tracked in `macos/services/`, symlinked, pbs-flushed); `bin/fs-shoot.sh` = clash-safe shoot-to-folder mover. Preset live: *Shoot to _trash* (per-file sibling `_trash/`). `bootstrap.sh` services block now glob-loops `*.workflow`. Doc: `12-scripts/10-quick-actions.md`.
- **The user owns all git** — agent never commits; advise and hand off.

---

## Repo layout

| path | role |
|---|---|
| `Brewfile` | unified package manifest (mirror retired 2026-06-05) |
| `bootstrap.sh` | installer: `brew bundle`, then symlinks shell/git/ssh/vscode/iterm/mpv/**claude** + runs `macos/defaults.sh` |
| `TOOLING.md` | tooling **audit**: drift, reconciliation, cross-arch portability, open items |
| `docs/` | tooling **catalog**: 52 kol-docs `reference` docs, 11 categories + root INDEX |
| `claude/` | repo-backed `~/.claude`: CLAUDE.md, settings.json, skills/, hooks/, commands/, agents/, output-styles/ |
| `meta/` | secrets/setup: `BITWARDEN-SETUP.md`, `SECRETS_TO_MOVE.txt` |
| `macos/defaults.sh` | macOS defaults baseline (Finder/keyboard/screenshots/Dock/…) |
| `shell/` `git/` `ssh/` `iterm/` `vscode/` `mpv/` `nvim/` `bin/` `scripts/` | the usual dotfiles configs + helper scripts |
| `docs/llm-context/` | this agent-context protocol |
| `LLM_RULES.md` / `.claude/skills/` | session-boot protocol + repo-local `/init-agent`, `/log-work` |

`claude/skills/`: **bucket, init-agent-context, init-agent-context-sync, init-scaffold, kol-docs** (kol-docs bundles `_framework/`).

---

## Critical consistency seams

### Brewfile mirror — RETIRED
`Brewfile-mirror.txt` left the repo 2026-06-05; the byte-identical sync rule died with it. Single manifest now. (ARCHITECTURE §2.)

### ~/.claude symlinks
`claude/*` is symlinked into `~/.claude/`. Editing `~/.claude/CLAUDE.md`, `settings.json`, `skills/…` edits the repo. `bootstrap.sh` recreates the links.

### Cross-arch paths
Intel iMac = `/usr/local`, Apple-Silicon MBP = `/opt/homebrew`. No hardcoded prefixes in tracked files. (ARCHITECTURE §1.)

### kol-docs framework
`claude/skills/kol-docs/SKILL.md` reads its canon from `claude/packages/kol-docs-framework/`. Shared skill **dependencies** (frameworks, templates) live in `claude/packages/`, never inside a skill.

---

## Open items (live)

- [x] ~~mbp caveman purge~~ — **EXECUTED + verified 2026-06-05** (agent ran it directly). `settings.json`+`hooks/` symlinked to repo, plugin cache/marketplace/registry stripped, old settings parked at `~/_temp/settings-caveman-bak.json`. MBP `~/.claude` now fully on repo truth. Caveman speech clears on next session restart.
- [ ] Resolve p10k / zsh-plugin duplication — brew vs oh-my-zsh, pick one source.
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
