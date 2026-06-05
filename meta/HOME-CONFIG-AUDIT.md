# Home-directory config audit — relevant vs noise

Snapshot of what in `~` is tracked by this repo vs deliberately ignored, so the next
audit is a diff, not a re-investigation. Last swept **2026-06-05** (iMac); **MBP swept 2026-06-05** (see § MBP audit at the bottom).

## Tracked (repo is the source; symlinked by `bootstrap.sh`)

| Live path | Repo path | Link style |
|---|---|---|
| `~/.zshrc` `~/.zprofile` `~/.p10k.zsh` | `shell/` | file |
| `~/.gitconfig` | `git/.gitconfig` | file |
| `~/.ssh/config` | `ssh/config` | file |
| `~/.config/nvim` | `nvim/` | dir |
| `~/.config/mpv/{mpv,input}.conf` | `mpv/` | file |
| `~/.config/yazi/keymap.toml` | `yazi/` | file |
| `~/.config/broot/{conf,verbs}.hjson` + `skins/` | `broot/` | file/dir |
| `~/bin` `~/.local/bin/*` | `bin/`, `claude/packages/` | dir/file |
| `~/.claude/*` | `claude/` | file/dir |
| VSCode `settings.json` + `keybindings.json` | `vscode/` | file |
| iTerm prefs | `iterm/` | **custom-folder** (iTerm `LoadPrefsFromCustomFolder` → `~/.dotfiles/iterm`, not a symlink) |
| Terminal.app prefs | `terminal/com.apple.Terminal.plist` | **import/export** (cfprefsd-cached, can't symlink — see `terminal/README.md`) |
| glow, Quick Actions | `glow/`, `macos/services/` | file/dir |

## Machine-local (NOT tracked — holds secrets or is per-host)

| Path | Why |
|---|---|
| `~/.config/rclone/rclone.conf` | B2 key → Bitwarden; recreate per `RCLONE-SETUP.md` |
| `~/.local/share/jackett/…/ServerConfig.json` | Jackett app install; API key → Bitwarden (`Jackett`) |

## Noise (never track — regenerable state / cache / cloud-synced)

- `~/.config/raycast` (**~325 MB** — Raycast cloud-syncs real settings to your account)
- `~/.local/share/claude` (~837 MB), `~/.local/share/jackett` (app install), `~/.local/share/nvim`, `~/.local/pipx` — package/runtime data
- `~/.iterm2/` (it2* utilities, iTerm-installed) · `~/.iterm2_shell_integration.zsh` (auto-generated) · `~/.config/iterm2` (empty)
- `~/.vscode` (~45 MB extensions/cli) · `~/.vscode-shared`
- `~/.orbstack` (VM state; `config/docker.json` was empty `{}` — nothing to track)
- `~/.zsh_sessions` `~/.zcompdump` `~/.cache` `~/.npm` `~/.DS_Store`
- `~/.config/{configstore,gtk-2.0,sanity,TagStudio,yarn}`, `~/.config/git` (global gitignore lives in repo gitconfig)
- `~/.config/Raincoat.json` — Raycast Jackett-frontend, `jackett_apikey` empty/unused → delete

## Cleanup done (2026-06-05)
- Relink `*.bak` files (`.zprofile.bak`, `.p10k.zsh.bak`, `.gitconfig.bak`, `.ssh/config.bak`,
  `.config/nvim.bak`, yazi/broot baks, Code `settings.json.bak`, `.zshrc-bak`) — **deleted**, symlinks verified.
- `.zcompdump*` (5 per-host completion caches) — **deleted** (regenerable).
- Stray loose files at `~` (`package-lock.json`, `readme.{html,md}`, `__pycache__/`, `aaa-test/`)
  — **moved to `~/_temp/`** (quarantine, not deleted).
- Not-mine baks left in place: `~/.claude/settings.json.bak`, `~/Library/Preferences/com.apple.Terminal.plist.bak`, an Ardour project bak.
- `~/secrets-to-revoke.txt` kept until the MiniMax token is revoked.

---

## MBP audit (2026-06-05)

Same relink check the iMac got. Surprise: most of the MBP was **already on repo truth** — only `~/.claude` diverges.

### Already symlinked to repo (no clobber risk; pull updated them live)

`~/.zshrc` `~/.zprofile` `~/.p10k.zsh` `~/.gitconfig` `~/.ssh/config` `~/bin` — all symlinks ✓.
VSCode `settings.json` + `keybindings.json` — symlinks ✓. iTerm — custom-folder pointer at `~/.dotfiles/iterm` ✓.
No `~/.zshrc-bak` / `~/.zshenv` / `~/.bash_profile` strays. Interactive zsh loads clean.

### Real files, byte-identical to repo (symlink = zero loss)

`~/.config/mpv/{mpv,input}.conf` — verified identical; `watch_later/` is runtime, untouched by bootstrap.

### Missing entirely (bootstrap link = pure gain)

`~/.config/{nvim,yazi,broot}`, glow prefs, `~/Library/Services/*` (all 4 Quick Actions absent).

### Diverged — `~/.claude` (the one real reconcile)

| Item | Live (MBP) | Repo `claude/` | Verdict |
|---|---|---|---|
| `CLAUDE.md` | 8 KB, has **"Docs in kol-system projects"** section | lacks that section, otherwise identical | **live fresher** — section ported to repo 2026-06-05 (this audit) |
| `settings.json` | caveman (plugin + marketplace + hooks + statusline), granular git allow/deny, voice | glif MCP + `mcp__glif`, deny-ALL-git, `skipWorkflowUsageWarning` | **merge needed — user decision** (see below) |
| `skills/` (5) | iCloud-era: point at dead kol-system path + bundled `templates/` | repointed at `claude/packages/` (templates byte-identical), +12 more skills | **repo fresher** — link safe |
| `hooks/` | caveman runtime (7 files) | empty | linking **kills caveman** |
| `agents/commands/output-styles` | absent | 4 kol agents | link = gain |
| `plugins/ projects/ history…` | runtime state | not tracked (by design) | bootstrap doesn't touch |
| `settings-1.json`, `settings.json.bak` | stale local artifacts | — | delete candidates |

iCloud `Workbox` holds only a **project-local** `.claude` (kol-vault-workbox — empty agents/commands + 69-byte settings.local.json). Nothing user-scope is stranded there; the old "MBP runs Claude from iCloud" warning is dissolved by this audit.

### The caveman decision (blocks `~/.claude` linking)

Repo decision was "caveman permanently out"; MBP actively uses it (plugin + hooks + statusline). They can't both win through one symlinked `settings.json`. Recommendation: **keep caveman machine-local** — on the MBP, skip the `settings.json` + `hooks` symlinks (lines 55 + 57 of `bootstrap.sh`); manually port the repo-only bits (glif MCP block + `mcp__glif` allow + `skipWorkflowUsageWarning`) into the live file. Link everything else in the claude block.

Latent bug regardless of decision: caveman hook commands pin `/opt/homebrew/Cellar/node/25.9.0_1/bin/node` — dies on next `brew upgrade node`. Use `/opt/homebrew/bin/node`.

### Repo fixes found by this audit (applied 2026-06-05)

- `shell/.zshrc:76-78` — `obs` / `v-bridge` / `v-backup` aliases hardcoded `/Users/biskup` → now `$HOME` (paths exist on both machines).
- `.claude/skills/init-agent/SKILL.md` — 5× `/Users/biskup/.dotfiles` → `~/.dotfiles`.
- `claude/CLAUDE.md` — kol-system docs section ported from live MBP copy.
- NOT fixed (noted): 1 `biskup` ref in `iterm/com.googlecode.iterm2.plist` (profile working-dir; iTerm falls back gracefully), prose mention in `meta/BITWARDEN-SETUP.md` (accurate as written).
- `~/.local/bin/bucket` is the older May 22 build; repo `claude/packages/bucket` (Jun 5) supersedes — bootstrap link-over is correct.

### Reconcile EXECUTED (2026-06-05, same session)

All links applied manually (agent), so bootstrap's link sections are now no-ops on the MBP:

- `~/.config/{mpv,nvim,yazi,broot}`, glow prefs, 4 Quick Actions → linked to repo (`pbs -flush` run).
- `~/.claude/{skills,agents,commands,output-styles,CLAUDE.md}` → linked to repo. Stale live skills parked at `~/_temp/claude-skills-pre-reconcile/`.
- `~/.claude/settings.json` + `hooks/` kept machine-local (caveman) — the live-settings edit hit the harness permission wall (self-modification), so the merged file sits at **`~/.claude/settings.json.reconciled`** (live + glif MCP + `mcp__glif` allow + `skipWorkflowUsageWarning` + node un-pinned to `/opt/homebrew/bin/node`). User applies with:
  `mv ~/.claude/settings.json.reconciled ~/.claude/settings.json`
- Node-pin urgency confirmed: live hooks point at keg `25.9.0_1`; machine already runs node 26.0.0 — hooks die at next `brew cleanup`.

### Bootstrap verdict (MBP)

Remaining bootstrap value = `brew bundle` (provisioning, user-run), VS Code extension install, Terminal.app `defaults import` (imposes iMac "tog" profile — accept or comment out), `macos/defaults.sh`. All symlinks already live.
