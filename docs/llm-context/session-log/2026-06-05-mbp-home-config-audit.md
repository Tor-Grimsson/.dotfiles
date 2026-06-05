# 2026-06-05 — MBP home-config audit + sync reconcile (the iMac sweep's counterpart)

Ran on the MBP after pulling the iMac's 279-file push. First: stash forensics — the user's pre-pull `git stash -u` held only 3 mpv files, byte-diffed identical to the pulled versions, dropped safely. Then the MBP audit the iMac logs called for.

## Findings (full table in `meta/HOME-CONFIG-AUDIT.md` § MBP audit)

- **Most of the MBP was already on repo truth** — shell/git/ssh/vscode/bin all symlinks, iTerm pointer correct, mpv real-but-identical. The pull updated them live.
- `~/.config/{nvim,yazi,broot}`, glow, Quick Actions: absent → bootstrap link = pure gain.
- **`~/.claude` is the only real divergence**: live CLAUDE.md was fresher (kol-system docs section), live settings.json carries caveman (plugin/hooks/statusline) + granular git permissions vs repo's glif + deny-all-git; live 5 skills are stale iCloud-era copies superseded by repo.
- iCloud `Workbox` holds only a project-local `.claude` — **the "MBP runs Claude from iCloud" warning is dissolved**; nothing user-scope stranded.

## Fixes applied to repo

- `claude/CLAUDE.md` — kol-system docs section ported from live; **live vs repo now byte-identical**.
- `shell/.zshrc:76-78` — `obs`/`v-bridge`/`v-backup` un-hardcoded `/Users/biskup` → `$HOME`.
- `.claude/skills/init-agent/SKILL.md` — 5× `/Users/biskup/.dotfiles` → `~/.dotfiles`.

## Reconcile executed (same session, user: "keep walking")

- Linked to repo: `~/.config/{mpv,nvim,yazi,broot}`, glow prefs, all 4 Quick Actions (+`pbs -flush`), `~/.claude/{skills,agents,commands,output-styles,CLAUDE.md}`. Stale live skills parked at `~/_temp/claude-skills-pre-reconcile/`. Repo skills verified live mid-session (skill list refreshed).
- Caveman kept **machine-local** (decision made per standing recommendation): `settings.json` + `hooks/` NOT linked.
- Live `settings.json` edit was blocked by the harness (self-modification wall — the one permission wall of the session). Merged file written to `~/.claude/settings.json.reconciled` instead: live + glif MCP + `mcp__glif` allow + `skipWorkflowUsageWarning` + caveman hook node un-pinned to `/opt/homebrew/bin/node`. JSON validated.
- Node-pin urgency confirmed real: machine runs node 26.0.0; pinned keg `25.9.0_1` survives only until `brew cleanup`.

## Continued — settings applied, bootstrap run, repairs, docs

- **settings.json applied** (user ran the `mv` via `!`): glif MCP in, caveman intact, node un-pinned. Verified.
- **User ran `./bootstrap.sh`**: brew bundle mostly fine; 3 failures triaged — czkawka false alarm (installed; only `webp-pixbuf-loader` postinstall warning), hiddenbar = the documented adopt gotcha (user removed the old 1.8 app), **obsidian: brew's rollback DELETED `/Applications/Obsidian.app`** after an `xattr` permission error (vaults safe; reinstall pending, may need App Management permission for iTerm). `set -e` aborted bootstrap at the bundle failure → Terminal import + `defaults.sh` never ran (harmless; symlinks were already live).
- **bbrew dropped** from Brewfile + tap line (user: not what they thought) — uninstall/untap commands handed off. Taps `charmbracelet/tap` + `siddharthvaddem/openscreen` trusted (`brew trust`).
- **`Brewfile-mirror.txt` retired** — file left the repo in the iMac push; ARCHITECTURE §2 + AGENT-CONTEXT contract lines updated to single-manifest reality.
- **Quick Actions**: all 4 linked + pbs-registered; per-machine bits remain (Services enable toggles, ⇧⌥⌃A/S re-binds).
- **`bwenv` helper** added to `shell/.zshrc` (GLIF notes-field + Jackett password-field gotchas baked in); `BITWARDEN-SETUP.md` §6 synced.
- **New doc:** `docs/05-network-security/08-vault-to-env-pattern.md` — vault→env drilled 5×, plus §6 one-shot (file → folder → vault → env, jq pipeline dry-run verified). INDEX + bitwarden-cli cross-linked.

## Next steps

- User: `brew uninstall bbrew && brew untap valkyrie00/bbrew`; `brew install --cask obsidian` (App Management permission if xattr repeats); `./macos/defaults.sh` if wanted (bootstrap never reached it); Terminal import optional.
- User: re-bind ⇧⌥⌃A/S + tick the 4 services in System Settings → Keyboard → Shortcuts → Services.
- Delete `~/_temp/claude-skills-pre-reconcile/` once the new skills have proven out.
- **INCOMPLETE: "Open in glow" ⌃⇧G shortcut doesn't dispatch on the MBP** — script + workflow verified healthy, bind exists in pbs.plist; break is keypress→service dispatch. Candidates: re-login / first-run permission dialog / key conflict. Full state + agent's verification mistakes recorded in `docs/01-shell-terminal/08-glow.md` § MBP keyboard-shortcut status.
- Jackett rotation + MiniMax revoke: **closed by user decision** (LAN-only / unused) — removed from open items, do not re-raise.
- hiddenbar reinstalls on next bundle (app was removed — confirm wanted).
- Working tree left uncommitted for the user, as always.
