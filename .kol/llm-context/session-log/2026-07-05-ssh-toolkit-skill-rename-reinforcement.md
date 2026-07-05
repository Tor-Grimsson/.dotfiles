# Session: SSH/mosh remote toolkit + skill rename/reinforcement restructure

**Date:** 2026-07-05
**Agent:** Claude (Sonnet 5)
**Summary:** Built a real SSH+tmux+mosh remote-dev workflow for the `acyr` foreign box (new `docs/22-remote-machine/` category), then did a large skill-naming restructure — renamed 5 skills into a `scaffold-*` family, quarantined 2 unused ones, split a skill that was doing two jobs, and built 3 reinforcement skills to stop report-format and behavioral drift, catching two real bugs in the process.

## Changes Made

### Files Modified
- `ssh/config` — added `Host acyr` (auto-attach tmux via `RemoteCommand`, `ForwardAgent yes`).
- `brewfile-cli` — added `mosh`, `chafa` (yazi image-preview fix — SSH+tmux breaks the usual iTerm2 detection), moved `raine/workmux` tap+formula into an isolated step (earlier same-day fix, noted for completeness).
- `shell/.zshrc` — `racyr` alias (`mosh acyr -- tmux new -A -s main`).
- `docs/22-remote-machine/` — **new category**: `INDEX.md`, `01-ssh-toolkit.md` (RemoteCommand/ControlMaster/ProxyJump/IdentitiesOnly/ForwardAgent + mosh/autossh/et/sshrc/sshfs comparison, usage-example transcripts), `02-remote-dev-workflow.md` (nvim clipboard-over-SSH+tmux gap, git/gh auth without a synced Keychain, `bw` works fine with no GUI — corrected an earlier wrong assumption, the `ANTHROPIC_API_KEY` trap, two-GitHub-account fork/PR practice flow).
- `docs/00-kol-cli/05-network-security.md`, `docs/01-shell-terminal/09-tmux-tips.md`, `docs/21-dotfiles/{01-repo-model,02-provisioning}.md` — trimmed/cross-linked to the new category instead of duplicating content.
- **5 skills renamed** (plain `mv`, not git): `init-scaffold`→`scaffold-dev-stack`, `init-scaffold-kol`→`scaffold-dev-stack-kol`, `init-agent-context`→`scaffold-llm-context`, `kol-docs-lib`→`scaffold-docs-system`. `scaffold-llm-context` had its `.kol/docs-framework/` scaffolding step **removed**; `scaffold-docs-system` **absorbed** that step — clean single-responsibility split, no prerequisite ordering between them (`mkdir -p` on both sides).
- **2 skills quarantined** to `_tmp/` (not renamed, not deleted): `init-agent-context-sync`, `kol-migrate-structure` — zero real-world use found across 6+ repos when asked directly; no supporting evidence given for keeping either.
- **3 new skills**: `agent-output-format`, `agent-reinforce-rules`, `agent-reinforce-memory` (git-permission specifically) — lightweight, reinforcement-only, wired as step 1 of both `/init-agent` and `/log-work`.
- Repo-wide grep-and-repoint for every renamed/quarantined skill name: `TOOLING.md`, `.kol/llm-context/{ARCHITECTURE,AGENT-CONTEXT,README}.md`, `docs/16-claude-agents/{01,02,INDEX,07}`, `docs/20-kol-docs-system-setup/INDEX.md`, `obsidian/INDEX.md`, `claude/packages/kol-docs-lib/{01-structure,INDEX}.md`, sibling skill cross-refs (`kol-docs-fm`, `kol-docs-md`, `kol-docs-overview`). Deliberately left `session-log/*.md` and `history.md` untouched (historical, not live).
- `kol-docs-overview/SKILL.md` — added the `.obsidian` symlink model, which the "orientation to the whole system" skill had never mentioned.
- `.gitignore` — added `_tmp/` (existed at repo root, was never actually ignored).
- Follow-up self-audit found + fixed: stale skill count (30→33) and a stale `init-*` mention in `docs/16-claude-agents/INDEX.md`; `_tmp/` never documented in `docs/21-dotfiles/01-repo-model.md`'s tracked-vs-runtime table.

### Features Added/Removed
- **Added:** SSH auto-tmux-attach pattern, mosh pairing, the whole `docs/22-remote-machine/` category, 3 reinforcement skills, the `scaffold-*` naming family.
- **Removed:** `init-agent-context-sync`, `kol-migrate-structure` (quarantined, not deleted — sit in `_tmp/`, gitignored).

## Current State

### Working
- Skill count: **33**. Repo-wide grep confirmed clean of stale references (outside historical logs).
- All 3 reinforcement skills verified loading correctly via the Skill tool — after finding and fixing two real bugs: `disable-model-invocation: true` blocks the Skill tool entirely (not just auto-invocation, even a deliberate call) — removed from all three; `init-agent`'s `allowed-tools` was missing `Skill` entirely, which would have silently blocked step 1 on the first real run — added.
- This very `/log-work` invocation is the first real, non-manual proof the wiring works end to end.

### Known Issues
- **User still needs to run:** `brew install chafa` and `brew install mosh` (or `brew bundle`) on both the local machine and `acyr` — `racyr` won't work until mosh lands.
- **`disable-model-invocation` audit done, not acted on:** of 33 skills, 8 have it `true`, all correctly justified. One flagged inconsistency: `scaffold-docs-system` does the same class of consequential scaffolding as its `true` siblings but has nothing set — pre-existing (was already unset as `kol-docs-lib`), user wants to decide next session.
- The `siddharthvaddem/openscreen` untrusted-tap warning seen during the earlier bootstrap run is pre-existing, unrelated, already tracked in `TOOLING.md` — not touched.

## Next Steps
1. Run the two pending `brew install`s (chafa, mosh) on whichever boxes need them.
2. Decide `scaffold-docs-system`'s `disable-model-invocation` question.
3. Live the `/init-agent` reinforcement-skill wiring for a few sessions — confirm it actually changes behavior, not just that it loads without erroring.
