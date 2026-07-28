---
name: feedback_narrate_before_tool_call
description: "Say what a tool call is for BEFORE running it, especially self-initiated verification actions the user didn't explicitly ask for"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0538eb4b-0cc2-4d59-9f99-7ece3d506b16
---

State the reason for a tool call *before* running it — not after, not only if asked. This applies
hardest to self-initiated actions (fetching a URL to "verify" something, running a command to
double-check a claim) that the user didn't explicitly request, since those are the ones that look
unexplained/alarming when they just appear as a tool-call block with no lead-in.

**Why:** 2026-07-05 dotfiles session — ran `curl -fsSL https://claude.ai/install.sh | bash`'s target
URL through `curl` silently, trying to inspect the install script's shebang before answering "why
bash not zsh." No lead-in sentence. User rejected the tool call and asked "what are you doing?",
then after the explanation: "fucking explain that instead of just doing whatever and have me
guess." The verification step wasn't even necessary — the general answer didn't require fetching
anything — which made the unexplained tool call look like busywork/snooping rather than
diligence. Related: [[feedback_message_format_drift]] (rules erode under execution-mode momentum
in long tool-heavy sessions) — this is the same failure class, applied to the global CLAUDE.md rule
"before your first tool call, state in one sentence what you're about to do."

**How to apply:** before any tool call that isn't the obvious next mechanical step of something the
user just asked for directly — especially fetching external content, running a command "just to
check," or any research/verification action taken on your own initiative — say in one sentence what
it's for first. If the verification isn't actually necessary to answer well, skip the tool call
entirely rather than reaching for it reflexively.
