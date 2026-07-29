# Memory Index — GLOBAL tier

> Cross-repo facts: true in every repo. Repo-specific facts live in each repo's `.kol/llm-memory/`.

- [No commits](feedback_no_commits.md) — Never commit or offer to commit on behalf of the user
- [No unrequested options](feedback_no_unrequested_options.md) — Apply the directive; don't append alternative-menus
- [Workbox location](reference_workbox.md) — iCloud Drive path for user's Workbox folder
- [No provisioning](feedback_no_provisioning.md) — don't run brew bundle/install/upgrade or bootstrap.sh; the user runs those
- [Question ≠ command](feedback_question_not_command.md) — "run this?" is asking for an answer, not authorization to act
- [Sync doc on source edit](feedback_sync_doc_on_source_edit.md) — editing a tracked file with a catalog doc means updating that doc same-change; don't wait to be told
- [Terse verdict first](feedback_terse_verdict_first.md) — sanity-check questions get a bare verdict, no justification paragraph unless asked why
- [Message format drift](feedback_message_format_drift.md) — re-check CLAUDE.md's report shape (header card, tables) on every substantive reply, not just the first few in a session
- [No git in plans](feedback_no_git_in_plans.md) — never write `git mv`/any git verb into a proposed plan; plain filesystem ops only
- [Model-invocation gating](feedback_disable_model_invocation_gating.md) — gate only consequential/destructive skills; reinforcement/logging/context skills stay ungated
- [Narrate before tool call](feedback_narrate_before_tool_call.md) — say what a self-initiated/verification tool call is for before running it, not after
- [Don't hedge known facts](feedback_dont_hedge_known_facts.md) — facts already in loaded AGENT-CONTEXT/session-log are settled, not fresh inferences
- [Drop resolved tangents](feedback_drop_resolved_tangents.md) — once a workaround closes a problem, stop elaborating on the now-moot underlying mechanism
- [No-change means full audit](feedback_no_change_means_full_audit.md) — "nothing should change" needs an end-to-end diff of active config, not a spot-check; caused real breakage once
- [Footer-fold bar too high](feedback_footer_fold_bar_too_high.md) — default caveats to the footer count; only break out inline if the user must act on it right now
- [Audience: .kol vs docs](feedback_audience_kol_vs_docs.md) — .kol/ is agent-only state (you read it); docs/ is the user's vault (he reads it); user-facing material goes in docs/
- [No claude borders](feedback_no_claude_borders.md) — flat hairlines + block highlights, no rounded cards/pills; radius 4-8 window-level only, 0 inside
- [User names are binding](feedback_user_names_are_binding.md) — build exactly what was named; deviations need a flagged question BEFORE building
- [Keybind notation](feedback_keybind_notation.md) — say "Prefix + Ctrl+P", never `C-p` shorthand; always state the prefix
- [Teach simplest path first](teach-simplest-path-first.md) — user is learning; offer the simplest option (GUI included) before CLI ceremony, no silent background fixes during walkthroughs
- [Docs lookup-first](docs-lookup-first.md) — reference docs lead with tables/steps/commands, prose detail below; deps stated head-on in a table, never sideways in prose
- [Clarity over cleverness](feedback_clarity_over_cleverness.md) — lead with the plain answer in ≤3 short lines; reasoning only on "why"; if it needs a metaphor it is not clear yet
- [Glass naming system](project_glass_naming_system.md) — Glass=state, Ubu Roi=actors, Alice=motion; names are picked from the bag, never invented; document in .kol + docs/ at outline start; umbrella name OPEN
- [Own it, move on](feedback_own_it_move_on.md) — callout = one-line ownership then the work, zero validation prose; checkpoint questions are not build authorization
- [Status chores footer-only](feedback_status_chores_footer_only.md) — git/deploy/restart chores + trailing caveats are footer tokens, never prose
- [Text-transform is preference, not law](feedback_text_transform_preference_not_law.md) — never flag existing uppercase/transform as a violation
- [Bash weight discipline](feedback_bash_weight_discipline.md) — no builds for routine edits, no spawn loops, no node_modules-wide scans
