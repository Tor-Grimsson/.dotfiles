---
name: feedback_sync_doc_on_source_edit
description: "Editing a tracked config/file that has a catalog doc means updating that doc in the same change — don't wait to be told"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bdbb3ab-d9b8-442e-ad77-1b2a19de99a3
---

When you edit a tracked file in this repo, check whether a catalog doc documents it and update that doc **in the same change** — or at least flag it. The dotfiles `docs/` catalog is meant to mirror reality; docs carry a `sources:` frontmatter field naming the file they document (e.g. `docs/16-claude-agents/05-working-rules.md` + `06-claude.md` both `sources: claude/CLAUDE.md`, and `05-working-rules.md` says outright "edit `claude/CLAUDE.md`, keep this map in sync").

**Why:** the user shouldn't have to remind me that a doc went stale — the mirror convention is already written in the repo; missing it means the catalog silently drifts from the code. This bit on 2026-07-05 when a `claude/CLAUDE.md` Report-shape edit left both its docs stale.

**How to apply:** after editing a config/tool/script, look for its doc — grep `sources:` for the path, or check the relevant `docs/NN-*/` category. If one exists, update it (section text + `updated:` date + any change log) in the same turn. If the doc change is large or uncertain in scope, surface it and ask rather than skipping silently. Applies to `claude/CLAUDE.md`, `brewfile-*`, `bin/` scripts, and anything else the catalog covers. Related: [[project_dotfiles_two_machines]].

**Repeat lapse, 2026-07-05 (same day, second time):** edited `ssh/config` + `brewfile-cli` + `shell/.zshrc` together (adding the `acyr` host/mosh/`racyr` alias) and only updated the new `docs/22-remote-machine/` doc — missed that `docs/00-kol-cli/05-network-security.md` (the quick-reference card) also documents SSH config and needed the same update. User had to call it out a second time in one session. **The specific trigger to watch for: when several source files change in one batch under momentum, the checklist-per-file step gets skipped for the ones that aren't the "main" file being discussed** — treat multi-file edits as N separate doc-sync checks, not one.
