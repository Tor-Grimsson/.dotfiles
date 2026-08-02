# Playbook — kol-claude-memory build

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`.

**Goal:** Build the shared memory system per `docs/operations/systems/claude-memory/` — global tier in `claude/memory/`, repo tiers in `.kol/llm-memory/`, write-path symlinks in `~/.claude/projects/`, vault memory lens + `sync.sh`.

**Standing rules (non-negotiable):**
- No git, no provisioning — user owns both (he's giting the vault repo in parallel).
- Facts **move** (`mv`), never copy-and-fork — one copy of every fact, ever.
- `docs/operations/systems/claude-memory/` is the spec — build drifts from it → fix the doc same-turn.

---
## Entries

[06:18 GMT · 2026-07-28] · setup · playbook created
  what → initialised the live playbook   why → user asked to track the build
  note → design docs live (5 files); participating repos recon'd: dotfiles + _kol-quick, kol-chess, kol-ds-ui, kol-studio, kol-website (live-key memory found); home key = 3 facts → global; broken vault links traced to renames (kol-svg-distress, kol-docs-noter, kol-editor-radar)

[06:22] · tiers · global + dotfiles split ✓
  what → claude/memory/ created: 21 facts (19 dotfiles-global feedback_*/reference_* + 2 from home key) + new MEMORY.md; .kol/llm-memory/ = 3 repo facts (two-machines, popup-50, brewfile-canonical) + index w/ global-pointer line
  note → borderline calls: keybind-notation + no-provisioning + audience → global; popup-50 + brewfile-canonical → repo tier

[06:23] · tiers · 5 repo tiers seeded ✓
  what → .kol/llm-memory/ created + facts MOVED in: _kol-quick(3) kol-chess(1) kol-ds-ui(5) kol-studio(3) kol-website(4)
  after → all 7 write-path keys = symlinks (home→global, each repo key→its tier); kol-chess got its first MEMORY.md; pointer line prepended to all seeded indexes

[06:24] · vault · sync.sh + .gitignore + lenses ✓
  what → sync.sh authored (self-locating, ROOTS/DOTFILES/EXCLUDE seam, lenses + prune + write-path wire) · .gitignore rewritten to policy (ignore repos/ memory/ .obsidian/ LLM_RULES.md; track INDEX+sync+ignore)
  verify → run1: +10/-4 · run2 after fix: +3/-0 · 0 broken links · repos lens 36 · memory lens 7
  note → CATCH: kol-studio + _kol-quick have no .git — membership rule widened to (.git ∨ docs ∨ .kol/llm-memory) · CATCH: macOS grep -r won't descend lens symlinks — lookup is `grep -r pat memory/*/`, noted in vault INDEX

[06:25] · docs · spec synced ✓
  what → vault INDEX rewritten (two lenses, 36+7 lists, grep note, tracked-trio rule) · doc-02 distribution table +row (repo MEMORY.md pointer line)
  note → vault rename question pending user (recommended kol-lens); repo name unchanged everywhere until his call · backlog: ~30 dead-key memory dirs (kol-apparat-* era) await old→new triage · MBP needs a sync.sh run when repo lands there

[06:36] · rename · kol-symlink → kol-glass ✓
  what → user picked kol-glass (over kol-lens/looking-glass/alice), renamed + git-inited the vault; doc-03 file renamed 03-kol-glass-vault.md; sed sweep over docs/operations/systems/claude-memory/*, docs/INDEX.md, vault INDEX — 0 refs left; stale "nothing built yet" claims corrected
  note → visibility verdict: PRIVATE (INDEX carries the client roster); screening: vault tracks scaffold only, real exposure = tier repos' git (dotfiles + 5 seeded must stay private; _kol-quick holds client work detail) · facts audited during move: process rules only, no secrets · sync.sh untouched by rename (self-locating)

[06:38] · vault · pushed ✓ — build order v1 complete
  what → user pushed kol-glass to github.com/Tor-Grimsson/kol-glass (private) — step 5 done, all 5 build steps closed
  note → remaining backlog unchanged: MBP sync.sh run · dead-key memory triage · tier commits in dotfiles + 5 seeded repos are the user's own git flow
