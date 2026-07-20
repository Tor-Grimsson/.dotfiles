# Playbook — AeroSpace ctrl-alt migration (+ session new docs/skills)

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`.

**Goal:** free the terminal's bare-Alt keys by moving AeroSpace's modifier from `alt` → `ctrl-alt`, then reconcile every doc/skill that referenced the old scheme; also log this session's new docs + skills.

**Standing rules (non-negotiable) — reinforced skill set ACTIVE:**
- **Report shape** — fenced header card · plain 1–2 line lead · tables over prose bullets · ONE footer line ending `say "show noise" to expand` · end AT the footer, nothing after.
- **No git** — never run a git command, never write one into a plan; renames = plain `mv`.
- **No provisioning** — never `brew`/`bootstrap`/install; hand the user the exact command.
- **Sync docs same-turn** as any tracked source/config change.
- **One plan, not a menu** · answer questions before acting · terse verdict on sanity-checks.
- **No unprompted logging** — session logs / AGENT-CONTEXT only when asked (this playbook does NOT touch AGENT-CONTEXT).

Status legend: `✓` done+verified · `~` in progress · `⤺` reverted · `▣` quarantined · `★` rescued.

---
## Entries

[23:49 GMT · 2026-07-09] · setup · playbook created
  what → initialised the migration playbook   why → record the ctrl-alt remap + this session's new docs/skills

[23:49] · aerospace · aerospace.toml
  what → remapped WM modifier bare-`alt` → `ctrl-alt` (77 binds)   why → bare Alt shadowed terminal keys (fzf `Alt-C`, word-nav `Alt-b/f`, tmux `prefix Alt-1..5`)
  before → `alt-1..9` · `alt-a..z` · `alt-hjkl` · `alt-shift-*`   after → `ctrl-alt-*` · `ctrl-alt-shift-*` (cmd-alt-* macros + service/resize modes untouched)
  verify → TOML parse ✓ · 0 stray bare-alt main-mode ✓ · reload pending (`aerospace reload-config`)
  note → new muscle memory — switch `Ctrl+Alt+1..9`, send `Ctrl+Alt+Shift+1..9`

[23:49] · aerospace · docs sweep
  what → synced `keys` #aerospace + tmux #layout · `05-aerospace.md` · `kol-cli/01-cli-cheatsheet.md`   why → sync-doc-on-config-change; full-repo sweep for the old scheme
  verify → 0 stale bare-alt refs repo-wide ✓ · scripts (raycast/sketchybar) use `aerospace` CLI, unaffected ✓
  note → AGENT-CONTEXT (12) + session log flipped from "open issue" → resolved

[23:49] · skills · claude-npm · claude-kol-ds · log-work-playbook
  what → 3 new local-authored skills   why → dep-update checker · kol-design-system orientation gate · this live-journal skill
  verify → `02-skills.md` synced · count → 39 · both prior live via whole-dir symlink ✓

[23:49] · docs · zsh-vi-mode
  what → catalog `28-zsh-vi-mode.md` + 9-chapter guide folder `zsh-vi-mode/` (INDEX + 01–09)   why → modal shell editing, benchmarked vs 8 real GitHub configs
  verify → internal links resolve ✓ · shell-terminal INDEX + root count `01: 23→24`

──────────── MILESTONE: aerospace ctrl-alt migration ──────────── [23:49]
  changed: `aerospace.toml` + 4 docs · new skills: 3 · new docs: 11 · quarantined: 0 · reload pending
  log: session-log/2026-07-09-history-tiers-zsh-vi-mode-guide-aerospace-alt-conflict.md
