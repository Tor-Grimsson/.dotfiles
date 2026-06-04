---
_template:
  version: 1
  path: .llm-context/plan.md
  sync: skip
---

# dotfiles — future exploration

Not-yet-committed ideas. Graduate items into `AGENT-CONTEXT.md` (Open items) when they become real work.

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

Nothing here is committed. This is a thought exercise until items move to `AGENT-CONTEXT.md`.
