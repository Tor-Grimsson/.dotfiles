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
- **Not committed by the agent** — the user owns all git. Working tree was left ready for the user's commit.

---

## Repo layout

| path | role |
|---|---|
| `Brewfile` / `Brewfile-mirror.txt` | unified package manifest + **byte-identical** mirror |
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

### Brewfile mirror
`Brewfile` and `Brewfile-mirror.txt` must stay byte-identical. Edit one → edit the other in the same pass. (ARCHITECTURE §2.)

### ~/.claude symlinks
`claude/*` is symlinked into `~/.claude/`. Editing `~/.claude/CLAUDE.md`, `settings.json`, `skills/…` edits the repo. `bootstrap.sh` recreates the links.

### Cross-arch paths
Intel iMac = `/usr/local`, Apple-Silicon MBP = `/opt/homebrew`. No hardcoded prefixes in tracked files. (ARCHITECTURE §1.)

### kol-docs framework
`claude/skills/kol-docs/SKILL.md` reads its canon from `claude/packages/kol-docs-framework/`. Shared skill **dependencies** (frameworks, templates) live in `claude/packages/`, never inside a skill.

---

## Open items (live)

- [ ] **mbp `~/.claude` reconcile.** The MBP runs Claude from iCloud `Workbox/.claude` with a *different* CLAUDE.md (8 KB/18 May vs repo's 7 KB) and divergent skills. **Do not `bootstrap.sh` the MBP until reconciled**, or fresher iCloud context is stranded.
- [ ] Resolve p10k / zsh-plugin duplication — brew vs oh-my-zsh, pick one source.
- [ ] Decide pipx → uv consolidation; decide whether brew `node` stays on the MBP (pnpm self-manages it). **2026-06-05: Python variants 4 + 5 found on the MBP** — miniconda (`conda init` block in shared `shell/.zshrc` pollutes iMac PATH) and python.org framework 3.13 (its installer had written PATH lines through the symlink into tracked `shell/.zprofile` — repo file cleaned + brew shellenv arch-guarded same day; MBP uninstall steps in TOOLING.md § Python).
- [ ] `brew upgrade` on each machine when convenient (the bundle install/upgraded the iMac on 2026-06-04 but lots stay outdated).
- [ ] Optional adds called out in TOOLING.md: czkawka (already in), tdf (PDF TUI), fclones (faster exact dedup).
- [ ] `rm -rf ~/.claude-server-commander` — orphaned Desktop Commander MCP logs (still present, confirmed in 2026-06-05 home audit).
- [ ] **Home-dir declutter (deferred 2026-06-05):** Finder `AppleShowAllFiles`→false (re-hide legacy `~/.tool` dotfiles); XDG env block in `.zshenv` to nest *future* tool state + `SHELL_SESSIONS_DISABLE=1` + relocate `.zcompdump`→`~/.cache/zsh/`. Do NOT force-migrate live `.cargo`/`.rustup`/`.npm`. Detail in `session-log/2026-06-05-home-config-audit-relink.md`.
- [x] ~~MiniMax token~~ — removed from repo; user confirmed unused ~9mo, left dormant; `~/secrets-to-revoke.txt` deleted. ~~GLIF_API_TOKEN~~ — already in vault (kol-tokens `Glif`, **in NOTES not password**). ~~`.claude-server-commander`~~ deleted.
- [ ] **Vault dedup (user's call):** B2/rclone items overlap (`Backblaze B2 Credentials` = account master vs `rclone – kolkrabbi — b2` = app key, prefixes baked in). Agent's accidental 3rd item already deleted. See `meta/SECRETS_TO_MOVE.txt`.
- [ ] **MBP home-config audit** — same relink check as the iMac got; expect different divergences.
- [ ] **Rotate the Jackett API key** (was committed in `bin/tor-search` → in git history). Stored in the vault 2026-06-05 (`kol-tokens/Jackett`) but it's still the leaked key — regenerate in the Jackett dashboard, update the vault item. `GLIF_API_TOKEN` still needs storing (same pattern, `meta/BITWARDEN-SETUP.md` §5–6).
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

- `Brewfile` ≡ `Brewfile-mirror.txt` (byte-identical).
- No hardcoded brew prefixes in tracked files.
- **Never run git** (user-owned) and **never run provisioning** (`brew bundle`/`install`/`upgrade`, `bootstrap.sh`) — prepare, then hand off.
- Don't track `~/.claude` runtime state (history/sessions/projects/caches) in the repo.
- Skill **dependencies** (kol-docs framework, init-agent-context + algorithmic-art templates, the `bucket` CLI) live in `claude/packages/` — never bundled inside a skill. Skills reference them at `~/.dotfiles/claude/packages/`.
- **Secrets never go in tracked files as literals** — only as env-var refs (`${VAR}`) sourced from Bitwarden. The glif MCP uses `${GLIF_API_TOKEN}`; the live token lives in Bitwarden, never the repo.
