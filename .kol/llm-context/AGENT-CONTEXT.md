---
_template:
  version: 1
  path: .kol/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# dotfiles — Agent Context

Current state + operational reference for `~/.dotfiles`. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing rules see `ARCHITECTURE.md`. For the *why* see `HISTORY.md`. For speculative work see `../llm-plan/`.

**Last updated:** 2026-08-02 (68) (**MBP catches up on the 07-27→08-01 arc, resolves its own stash conflict**) — this machine hadn't pulled since 2026-07-20; one fast-forward landed the whole iMac arc (entries 30-67) at once, colliding with this repo's own unresolved stash from the 2026-07-22 MBP provisioning session. Resolved by keeping upstream's chain and letting the standard 5-entry trim drop the stale local entry — its session-log file already has the full record, nothing lost. Caught up on installs: seven TUI file managers + `emojify` + `emoji-fzf` (uv) per the prior handoff, plus **`rectangle` cask**, which the handoff's list missed entirely (found by diffing `brewfile-gui` against `brew list`, not by trusting the doc). `./bootstrap.sh` ran clean (81 CLI + 33 GUI deps, macOS defaults, ponytail plugin) — key-repeat + some Finder bits pending a logout. **tpm's standalone `install_plugins` fails by design** (needs `TMUX_PLUGIN_MANAGER_PATH`, only set inside a live tmux session) — `prefix r` then `prefix I` installed all four plugins, confirmed on disk. § still works as prefix2 (this MBP's keyboard reports HID country code 13, same ISO layout as the iMac). Local HEAD verified matching `origin/main` — no ahead/behind. **Deliberately left undone:** Übersicht/simple-bar/AeroSpace/the two kol-widgets — cask present, nothing configured, user's call, not a gap. **Drifted, uncommitted:** `nvim/lazy-lock.json` (normal churn), `claude/settings.json` (likely ponytail's own registration). **Open question sent to the iMac agent** (`session-bridge/handoff-2026-08-02-2132-…md`): how humpty (`~/dev/projects/kol-dumpty/`) should actually get installed here — this MBP's `dev/projects` is a small, different subset with no dumpty/humpty in it at all. See `session-log/2026-08-02-mbp-arc-catchup-and-humpty-question.md`. — Prior: 2026-08-01 (67) (**seven explorers · the emoji pair · ref-textmodes → ref-vim**) — **broot never worked**: `.zshrc` sourced `…/launcher/bash/br`, a file that does not exist (the dir holds `bash/1`), and oh-my-zsh's brew plugin owns `alias br='brew reinstall'` which beats a function anyway — so broot now launches as **`b()`**, carrying its own `--outcmd` recipe. **Claude Code HAS vim mode** — `"editorMode": "vim"` is set in `claude/settings.json:102`; the card's *"/vim NOT a command"* proved only that the slash command is absent, never that the feature was. Rebuilt from `code.claude.com/docs/en/interactive-mode` (**fetched, not remembered** — third touch, first verification): `f F t T` with `; ,`, full text objects, visual mode, and **`vimInsertModeRemaps` is read from USER settings only** so a repo's `.claude/settings.json` cannot remap keys. **`ref/textmodes.md` → `ref/vim.md`** (+ `bin/ref-vim`) — the card existed under a name nobody would type; zsh section expanded 2 tables → 8. **Seven TUI file managers** installed, themed and documented (`docs/documentation/02-file-management/18-24`), verdict **vifm**; every theme built from **ANSI 0-15 only**, so kol-theme retints all seven with no per-app file. **The emoji pair has a vocabulary trap**: emojify 2562 GitHub shortcodes vs emoji-fzf 4440 Unicode names — `:astronaut:` exists only in the latter and emojify leaves it as literal text, so **`emo -n` sources from `emojify --list`**. Catalog recount **85 → 106 tools**. Two corrections: the vim claim, and `$`-prefixed examples given to someone learning (→ global memory `feedback_examples_are_copy_pasteable`). See `session-log/2026-08-01-explorers-emoji-ref-vim.md`. — Prior: 2026-08-01 (66) (**tmux window yellow → the humpty badge**) — both window rows repointed to the humpty-dumpty badge yellow **`#ffaf00`** (256-colour **214**): active `bg=#fabd2f` → `#ffaf00`, inactive `fg=#d79921` → `#ffaf00`, in `themes/gruvbox/tmux.conf` (the live file — `~/.config/kol-theme/current` → gruvbox) and the `tmux/.tmux.conf` fallback **in lockstep**. **The source of truth inverted**: `statusline.sh` picks 214 because that renderer approximates truecolor badly, so tmux is now matched to the approximation — the code comment claiming the reverse was corrected. Active still reads as active because **the solid block does the work, not the hue**. Two costs accepted: `themes/gruvbox/` is now off-palette (its header still claims *"the .tmux.conf originals, verbatim"*), and `message-style` keeps `#d79921`, so the message bar and the window list no longer share a yellow. **Screenshots were pixel-sampled, not eyeballed** (`magick … histogram:info:`) — profile-shifted overall, but the green channel matched each source exactly, which is what proved the two yellows differed. See `session-log/2026-08-01-tmux-window-yellow-humpty-badge.md`. — Prior: 2026-08-01 (65) (**the lobby's first drain — g-nav deleted · `/ag-init` reads the docs index**) — both tickets closed in one pass, queue 2→0. **The `g*` jump family is gone** — `ghome gdot gdev gobs gapparat gclient gicloud` plus the `_gnav_*` helpers, deleted rather than repointed (*"I dont use it, it was before I had the bookmarks for that purpose"*); the tmux bookmarks system supersedes it. `shell/functions/g-nav.zsh` → **`paths.zsh`**, keeping only `zshrc` and `cwd` — neither is a jump shortcut, neither used the helpers. **`/ag-init` + `/agent-init` now read `docs/documentation/INDEX.md`** at step 3 (and `docs/INDEX.md`), silent when absent: `.kol/` carries history and state, `docs/` carries the rules — filed after an agent in kol-ds-ui re-derived layout rules by grepping source and proposed re-adding a deliberately-deleted token. **Two traps found:** the g-nav ticket's DoD named `13-shell-functions.md` as needing a sync, but that file only ever documented `killport` — **a definition-of-done can name a target that doesn't exist**; and `ref/shell.md` pointed at `ref-tmux bookmarks` when the section is `## bookmark` singular, so the filter returned nothing — a dead cross-card pointer renders perfectly. See `session-log/2026-08-01-lobby-first-drain-gnav-deleted-docs-index.md`. — Prior: 🏁 2026-08-01 (64) (**MILESTONE — Magnet → Rectangle: the floating layer becomes config**) — Magnet retired. It had **no gap or margin setting at all** (swept its whole prefs domain: zero hits) and its keymap was a JSON blob in `horizontalCommands`/`verticalCommands`; it was never in the Brewfile either. **Rectangle** replaces it because everything — geometry *and* the keymap — is a `defaults` key: `gapSize 24` separate from `screenEdgeGap{Top 48, Right 304, Left/Bottom 10}` + `screenEdgeGapsOnMainScreenOnly`, which maps exactly onto aerospace's `[{ monitor.main = N }, 10]`, so a floated window lands on the same grid as a tiled one. **16 shortcuts** written from `defaults.sh`: the four arrows · `⏎` · `⌫` keep Magnet's exact chords (aerospace has **no arrow bindings**), the ten contested letters moved to **cmd-ctrl** (verified zero aerospace binds in that band). Rectangle's Todo feature ships on `⌃⌥N`/`⌃⌥B` = workspaces N/B — deleted. Plist exported to `macos/prefs/rectangle.plist`; cask in `brewfile-gui`; `macos/defaults.md` § 5b documents the Cocoa-vs-Carbon modifier masks. **Ruled out with evidence:** aerospace cannot position floating windows (no positional command exists — only tree ops), and Raycast has one global value for gutter *and* margin so it can't do 304-on-one-monitor. `cl` → `claude /ag-init`. **`/vim` is NOT a Claude Code command** — asserted from memory twice, wrong both times. *(Superseded by (67): the slash command is absent but **vim mode exists** via `/config` / `editorMode`; the card is now `ref-vim`.)* See `session-log/2026-08-01-MILESTONE-magnet-to-rectangle.md`.

*(chain trimmed to 5 — older entries live in `session-log/`)*

## Status at a glance

- Repo holds shell/git/ssh/editor configs **plus** a reconciled `Brewfile`, a per-tool docs catalog, and the repo-backed `~/.claude` config.
- 2026-07-08 (3): **TUI cockpit + git category + lazygit.** lazygit reconciled (brewfile + `bind C-g` popup + catalog + git card). Fixed a reorg miss — stale `docs/NN-` paths in extensionless configs (`brewfile-cli`/`.tmux.conf`/`.zshrc`/kol-cdn wrappers) repointed. Built the fastfetch shell-home (chafa portrait logo, `fastfetch/`) + `21-chafa` doc. New **`18-tui-shell-layout`** category (fastfetch-home + tmuxinator `home`/`torrent` dashboards + a paths/URLs bookmark system: `prefix C-b` open, `B` add-cwd, `A` typed popup, 3 helper scripts + `tmux/bookmarks.txt`). New **`17-git`** category (general `01-git` + gh/lazygit/worktrees moved from dev-languages, ponytail 13→12). `bind C-d` layout popup. New tracked dirs: `fastfetch/`, `tmuxinator/`, `tmux/bookmark*`. Parked mpd+rmpc / AeroSpace-Ctrl-Alt / status-trim in `plan.md`. **tmux binds live after `prefix r`.** See `session-log/2026-07-08-tui-cockpit-git-category-buildout.md`.
- 2026-07-08 (4): **`keys` keybind-reference tool + `keys-add` skill.** `keys [tag …]` bat-prints your own keybinds filtered by tag — `bin/keys` + `keys/keybinds.md` (new tracked dir; a hand-kept flat `## #tag` list seeded from the live tmux/aerospace/nvim/bookmark/git/gh/ssh binds; cataloged `scripts/19-keys.md`). New **`keys-add`** skill maintains it (format + tag taxonomy + config-sync discipline); skill catalog **35→36**. See `session-log/2026-07-08-keys-keybind-reference-tool-skill.md`. *(Both retired 2026-07-29 — dissolved into the 14 `ref/*.md` cards; `ref-add` replaced `keys-add`.)*
- **The user owns all git** — agent never commits; advise and hand off.

---


*(older status bullets trimmed 2026-07-11 — the archive is `session-log/`; see also `llm-plan/01-parking-lot.md` § AGENT-CONTEXT trim)*

## Repo layout

| path | role |
|---|---|
| `brewfile-cli` + `brewfile-gui` | package manifest, **split 2026-07-04** (was unified `Brewfile`) — cli = formulas only, safe to run standalone on a foreign/SSH box; gui = casks + VS Code extensions, daily-driver machines only |
| `bootstrap.sh` | installer: `brew bundle` (both brewfiles) + TPM clone/install, then symlinks shell/git/ssh/vscode/iterm/mpv/tmux/**claude** + runs `macos/defaults.sh` |
| `TOOLING.md` | tooling **audit**: drift, reconciliation, cross-arch portability, open items |
| `docs/` | tooling **catalog**: 106 tools (2026-08-01), 14 categories of kol-docs `reference` docs + root INDEX, plus standalone `## Guides` (e.g. `14-supabase/`) and `## Explorations` (design surveys, not-yet-built — e.g. `19-kol-tui-plugin/`) |
| `claude/` | repo-backed `~/.claude`: CLAUDE.md, settings.json, skills/, hooks/, commands/, agents/, output-styles/ |
| `meta/` | secrets/setup: `BITWARDEN-SETUP.md`, `SECRETS_TO_MOVE.txt` |
| `macos/defaults.sh` | macOS defaults baseline (Finder/keyboard/screenshots/Dock/…) |
| `ref/` + `bin/ref` | the 14 reference cards — glow-rendered tables, filtered by section-title word |
| `shell/` `git/` `ssh/` `iterm/` `vscode/` `mpv/` `nvim/` `tmux/` `bin/` `scripts/` | the usual dotfiles configs + helper scripts |
| `.kol/llm-context/` | this agent-context protocol |
| `LLM_RULES.md` + `claude/skills/{init-agent,log-work}` | session-boot protocol — global skills; repo-local `.claude/` retired 2026-07-03 |

`claude/skills/` — **70 skills** as of 2026-07-30. Canon source is `~/dev/projects/kol-system/claude/skills/`; curated copies live here and are bundled self-contained (ARCHITECTURE §4). The `tmpl-` prefix is the output-contract family; `kol-*` the design-system/CDN family; `scaffold-*` the repo-shaping family.

---

## Critical consistency seams

### Brewfile mirror — RETIRED
`Brewfile-mirror.txt` left the repo 2026-06-05; the byte-identical sync rule died with it. Single manifest now. (ARCHITECTURE §2.)

### ~/.claude symlinks
`claude/*` is symlinked into `~/.claude/`. Editing `~/.claude/CLAUDE.md`, `settings.json`, `skills/…` edits the repo. `bootstrap.sh` recreates the links.

### Cross-arch paths
Intel iMac = `/usr/local`, Apple-Silicon MBP = `/opt/homebrew`. No hardcoded prefixes in tracked files. (ARCHITECTURE §1.)

### kol-docs framework
`claude/skills/kol-docs-{fm,md,lib}/SKILL.md` read their canon from `claude/packages/kol-docs-{fm,md,lib}/`. Shared skill **dependencies** (frameworks, templates) live in `claude/packages/`, never inside a skill.

### ref cards name their tool
A card's `## ` titles are the only thing its filter matches, so a section is named `tool — topic` (`## aerospace — focus`, `## rmpc — transport`, `## dev — root`). A bare functional name hides the tool from search. Fixed across desk + grep 2026-07-30.

---

## Open items (live)

- **Seven TUI file managers are ON TRIAL** (2026-08-01) — vifm · mc · xplr · ranger · superfile · lf · nnn, all installed, themed, carded and documented. The survey's verdict is **vifm**, but it is a paper verdict; the live cut has not happened. Whichever lose get removed from `brewfile-cli`, their `docs/documentation/02-file-management/18-24` docs deleted, and the `ref-explorer explorers` table trimmed. **Not a task until the user says so.**
- Otherwise none. Three arcs closed — desk scoping, the lobby system, and Magnet → Rectangle (2026-08-01). The 11 contested `ctrl-alt` chords are gone with Magnet itself; Rectangle's ten letter-chords live on `cmd-ctrl`, carded at `ref-desk rectangle namespace`.
- **The lobby is empty** (`~/.dotfiles/lobby/`, read with `/lobby-list` or `prefix Ctrl+K`) — both tickets closed 2026-08-01 in its first drain, resolutions in `lobby/done/`. **The lobby is where work-not-yet-started lives — not this file.**
- **Not an item here:** the `agent-init-docs-index` ticket's per-repo half (a hot-docs table in a repo's own `AGENT-CONTEXT.md`). The dotfiles half was the skill edit and it shipped. **A dotfiles session does not carry another repo's work as a follow-up** — ruled 2026-08-01. Draft rows for kol-ds-ui survive in `lobby/done/agent-init-docs-index.md` for whoever works that repo.
- **Parked** in `llm-plan/01-parking-lot.md`: four non-repo folders under `dev/projects` · kol-cli vs the ref cards.
- **Parked** elsewhere: footer-gate Stop-hook re-emit loop (user: "later" — it's the report-shape gate working as installed) · broot Enter-on-md → nvim verb · Raycast-as-trigger for quick actions · `tmpl-wl` enforcement (humpty's lobby).

---

## Known gotchas

### ANTHROPIC_API_KEY vs subscription billing
Never `export ANTHROPIC_API_KEY` on a machine running Claude Code on a subscription — it silently bills the API instead of the Max/Pro plan (hit 2026-06-10 on the MBP). Set API tokens only where a non-Claude-Code tool consumes them (`llm` on the iMac reads it from `~/.secrets`).

### brew cask "adopt" failures
Newer Homebrew tries to *adopt* a pre-existing app and bails on version mismatch (hit on hiddenbar, openscreen 2026-06-04). Fix: `brew install --cask <name> --force`, or remove the old app first. **App Store apps** (have `_MASReceipt`) can't be adopted at all — delete the App Store copy, then cask-install.

### macfuse / pdf2image are intentionally NOT in the Brewfile
macfuse triggers a sudo/kext dance; pdf2image's binaries clash with poppler's symlinks. Both were dropped 2026-06-04. Install macfuse by hand if a fresh machine needs it.

### Unsaved text is only as safe as swapfile (cost real notes 2026-07-31)
A tmux crash took unsaved nvim buffers with it and **nothing was recoverable**: `opt.swapfile = false` in `options.lua`, no `undofile`, and tmux-resurrect saving layout without pane contents — three independent reasons nothing was on disk. All three are closed now (`swapfile`/`undofile` on, `updatetime = 250`, `@resurrect-capture-pane-contents 'on'`). Recovery drill: `nvim -r` lists orphan swaps in `~/.local/state/nvim/swap/`. **`undofile` does not rescue a never-saved buffer** — only `swapfile` does; that's why both are on.

### Check for a native macOS shortcut before scripting a toggle
`cmd-alt-d` → `bin/dock-toggle` duplicated macOS's own ⌥⌘D (`com.apple.symbolichotkeys` key **52**, enabled by default). Both fired, autohide flipped twice, and the dock looked frozen. Sweep `defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys` for the chord's modifier mask before binding one.

### A tiling WM and a window-mover app cannot share a window
A **tiled** window belongs to a workspace and a workspace to one monitor, so Magnet's Accessibility frame-move gets re-tiled home inside the same tick — it flashes onto the other display and snaps back, reading as rejection. Only `layout floating` windows escape. Use AeroSpace's own `move-node-to-monitor`. Where both apps hold a chord, **AeroSpace registers the global hotkey first and swallows it** — the other app never sees the key, so nothing needs disabling.

### macOS ships bash 3.2 — no fractional `read -t`
A fractional timeout (`read -t 0.05`) is floored to `0`, so it times out instantly and any peek-ahead silently returns empty. Use integer timeouts in `bin/` scripts. Cost the aero-add form an escape-sequence bug on 2026-07-30.

---

## Contracts the next agent must not quietly break

- No hardcoded brew prefixes in tracked files.
- **Never run git** (user-owned) and **never run provisioning** (`brew bundle`/`install`/`upgrade`, `bootstrap.sh`) — prepare, then hand off.
- Don't track `~/.claude` runtime state (history/sessions/projects/caches) in the repo.
- Skill **dependencies** (kol-docs framework, init-agent-context + algorithmic-art templates, the `bucket` CLI) live in `claude/packages/` — never bundled inside a skill. Skills reference them at `~/.dotfiles/claude/packages/`.
- **Secrets never go in tracked files as literals** — only as env-var refs (`${VAR}`) sourced from Bitwarden. The glif MCP uses `${GLIF_API_TOKEN}`; the live token lives in Bitwarden, never the repo.
- **Claude memory is repo-backed (2026-07-28)** — global tier `claude/memory/`, repo tiers `.kol/llm-memory/`; every `~/.claude/projects/<key>/memory` is a symlink maintained by kol-glass `sync.sh`. Never replace one with a plain dir; a repo joins by gaining `.kol/llm-memory/`, then a `sync.sh` run. Memory content is tracked → tier repos stay private (or scrub before publishing).
- **Don't test destructive paths against the live config.** aero-add's round-trip tests wrote a stray rule into `aerospace/aerospace.toml` and moved a hand-written rule into the generated block on 2026-07-30. Back up first, verify byte-identical after, and prefer apps that have no rule.
- **Tool docs: lookup first, prose after.** Order = Summary (2 lines max) → deps table → numbered Setup steps → commands block → flags table → *then* Why/Win/Future narrative. Never lead with essay prose. **State dependencies head-on in a table** (command → does → needs) — "one package, two commands, only one needs mpv" said sideways in prose cost a 3-rewrite back-and-forth on 2026-06-06. Canonical example: `docs/documentation/06-media-av/06-edge-tts.md`.

