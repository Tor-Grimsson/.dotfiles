# Session: tmux symlink on the iMac

**Date:** 2026-06-10
**Agent:** Claude Code (Grim), iMac
**Summary:** Closed the tmux cross-machine arc — the repo content had already synced to the iMac (`3406e52`), but `~/.tmux.conf` didn't exist here; created the symlink.

## Changes Made

- `~/.tmux.conf` → `~/.dotfiles/tmux/.tmux.conf` — created (machine-local, no repo change).
- No tracked files touched.

Clarified along the way: the dot-sync daemon moves committed repo content only — it never creates `$HOME` symlinks. Bootstrap *would* create the link (`bootstrap.sh:26`) but is the full installer (`brew bundle`, defaults, Terminal import); convention stays "hand-link on the machine where the config lands, bootstrap covers fresh setups."

## Current State

- tmux config live on **both machines** (MBP linked last session, iMac this session).

## Next Steps
1. `prefix r` in any already-running tmux session to reload; new sessions pick it up automatically.
