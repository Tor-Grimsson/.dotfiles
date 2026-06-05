# 2026-06-05 — dot-sync automation (iMac)

Built two-machine auto-sync on the existing repo (chezmoi rejected — would duplicate the symlink system). Transport only, never authorship: the daemon moves committed work, never commits; dirty trees are never touched.

- `bin/dot-sync.sh` — manual = the stash/rebase/pop ritual as one command; `--auto` = daemon mode (clean→pull+push, dirty→hands off + deduped notification, offline→no-op). Logs to `~/Library/Logs/dot-sync.log`.
- `macos/launchd/com.kolkrabbi.dot-sync.plist` — every 30 min + at login; username-agnostic via `zsh -lc` `$HOME` expansion (kolkrabbi/biskup split).
- `bootstrap.sh` — new launchd block (plist **copied** not symlinked, bootout+bootstrap = idempotent).
- `ssh/config` — new `Host github.com` block (`AddKeysToAgent` + `UseKeychain`) for headless SSH push.
- Doc: `docs/12-scripts/11-dot-sync.md` + INDEX row (`dot-` family).
- ARCHITECTURE §N seam flagged and held: agent ran no git; daemon runs as the user and only moves user-authored commits.

## Next steps
- User: commit + push, then on **each machine** run the bootstrap launchd block (or the two `launchctl` lines in `11-dot-sync.md`) and, if the key passphrase isn't in the keychain yet, `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`.
- MBP check: key filename may differ from `id_ed25519` — adjust the ssh/config `IdentityFile` if so (or make it a per-machine include).
- First daemon cycle: verify with `tail ~/Library/Logs/dot-sync.log`.
