# 2026-06-05 — home-config audit: what's tracked vs noise, relink the strays

Audited everything in `~` for "what should go through dotfiles but doesn't." Root cause: bootstrap had only ever been *partially* applied to the iMac — many configs were real, diverged files, so repo edits never propagated. Reconciled and relinked; pulled in genuinely-untracked tool configs; moved two secrets to Bitwarden; one leaked credential found and removed.

## Linkage fixed (were real/diverged files → now symlinks to repo)
- `.zprofile` (repo was the superset — arch-guarded brew shellenv + OrbStack), `.p10k.zsh`, `.gitconfig` (repo has the git-lfs block live lacked), `.ssh/config` (repo has the `ubuntu-vm` host).
- `nvim` — **live `init.lua` was ground truth** (diverged from repo); copied live→repo, then linked the dir.
- `mpv` — live dir was empty; linked the two repo confs in.
- VSCode `settings.json` — see leaked-secret note below.
- All diverged live files parked as `*.bak` before linking (listed in `meta/HOME-CONFIG-AUDIT.md`).

## Newly tracked (had no repo home)
- `yazi/keymap.toml`, `broot/{conf,verbs}.hjson` + `skins/` — both *referenced by `.zshrc`*. Per-file symlinks (leaves the tools' runtime dirs intact). `bootstrap.sh` updated with nvim + yazi + broot link blocks.
- **ghostty: dropped** — user doesn't use it. **orbstack `docker.json`: skipped** — was empty `{}`.

## Secrets
- **LEAKED: MiniMax JWT** (`ANTHROPIC_AUTH_TOKEN`) was committed in repo `vscode/settings.json`, inside a `claudeCode.environmentVariables` block hijacking Claude Code → MiniMax-M2. User chose **option A** (live minimal settings = truth); repo file replaced with the 16-line live version → token gone from working tree. **User must REVOKE the token** (in git history if ever committed). Written to `~/secrets-to-revoke.txt` (outside repo).
- **B2 application key** from `rclone.conf` → Bitwarden (`kol-tokens/rclone-kolkrabbi-b2`, keyID=username, key=password). `rclone.conf` stays machine-local; recreate via new `meta/RCLONE-SETUP.md`.

## iTerm — already correct
Repo `iterm/` IS the live source (`com.googlecode.iterm2 LoadPrefsFromCustomFolder` → `~/.dotfiles/iterm`). Not a symlink, a custom-prefs-folder pointer. Leave alone.

## Docs
- `meta/HOME-CONFIG-AUDIT.md` (new) — tracked vs machine-local vs noise table; the `*.bak` cleanup list. Makes the next audit a diff.
- `meta/RCLONE-SETUP.md` (new). `meta/SECRETS_TO_MOVE.txt` rewritten from generic boilerplate → the real secret inventory (user: "none of those are relevant").

## Continued — cleanup, Terminal, compfix
- **compfix:** making fpath arch-correct exposed `/usr/local/share`'s Homebrew group-writability → oh-my-zsh refused to load completions. Added `ZSH_DISABLE_COMPFIX=true` before `oh-my-zsh.sh` in `shell/.zshrc` (trust admin group on a personal machine; chmod would fight brew).
- **Cleanup executed:** all relink `*.bak` + `.zcompdump*` (5 per-host caches) **deleted** (symlinks verified). Stray loose files at `~` (`package-lock.json`, `readme.{html,md}`, `__pycache__/`, `aaa-test/`) **moved to `~/_temp/`** (quarantine).
- **Terminal.app now tracked:** `terminal/com.apple.Terminal.plist` (default profile "tog") via `defaults export`; `bootstrap.sh` restores with `defaults import` (cfprefsd-cached, can't symlink); `terminal/README.md` documents the re-export-after-tweak catch.
- **`meta/HOME-CONFIG-AUDIT.md`** updated (Terminal row, cleanup record).

## Proposed but NOT done (user deferred — "whatever, just log work")
Home-dir is visually cluttered because `AppleShowAllFiles=true` exposes every legacy `~/.tool` dotfile. Discussed but not executed:
1. Re-hide dotfiles in Finder (`AppleShowAllFiles` → false) — biggest visual win, zero risk.
2. `rm -rf ~/.claude-server-commander` — confirmed-dead Desktop Commander MCP (already an open item).
3. XDG env block in `.zshenv` (`XDG_*` + cooperative tool homes) to nest *future* tool state into `.config`/`.cache`/`.local`; also `SHELL_SESSIONS_DISABLE=1` (kills `~/.zsh_sessions`) + relocate `.zcompdump` → `~/.cache/zsh/`. Explicitly NOT force-migrating live `.cargo`/`.rustup`/`.npm` (re-download/break risk).

## Next steps
- **Revoke the MiniMax token**, then `rm ~/secrets-to-revoke.txt`.
- Store `GLIF_API_TOKEN` in the vault (still pending).
- Decide on the deferred 1–3 above (Finder re-hide / kill `.claude-server-commander` / XDG block).
- MBP still unaudited — same relink check needed there (different divergences expected).
- Working tree left uncommitted for the user.
