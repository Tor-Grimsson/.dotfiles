---
name: feedback-no-provisioning
description: "Don't run brew bundle/install/upgrade or other machine provisioning — the user runs bootstrap.sh themselves"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a43b2656-7bcb-4654-aa60-2d6ff7d33b17
---

Do **not** run provisioning commands on the user's machine: `brew bundle`, `brew install`, `brew upgrade`, `bootstrap.sh`, or anything that installs/changes software state. Editing the manifest is fine; *applying* it is the user's job.

**Why:** the user owns machine actions. `bootstrap.sh` (which runs `brew bundle`) is the mechanism *they* run — same boundary as the no-git rule. They flagged it when I ran `brew bundle` myself after they said "install."

**How to apply:** prepare the `Brewfile`/scripts/symlinks, then hand off — tell them what to run (`./bootstrap.sh` or `brew bundle`). Let them execute. Read-only checks (`brew info`, `--dry-run`, `brew list`) are fine; mutations are not unless explicitly told "you run it." See [[project-dotfiles-two-machines]] and [[feedback-no-commits]].