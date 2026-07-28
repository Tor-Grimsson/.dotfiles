---
name: feedback_no_git_in_plans
description: "Never include git commands (git mv, git add, etc.) in a proposed action plan — no git privileges, plain filesystem ops only"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 87a3f20f-1f69-4b8b-92a6-f75f27aadd7a
---

When proposing or executing a multi-step plan that involves moving/renaming tracked files, use plain filesystem operations (`mv` via Bash, or Write+delete) — never `git mv`, `git add`, or any other git subcommand, even as a *planned* step for later.

**Why:** proposed a skill-rename plan on 2026-07-05 that included "`git mv` each skill directory" as a step. Caught immediately — no git privileges here at all, full stop, and [[feedback_no_provisioning]]-style rules already cover "the user owns git," but this was a *planning* failure, not an execution one: I never actually ran it, but I shouldn't have written it into the plan either.

**How to apply:** plain `mv` on the filesystem is enough — git detects renames from content similarity automatically on the user's next `git add`/`status`, no `git mv` needed for that to work. If a task's plan seems to require any git verb, restructure the plan around a filesystem-only equivalent or hand that one step to the user explicitly, rather than listing a git command as something to run.
