# Session: docs → kol-vault mirror + post-commit hook

**Date:** 2026-06-25
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Automated getting `~/.dotfiles/docs/` into the Obsidian kol-vault so it's readable on the iMac, MBP, and iPad. Built two parallel mirrors (symlink + rsync) and a tracked `post-commit` hook that refreshes the rsync copy whenever a commit touches `docs/`. Most of the work landed in the **kol-vault** repo; the dotfiles side gained the hook + bootstrap wiring + catalog doc.

## Context

The user kept hand-copying the latest `docs/` into the vault. Wanted it automated. The iPad has no `.dotfiles` folder and gets the vault via git, so a symlink alone can't reach it — git stores a symlink as a dangling pointer, not the bytes.

## Changes Made (this repo)

### Files Added
- `git-hooks/post-commit` — tracked hook. Fires only when a commit changed something under `docs/` (`git diff-tree … -- docs/`), then runs the vault's `sync-dotfiles-docs-rs.sh` if present + executable. No-op otherwise (e.g. a machine without the vault). `bash -n` clean.
- `docs/12-scripts/13-docs-mirror.md` — `reference` doc covering both mirrors, why two, the scripts, the hook, install/refresh.

### Files Modified
- `bootstrap.sh` — new block (after tmux) symlinks `git-hooks/post-commit` → `.git/hooks/post-commit` + `chmod +x git-hooks/*`. `.git/hooks/` is untracked runtime state, so the hook body is the tracked artifact and bootstrap re-installs it per machine.
- `docs/12-scripts/INDEX.md` — note after the prefix table pointing at `13-docs-mirror` (it's a git-hook, not a `bin/` prefix, so no count-table row).
- `docs/12-scripts/11-dot-sync.md` — reciprocal `related: [[13-docs-mirror]]`.

### Vault side (separate repo, for the record)
- `kol-library/kol-dotfiles-docs-sm/` — per-child **symlinks** (live, gitignored).
- `kol-library/kol-dotfiles-docs-rs/` — **rsync** real copy (tracked → reaches iPad). 141 md, agent files excluded.
- Vault scripts `_system/_kol-config/_files/_scripts/{relink-dotfiles-docs-sm,sync-dotfiles-docs-rs}.sh`.
- Vault `.gitignore`: `-sm` ignored, `-rs` tracked.
- Both mirrors skip `llm-context/`, `history.md`, `plan.md`, `.DS_Store`.

## Current State

### Working
- Hook installed + executable on the iMac (`.git/hooks/post-commit` → tracked file). Bash valid.
- The rsync payload is proven — a manual run synced 141 md into `-rs`.

### Known Issues / Notes
- **Hook git-detection not yet exercised** — verifying it needs a real `docs/` commit (agent doesn't run git). The next docs commit will show the `Synced N md files` line.
- The two mirrors are deliberately side-by-side for the user to evaluate symlink vs rsync; one may be retired later.
- Cross-repo coupling: the dotfiles hook calls a script that lives in the vault. Guarded on presence, but a vault-side rename would silently stop the auto-refresh.

## Next Steps
1. Run `bootstrap.sh` on the **MBP** to install the hook there.
2. Make a `docs/` commit to confirm the hook fires.
3. Decide symlink vs rsync after living with both; retire the loser.
