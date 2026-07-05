# Session: bootstrap-cli remote-box verification + tap-trust isolation fix

**Date:** 2026-07-05 (2)
**Agent:** Claude (Sonnet 5)
**Summary:** First real run of `bootstrap-cli.sh` on a foreign/SSH box (`acyr@acyr`) — closes Next Steps #1 from the earlier same-day session. Found and fixed a tap-trust failure that silently aborted the whole CLI install; confirmed and removed the flagged-unverified `pdf2image` line; documented the `./` gotcha that tripped the first invocation attempt.

## Changes Made

### Files Modified
- `brewfile-cli` — removed `tap "raine/workmux"` and `brew "raine/workmux/workmux"`.
- `bootstrap-cli.sh` — added an isolated `brew tap raine/workmux` + `brew install raine/workmux/workmux` step (with its own `note_fail`) after the main `brew bundle` call. Also deleted the `uv tool install pdf2image` line entirely.
- `docs/21-dotfiles/02-provisioning.md` — dropped `pdf2image` from the pipx/uv code block + added a one-line why-dropped note; added a loud callout above the Quickstart about needing `./bootstrap-cli.sh` when already `cd`'d into the repo.

### The back-and-forth
1. User ran `bootstrap-cli.sh` from inside `~/.dotfiles` — `zsh: command not found`. Root cause: bare filename, shell doesn't search `$PWD`. Fixed by running `./bootstrap-cli.sh`; documented loudly per explicit ask.
2. First real run: `brew bundle` hit `Error: Refusing to load formula raine/workmux/workmux from untrusted tap raine/workmux` and reported it as a skipped item — but TPM's `install_plugins` then failed too (`tmux: command not found`). Diagnosis: that box has `$HOMEBREW_REQUIRE_TAP_TRUST` set, and the untrusted-tap error aborted `brew bundle`'s entire run before *any* formula installed — not just workmux. The script's own comment ("brew bundle already tries every line and continues past individual failures") holds for per-formula install failures but not for a rejected tap. Since `tmux` never installed, TPM had nothing to configure — a downstream symptom of the same root cause, not a separate bug.
3. Fix: isolated workmux's tap + formula into their own guarded step in `bootstrap-cli.sh`, run after the main bundle — a workmux/trust failure can now only ever cost workmux, never the rest of the CLI set.
4. Re-run: bundle succeeded (63 deps), workmux tapped/trusted/installed clean. One failure remained: `uv tool install pdf2image` → "No executables are provided by package `pdf2image`; removing tool". This confirms the "unverified" flag from the prior session log — `pdf2image` is a Python library with no CLI entry point, so `uv tool install` (like pipx) has nothing to link. Grepped the repo: nothing imports it (not `bin/`, not docs beyond the install line itself). Deleted rather than chase a working install form for a dependency nothing calls — poppler's `pdftoppm`/`pdftocairo` (already pulled in via imagemagick/yazi) already covers PDF→raster per TOOLING.md's existing note.
5. Final re-run: fully idempotent — `✓ bootstrap: complete — everything installed` (workmux/edge-tts/llm/tpm all reported already-installed, nothing re-triggered).
6. User asked whether `ls` "not working" was a source-`.zshrc` issue — yes: aliases (`ls`→`eza`, etc.) only load when `.zshrc` is read, and the shell session predated the bootstrap symlink. `exec zsh` (full restart) confirmed live: eza-aliased `ls` + oh-my-posh prompt both rendering on the foreign box.

## Current State

### Working
- `bootstrap-cli.sh` verified end-to-end on a real foreign/SSH box for the first time since the CLI/GUI split — brew formulas, pipx/uv tools, shell/git/tmux/claude/nvim/yazi symlinks, TPM plugins all confirmed live.
- Idempotent: a second run makes no changes and reports clean.
- The isolated-tap pattern generalizes — if another third-party-tap formula gets added later, the comment in `bootstrap-cli.sh` explains why it needs the same treatment.

### Known Issues
- None outstanding from this run. A `siddharthvaddem/openscreen` untrusted-tap warning also printed during `brew update` — pre-existing local state on that box, unrelated to this repo's Brewfiles, already tracked as an open TODO in `TOOLING.md` (line ~260).

## Next Steps
None required — this closes out the prior session's open item. `pdf2image`'s install form (prior Known Issue #2) is resolved by removal rather than a working uv/pipx form.
