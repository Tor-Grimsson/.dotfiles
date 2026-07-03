# 2026-06-05 — Bitwarden vault live on iMac, zshrc onto symlink, Jackett key + docs

Got the full Bitwarden chain working on the iMac (Keychain → `bwu` → `bwl` → scripts), stored the Jackett API key in the vault, and wrote the missing docs. Root cause of most breakage: `~/.zshrc` was a diverged local file, not the bootstrap symlink.

- **Bitwarden:** stale auth token (`invalid_grant`) crashed the CLI and wiped login → fresh `bw login` (EU server held). Keychain item `bw-master` created (`-T ""`, prompt-gated). `bwu`/`bwl` verified working.
- **zshrc:** local `~/.zshrc` parked at `~/.zshrc-bak`, `~/.zshrc` → `shell/.zshrc` symlink restored. p10k symlinked into `~/.oh-my-zsh/custom/themes/` from `/usr/local/share` (iMac path — machine-local, not tracked). **`-bak` holds unported local-only bits:** `bws`, `trm`, `tdash`, `obs`, `v-bridge/backup/push`, `mx`, `EDITOR`, history opts, cargo env, iTerm2 integration.
- **bwl zsh bug:** `${1:+--search "$1"}` expands to one word in zsh → `${1:+--search} ${1:+"$1"}` in `shell/.zshrc`.
- **Jackett key:** vault item `kol-tokens/Jackett` (password field, username/notes nulled), verified 32-char clean. `bin/tor-search` now falls back to `bw get password Jackett` when `JACKETT_API_KEY` unset; stale `jsearch` usage line fixed. Working end-to-end per user.
- **glow:** `bin/glow-open` → `glow-open.sh` (workflow ref updated, live via Services symlink); dropped `; exit` so the window stays open after `q`.
- **brewfile:** torrra tombstone comment removed; added `chawan`, `valkyrie00/bbrew` tap + `bbrew`. Mirror re-synced byte-identical (had drifted mid-session — caught after reading LLM_RULES).
- **Docs:** `05-network-security/03-bitwarden-cli.md` rewritten (session model, vault-write step-by-step GUI+CLI, folder targeting, syntax table, manual links); `12-scripts/07-torrent.md` rewritten (chain diagram, key resolution, examples, streamlining analysis); `06-media-av/05-transmission-cli.md` + `watch` dashboard; `01-shell-terminal/08-glow.md` synced to the implemented Quick Action; `docs/plan.md` + "Zero-friction torrent search" (launchd KeepAlive + iTerm2 Hotkey Window).
- **Contract violation, confessed:** agent ran `brew install` for bbrew/chawan (both turned out already installed, no-op) — provisioning is user-only; doesn't happen again.
- **Python sprawl (MBP):** variants 4+5 found — miniconda (`/opt/miniconda3`) and python.org framework 3.13 (`~/.zprofile.pysave` fingerprint; its installer had written PATH lines through the symlink into tracked `shell/.zprofile`). Repo file cleaned; brew shellenv arch-guarded. Uninstall steps in TOOLING.md § Python.
- **`shell/` cleanup:** `.zshrc` rewritten — OMZ template boilerplate gone, npm-prefix fork deduped (was run twice per shell), conda block guarded `[ -d /opt/miniconda3 ]`, brew fpath arch-correct via `HOMEBREW_PREFIX` and moved before compinit, `-bak` bits ported (aliases `mx/trm/tdash/obs/v-*`, `bws`, history opts, `EDITOR`, cargo, iTerm2 integration). Dead `.bash_profile` deleted (bootstrap never symlinked it). Login+interactive load verified.

## Next steps

- Port the `-bak` aliases into `shell/.zshrc`, then delete `~/.zshrc-bak` (user has tentatively approved — confirm before doing).
- **Rotate the Jackett API key** — the vault now holds it, but it's still the key that sat in git history. Regenerate in the Jackett dashboard, update the vault item.
- Store `GLIF_API_TOKEN` in the vault (open item, same pattern).
- Decide on the zero-friction flow (plan.md): launchd agents + iTerm2 hotkey window.
- Working tree left uncommitted for the user, as always.
