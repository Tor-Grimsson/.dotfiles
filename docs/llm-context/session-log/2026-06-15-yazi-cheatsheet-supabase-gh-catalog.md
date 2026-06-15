# 2026-06-15 (iMac) — yazi beginner cheatsheet + supabase guide logged + gh added to catalog

Three doc-catalog jobs: wrote the beginner Yazi guide the user actually wanted, sequenced a user-dropped Supabase guide into the tree, and logged the GitHub CLI (staged ahead of install).

## Done
- **Yazi beginner cheatsheet** — new `docs/02-file-management/17-yazi-cheatsheet.md` (`type: guide`). Workflow-first, grounded in the *actual* install (yazi 26.5.6; the custom `g`-jumps / `T` / `<C-y>` / smart-enter from `keymap.toml`; real `.zshrc` fzf/zoxide/bat/eza/llm wiring). 8 worked workflows (visual cd, Downloads triage, image review, bulk-rename, two-tab move, find-a-file, ask-Claude-via-`llm`, open-in-app) + an honest integrations table (`z`/`Z` are *built into* yazi; bat/eza/llm are shell partners it hands off to on `q`) + a grouped everything-table. Routed via a new `## Guides` section in the cat-02 INDEX; reciprocal `related` in `02-yazi.md`. Guide, not a tool → **catalog count unchanged**. [Corrects last session's false belief that a beginner doc existed — it never did; only the lookup-first reference rewrite of `02-yazi.md` happened.]
- **Supabase guide sequenced** — user dropped a new 9-chapter + INDEX beginner guide (kol-lightroom project, kol-docs frontmatter) at the **unnumbered** `docs/supabase/`. Moved → `docs/14-supabase/` (next top-level ordinal after `13-terminal-browsers`). All internal wikilinks are bare basenames → folder-rename-safe; nothing else in the repo linked in. Registered in the **root INDEX** under a new `## Guides` section (#14, `brew install supabase/tap/supabase` inline) + a maintenance note (guide, not a counted tool). Added a CLI-install pointer to the guide's own `INDEX.md`.
- **Supabase CLI → Brewfile** — was installed (2.106.0) but untracked. Added `tap "supabase/tap"` + `brew "supabase/tap/supabase"` (comment → guide). Closes the drift.
- **gh (GitHub CLI) added to catalog — STAGED, not yet installed.** gh is *not* on PATH; the oh-my-zsh `gh` plugin (`shell/.zshrc:9`) was loading completions for a missing binary. New `docs/04-dev-languages/12-gh.md` (reference shape — number 12 because 10–11 are the neovim guides), `brew "gh"` in the Brewfile, cat-04 INDEX row + intro + date, reciprocal `related` with the supabase Git/GitHub chapter (`14-supabase/06`). Catalog **70 → 71** (cat 04 9 → 10), updated in root INDEX (headline + frontmatter + table) and the repo-layout table in AGENT-CONTEXT.

## Handoff (user runs — said "later")
- **`brew bundle` on BOTH machines** — installs `gh` (neither machine has it) and the `supabase` CLI on the MBP (iMac already has 2.106.0). All repo edits ride one commit + dot-sync.
- **`gh auth login` once per machine** — the token lives in the local login keychain, not the repo, so it doesn't sync.
- User owns git — nothing committed this session.

## Notes
- The gh doc is the only catalog entry describing an *intended* install rather than an installed tool; its `verified:` is the authoring date — real verification is post-`brew bundle`.
- Supabase is a **project guide** (kol-lightroom), not machine tooling — that's why it's a root `## Guides` entry (#14), not a tool category, even though its CLI is now a Brewfile line. Same guides-don't-count rule as the neovim/tmux/yazi cheatsheets.
