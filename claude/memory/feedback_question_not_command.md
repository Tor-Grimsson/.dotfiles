---
name: feedback_question_not_command
description: "A clarifying question is not a work order — answer it, don't execute"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 425d5b31-9949-4564-b857-35d8324b1ec6
  modified: 2026-07-28T02:57:13.133Z
---

When the user asks a question like "run this?" / "should I X?" / "do those go to Y?", that is a request for an ANSWER, not authorization to perform the action. Answer the question; act only on an actual instruction.

**Why:** On 2026-06-08 the user asked "run this? [qa-make.sh …]" + "those go to quick action?" — clarifying questions — and I ran the command for them. They corrected: "I didn't ask you to do it for me, I asked you to clarify… just do as I ask." **Repeated 2026-07-28, twice in one exchange:** he asked "can the active tab have a more pronounced highlight? what controls do we have?" — the agent answered AND edited two config files; when called out, it started an unrequested revert (rejected). His words: "what about the question format escapes your reasoning?"

**How to apply:** Distinguish interrogative ("run this?", "can we…?", "does that…?", "what controls do we have?") from imperative ("run this", "do X"). For interrogatives, respond and STOP — capability/styling questions included, no matter how obvious the follow-up build seems or how much "explain → yes → build" momentum the session has. The fix for an unauthorized action is also not another unauthorized action (no reflex-revert) — state the situation and wait. Related: [[feedback_no_unrequested_options]], [[user-names-are-binding]].
