---
_template:
  version: 1
  path: docs/plan.md
  sync: skip
---

# dotfiles — future exploration

Not-yet-committed ideas. Graduate items into `llm-context/AGENT-CONTEXT.md` (Open items) when they become real work.

---

## mbp ↔ iMac Claude reconcile

**Premise:** the MBP's `~/.claude` lives in iCloud Workbox and has diverged (different CLAUDE.md, different skills) from the repo. Bring it under git without losing the fresher iCloud-side work.

### shape
A one-time merge run from either machine: union the skills (newest-wins on collisions), reconcile CLAUDE.md, then point the MBP's `~/.claude` at the repo via `bootstrap.sh`. Leave the iCloud copy as a frozen backup until verified.

### open questions
- Is the MBP's `~/.claude` a symlink into iCloud, or a real dir copied there? Determines the cutover steps.
- Which CLAUDE.md wins, or do they merge? (User: "idc, whatever" — default to the newer MBP one, port any repo-only rules.)

### kill criteria
If the MBP work turns out to be throwaway, just `bootstrap.sh` the MBP and overwrite.

---

## macOS defaults coverage

`macos/defaults.sh` is a baseline. Could grow: trackpad/scroll tuning, Safari/Finder power-user flags, screenshot subtypes, hot corners — but keep it to defaults the user actually wants, not a 300-line dump.

---

## Zero-friction torrent search

**Premise:** anywhere in the UI → global hotkey → terminal drops down → `tor-search query` → pick → downloading. Full friction analysis in `docs/12-scripts/07-torrent.md` § Streamlining.

### shape
1. launchd user agents (`KeepAlive`) for Jackett + `transmission-daemon` — no cold start, the big win.
2. iTerm2 Hotkey Window (built-in) as the global-hotkey terminal — zero code.
3. Optional: self-healing daemon start + query stash inside `tor-search`; fzf result picker; loop mode.

### open questions
- launchd plists tracked in the repo (machine-local paths — Jackett binary is gitignored) or documented per-machine in `meta/`?
- Does the iMac want transmission-daemon always-on, or on-demand?

### kill criteria
If the hotkey window goes unused after a few weeks, drop the launchd agents and keep plain `tor-search`.

---

Nothing here is committed. This is a thought exercise until items move to `llm-context/AGENT-CONTEXT.md`.
