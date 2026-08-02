# Handoff — 2026-08-02 00:00

**To:** whichever agent boots this repo next on the **MBP** (Apple-Silicon, `/opt/homebrew`).
The prior sessions were all on the **iMac** — this handoff exists because the two
machines have drifted and the MBP has never run the installs below.

## Goal of the current arc

Two unrelated threads landed back-to-back on the iMac on 2026-08-01: (1) a TUI
file-manager survey that installed and configured seven new tools, plus an emoji
picker/filter pair, and (2) a ref-card system overhaul (`ref --lint`). None of
part (1) has been installed on the MBP yet — the config files are tracked and
will pull fine, but the **binaries themselves need `brew bundle`**.

## Last actions taken (causal trail, newest first)

- `ref/vim.md` gained a `## claude — stop` section (Ctrl+C interrupt, why Esc
  doesn't work in vim mode) and a `## claude — text/visual/edit/move` rebuild
  from the official docs.
- **`bin/ref --lint` built** — a python3 machine check for the card dialect
  (no per-row spacers, cells ≤46 chars, `doc:` targets must exist, every card
  needs a `## section`). All 17 cards pass. `claude/skills/ref-add/SKILL.md`
  had a **self-contradiction** (line 39 said "spacer row between data rows",
  lines 49-51 said the opposite) — fixed, and the skill's verify step now runs
  the lint instead of promising a check.
- `ref/explorer.md` rebuilt: seven scattered `## tool` sections collapsed into
  **one `## trial` table** with `| ## name |` in-table group markers — the
  new convention for grouping inside a single table (a blank row is ONLY
  legal immediately before a `| ## name |` row; anywhere else it's a
  forbidden per-row spacer).
- `aerospace/aerospace.toml:39` — `on-focused-monitor-changed` set to `[]`
  (was `['move-mouse monitor-lazy-center']`). Mouse no longer warps to the
  other monitor's centre when app focus crosses displays. **This IS relevant
  to the MBP** if it drives external monitors the same way.
- `claude/CLAUDE.md` output-format rewrite: git is now **banned outright**
  from every reply (no `git: untouched` token, no prose) — was legal until
  this session. Footer tokens are now `Label: (count)`, sentence case
  everywhere, one-record blocks use aligned `Label:` lines instead of a
  one-row table. `docs/operations/systems/claude-harness/07-output-formats.md`
  has the full v1→v2 diff if the shape looks unfamiliar.
- Seven TUI file managers installed + configured (see "Next intended action"
  — this is the MBP's actual to-do).
- broot's launcher fixed: it never worked (`.zshrc` sourced a file that
  doesn't exist) — now a proper `b()` function, not aliased to `br` because
  oh-my-zsh's `brew` plugin owns that alias.
- Claude Code's vim mode turned ON — `"editorMode": "vim"` in
  `claude/settings.json`, which is symlinked, so this is **already live on
  the MBP too** once you pull. No install needed for this one.

## Current state / open decision points

- **Seven file managers are ON TRIAL, not yet decided.** `AGENT-CONTEXT.md`'s
  Open Items section carries this explicitly. The paper verdict favors
  **vifm**, but nobody has used any of them day-to-day yet. Don't be
  surprised if a future session strips most of these back out.
- No git operations were run by any agent this arc — the user manages his
  own repo and pulls/pushes by hand.

## Next intended action — MBP-specific installs

**Run `brew bundle` for both files** (this repo's own convention — `brewfile-cli`
first if this is a fresh/foreign box, then `brewfile-gui` for the daily-driver
casks). If the MBP is already bootstrapped and you just need the delta, these
are the **new formulae since the last MBP sync**, all in `brewfile-cli`:

```
brew install vifm midnight-commander xplr ranger superfile lf nnn emojify
```

| Formula | Binary | What it needs after install |
|---|---|---|
| `vifm` | `vifm` | Nothing — config is repo-tracked (`vifm/vifmrc`), `bootstrap.sh` symlinks it to `~/.config/vifm` |
| `midnight-commander` | `mc` | Nothing — themed via `MC_SKIN` env var in `shell/.zshrc`, already tracked |
| `xplr` | `xplr` | Nothing — config at `xplr/init.lua`, symlinked by `bootstrap.sh`. **Watch the `version = "1.1.0"` line** — xplr refuses to start if it doesn't match the installed binary's version |
| `ranger` | `ranger` | Nothing — no repo config yet, defaults are fine |
| `superfile` | `spf` | Its config lives at `~/Library/Application Support/superfile/config.toml`, **not** in the repo — `theme = "gruvbox"` was set by hand on the iMac and won't carry over. Either re-set it or leave it on the shipped default |
| `lf` | `lf` | Nothing — config at `lf/lfrc`, symlinked |
| `nnn` | `nnn` | Nothing — themed via `NNN_COLORS` env var in `shell/.zshrc`, already tracked |

**Also run** (not brew — this is `uv`, already in `brewfile-cli`):
```
uv tool install emoji-fzf
```
This backs the `emo` / `emo -n` shell functions in `shell/.zshrc`. Without it,
`emo` prints `emo: uv tool install emoji-fzf` and exits — it fails soft, so
this isn't urgent, just incomplete until run.

**After any of the above**, re-run `bootstrap.sh` (or just the symlink step)
so `~/.config/{vifm,lf,xplr}` point at the repo — a fresh `brew install`
doesn't create those symlinks itself.

## Working memory not yet in AGENT-CONTEXT — iMac-only vs. shared

Some processes in this repo assume **the iMac specifically**, not just "a
machine this repo is bootstrapped on." Worth knowing before assuming
something is broken on the MBP when it's actually just scoped elsewhere:

- **The repo-map / repo-counter system** (`bin/repo-map.sh`, the `ref-repo`
  card, `docs/operations/systems/repo-map/`) walks `~/dev/projects` — the
  29-repo kol-system estate (kol-ds-ui, kol-website, kol-chess, kol-vault,
  kol-glass, humpty, jabberwocky, memory-glass, plus the `kol-apps` family).
  **This tree lives on the iMac.** If `~/dev/projects` doesn't exist on the
  MBP, `repo-map.sh --update` / `--card` will report everything as missing —
  that's expected, not a bug. Don't "fix" it by trying to recreate the
  estate on the MBP unless that's a deliberate decision.
- **`kol-vault`** (the personal Obsidian vault, one of the 29 repos above) is
  part of that same `~/dev/projects` tree and is read by the iMac's desk
  widgets (`kol-bookmarks`, `kol-notes` reading `desk-notes.md`). Same
  scoping — iMac-resident, not expected on the MBP.
- **`kol-glass`** (the aggregator lens, also in `~/dev/projects`) symlinks
  every repo's `docs/` and `.kol/llm-memory/` into one vault — this only
  makes sense where the whole estate is checked out, i.e. the iMac.
- **What genuinely IS shared** and should just work after `git pull` +
  `brew bundle`: everything in `~/.dotfiles` itself — shell, tmux, nvim,
  the `ref/*` cards, `claude/` (symlinked `~/.claude`), the file-manager
  configs above. `ARCHITECTURE.md` §1 is explicit that no brew prefix should
  ever be hardcoded for exactly this reason (`/usr/local` iMac vs
  `/opt/homebrew` MBP) — if anything above fails with a path-not-found, that
  architecture rule is the first thing to check, not the tool itself.
