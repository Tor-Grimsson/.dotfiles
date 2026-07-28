---
name: feedback_disable_model_invocation_gating
description: When to set disable-model-invocation:true on a dotfiles-repo Claude Code skill vs leave it unset
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0538eb4b-0cc2-4d59-9f99-7ece3d506b16
---

Only gate a skill with `disable-model-invocation: true` if it takes a genuinely consequential
external action the user wouldn't want happening unprompted — scaffolding a new project/dir tree,
installing/provisioning, or otherwise writing structure a user didn't explicitly ask for right now.
Skills that just reinforce behavior, log work, or load/report context can be left unset (equivalent
to `false`) — auto-invocation isn't dangerous for those.

**Why:** User's own words, 2026-07-05: these skills "don't do anything dangerous, they just
reinforce behaviour, log work, and context." Decided while resolving a flagged inconsistency —
`scaffold-docs-system` writes a whole `docs/` tree + `.kol/docs-framework/` into a repo unprompted
but had no gate, unlike its sibling `scaffold-*` skills — so that one got flipped to `true`. In the
same pass, the user explicitly confirmed `agent-init`, `log-work`, `log-work-handoff`,
`claude-bullet`, `claude-clear`, `agent-reinforce`, `agent-reinforce-rules`, `agent-reinforce-memory`,
and `agent-output-format` should all stay ungated (their `disable-model-invocation: true` lines were
removed from the first five; the last four never had it).

**How to apply:** When authoring a new skill in `~/.dotfiles/claude/skills/`, ask "would the user be
upset if this ran without them typing `/name`?" — scaffolding/provisioning/install-class actions:
gate it. Read-only, reinforcement, logging, or reporting skills: leave the key out entirely (don't
write `disable-model-invocation: false` — the established convention here is omission, not an
explicit false).
