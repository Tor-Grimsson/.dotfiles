---
name: brewfile-is-canonical
description: Every brew install must be recorded in ~/.dotfiles/brewfile immediately; no tombstone comments for removed packages
metadata: 
  node_type: memory
  type: feedback
  originSessionId: bdb2606b-f03d-4fdb-b1c9-ef744c6e6383
---

When anything is installed via Homebrew, add it to `~/.dotfiles/brewfile` in the matching section (tap in the Taps section if needed) as part of the same task. Conversely, when a package/tap is removed, delete its line outright — never leave "NOTE: X was untapped/removed" tombstone comments (user has repeatedly removed these, e.g. the maniacsan/torrra note, 2026-06-05).

**Why:** The brewfile is the user's canonical machine-state record; drift or historical noise in it defeats its purpose. Audit history belongs in TOOLING.md / session logs, not the brewfile.

**How to apply:** After `brew install X`, immediately edit the brewfile (entry + one-line comment matching section style). On removal, delete the line. Verify with `brew bundle list --file ~/.dotfiles/brewfile`.
