---
name: agent-reinforce
description: Load all three reinforcement skills (agent-output-format, agent-reinforce-rules, agent-reinforce-memory) in one call. Called as the LAST step — right before reporting status — by /agent-init, /log-work, /log-work-handoff, and the plain LLM_RULES.md boot path.
---

# agent-reinforce

Bundle, not new content — invoke the three standing reinforcement skills at once.

## Do
Call the Skill tool once for each, in order:
1. `agent-output-format`
2. `agent-reinforce-rules`
3. `agent-reinforce-memory`

## When
The **last** step before reporting status — after every other step (reading context files, writing a log/handoff, doing the actual work) is already done. Never first: it re-grounds report shape and standing rules right before the reply that has to follow them, not before work that doesn't need them yet.
