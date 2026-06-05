# Home-directory config audit — relevant vs noise

Snapshot of what in `~` is tracked by this repo vs deliberately ignored, so the next
audit is a diff, not a re-investigation. Last swept **2026-06-05** (iMac).

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
