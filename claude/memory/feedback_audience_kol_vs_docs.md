---
name: feedback_audience_kol_vs_docs
description: "Who reads what — .kol/ is agent-only state, docs/ is the user's vault; user-facing material goes in docs/"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 478ef5c2-2433-4135-bc8b-9f31b2aab044
---

`.kol/llm-context/` is **agent-only state** that I read (ARCHITECTURE, AGENT-CONTEXT, session-log, session-bridge, plan, history). `docs/` is the **user's Obsidian vault** that HE reads. I once filed his reading/study material (a ricing backlog, a nvim study doc) into `.kol/` and he called it out: "llm context is not for me, that is for you — I read docs, you read .kol."

**Why:** wrong audience = he can't find it. Study/reference/wishlist material buried in my agent-context is invisible to him.

**How to apply:** when he says "log this / keep this / I want to study this," it's **docs/** material, not `.kol/`. Route growing collections to a docs area (e.g. `docs/research/` for study/reference lists, `docs/explorations/` for design surveys, `docs/documentation/` for finished per-tool reference), wire it into the nearest `INDEX.md` so it's findable, and give it vault house-style frontmatter (title/type/status/updated/description/tags/related) — not the `.kol` `_template` block. Only genuine agent state (session logs, AGENT-CONTEXT, plan/history) stays in `.kol/`. Reinforced in [[feedback_message_format_drift]] via `claude/hooks/reinforce-{full,compact}.txt`.
