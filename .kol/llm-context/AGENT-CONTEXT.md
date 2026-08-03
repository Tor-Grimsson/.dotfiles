---
_template:
  version: 1
  path: .kol/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# dotfiles — Agent Context

Current state + operational reference for `~/.dotfiles`. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing rules see `ARCHITECTURE.md`. For the *why* see `HISTORY.md`. For speculative work see `../llm-plan/`.

**Last updated:** 2026-08-03 (76) (**md-preview gains modes + colour · yazi promoted to `ref-yazi`, the 18th card**) — `bin/md-preview` finished: three modes (`full` frontmatter-block+mdcat · `mdcat` plain · `glow`), read per render from `~/.cache/md-preview.mode` so **`prefix v` flips them inside a running yazi** (new bind, `tmux/.tmux.conf:293`; move the cursor off the file and back to redraw). **The finding that matters beyond this script: neither renderer colours its output when that output is not a terminal, and yazi always captures the pane.** mdcat needs `--ansi`, glow needs `CLICOLOR_FORCE=1` plus the repo's own `ref/glow-style.json` — which `bin/ref` already did and I only found by copying it. **This was pre-existing**: yazi's original `run = "mdcat"` previewer had no forcing, so that pane has been colourless since it was wired. Verified by counting escape codes: full 47 · mdcat 32 · glow 53, all 0 before. Then **yazi left `ref-explorer` for its own card** — `ref/yazi.md` (`## yazi — keys`, renamed so `tool — topic` holds and `ref-yazi keys` narrows, + the md-preview section), `bin/ref` card_list/card_def/usage, `bin/ref-yazi` wrapper, 3 `docs/scripts/ref-system/` files resynced. `ref --lint` clean on 18. **Three claims I stated as fact and had to correct, all the same failure:** mdcat colours when piped (it does not — I had `sed`-stripped codes, which proves nothing); mdcat's left margin is 0 (it drops the margin on a non-TTY, so that number was never live); the new ref tags match nothing (glow splits headings across escape sequences, so my grep for a contiguous string could not match). **Reading or piping is not the live behaviour** — the same lesson this file already recorded on 2026-08-03. See `session-log/2026-08-03-md-preview-modes-and-ref-yazi-card.md`. — Prior: 2026-08-03 (75) (**Framer agent connected from the MBP · two humpty gate defects found in live use**) — `npx @framer/agent@latest setup` run here for the first time. **`~/.agents/skills/` was empty before it** — the two skills existed on this machine only because they are tracked in dotfiles and arrived with a pull, so "the skills are present" never meant "setup ran". Setup writes two targets and only one is tracked. Connected to the STUDIO16 project (session `1`); `project list` returns `[]` because studio16's key is project-scoped, so a URL is required — found in that repo's own docs rather than guessed. Ported its whole style + structure surface into **studio16's** docs (4 files, IDs and query recipes included): 6 color styles, 14 text styles, 2 link presets, 6 pages, 3 breakpoints, per-page layer outlines. **Two humpty defects surfaced in live use and belong to the plugin, not to studio16.** (1) **The token gate resolves its token set from the session's repo, not the write target's** — it refused a write to studio16's colour-palette doc claiming *"the repo defines 14 `--kd-*` tokens"*. studio16 defines none; **the 14 are real and they are dotfiles' own**, in `claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/04-plugin-kol-dashboard/styles.css`. Measured correctly, against the wrong tree. It also fires on markdown, where a palette doc's literals are the content. **I called the count fabricated first and was wrong** — checked studio16, not dotfiles. (2) **The scan gate matches on command text, not target** — a grep that explicitly *excluded* the vendor directory was denied for naming it, and writing the lobby ticket about it was denied twice more because the ticket's **prose** contains the name, with no scan in the command at all. Neither is fixable here — humpty is not checked out on the MBP — so both are filed at `lobby/inbox/humpty-gates-misfire-on-docs-and-command-text.md` for the iMac agent, with ledger row and history line. Also worth keeping: Framer link styles are `LinkStylePresetNode`, not text styles, so `getTextStyles()` never returns them — I reported "no link styles exist" on that basis and was wrong until the user pushed back. See `session-log/2026-08-03-framer-agent-connected-studio16-styles-ported.md`. — Prior: 2026-08-03 (74) (**the namespace problem the milestone missed · md-preview shows frontmatter**) — **entry (73) below overstates its own case and should be read with this.** The install and the gates are genuinely verified; the *skill-access surface* is not. Plugin commands are only reachable as `/humpty:<name>`, and the user rejects that syntax outright. It surfaced on `/humpty-goal` returning nothing — and the reason is the finding: **every other kept skill still has an unprefixed twin in `claude/skills/`**, so `/jana`, `/yona` and the eight `/tmpl-*` work bare only because dotfiles carries duplicates. `humpty-goal` was renamed from `kol-goal` in the plugin and never got a copy under the new name, so it was the one skill with no shadow. **That inverts the parking-lot entry**: the 18 "shadowed skills" are not cosmetic duplication, they are the only reason bare syntax works at all — quarantining them, which that entry proposes, would break every one of those commands. I copied the plugin's `humpty-goal` in to restore the bare form; the user ruled that a fuckup (*"we are not manually installing skills that the plugin serves"*) and it was reverted to `_tmp/2026-08-03-humpty-goal-manual-copy/`. **I also asserted the prefix cannot be changed without checking — unverified, and researching it is the next action.** Full state in `session-bridge/handoff-2026-08-03-1830-plugin-skills-namespace-problem.md`. **Separately, shipped:** `bin/md-preview` — yazi's markdown preview hid every doc's frontmatter because **mdcat renders that pane, not glow** (glow is only an opener at `yazi.toml:67`), and both discard a leading `---` block as metadata with no flag to keep it. The strip is **positional** — the identical block one blank line down renders as a thematic break plus setext H2. `md-preview` prints the keys as a properties block then pipes the body to mdcat; `yazi.toml:160` repointed to `piper -- md-preview "$1"`, and the user installed `yazi-rs/plugins:piper` (`package.toml`, rev b9598e6). Proven standalone against the setup playbook; not yet eyeballed inside yazi. Also live: the plugin's own `skills/humpty-goal/SKILL.md` still points at `claude/hooks/goal-loop.sh`, a path that left dotfiles — **a real ubu-roi defect, fix at source**. See `session-log/2026-08-03-md-preview-frontmatter-in-yazi.md`. — Prior: 2026-08-03 (73) 🏁 (**MILESTONE — humpty published, installed and VERIFIED on both machines; the arc is closed**) — the plugin was proven from the consumer side, which is the only place the packaging claim could be tested. **The MBP never ran an install command.** `claude/settings.json` declares `extraKnownMarketplaces.humpty` (`github: Tor-Grimsson/ubu-roi`) and `enabledPlugins["humpty@humpty"]`, and that file is symlinked into `~/.claude/` — so the first startup after the pull fetched and cached v0.5.0 unaided. The handoff's step 3 (`/plugin install humpty@humpty`) was **dead wiring**: the iMac wrote a manual step for something its own settings change had already automated. **The riskiest untested path held** — this machine has no `kol-dumpty/` checkout, so `bin/kol-statusline` fell through to `~/.claude/plugins/cache/humpty/humpty/0.5.0/bin/humpty-statusline`, exactly the fallback the locator exists for. **Both gates deny live:** `humpty-gate` refuses a gated read with the unlock hint, `humpty-rm` refuses `rm -rf` against a repo path with the full NOTHING IS DELETED law. A bare `humpty-dumpty` badge with no `:strict` suffix is **correct, not a defect** — the suffix renders only for levels 1/3/4, and level 2 is the default (dial since set to 3). **Closed with it:** `docs/operations/systems/agent-system/12-setup-a-to-z.md` (needs-a-pass since 2026-08-03) — §2 now documents the declarative install plus the `settings.local.json` dev override whose *absence* is the correct state everywhere else, §7 repoints the statusline from the retired `claude/hooks/statusline.sh` to `bin/kol-statusline` and says why it is a locator not a renderer; and the lobby receipt's 📌 remainder — `claude/skills/yona/SKILL.md:23` claimed "the gate enforces this" for two days after that gate was removed, in a file read as law. **Parked, not carried:** the 18 skills shadowed in both repos · 8 concepts unpackaged · the seven-TUI live cut — all three in `llm-plan/01-parking-lot.md`, all three the user's call. **My own miss:** the first delete-gate probe targeted `/tmp/`, which is on the gate's scratch allowlist — it permitted correctly, the probe was wrong. See `session-log/2026-08-03-MILESTONE-humpty-published-and-verified-on-both-machines.md`. — Prior: 2026-08-03 (72) (**ubu-roi published — the marketplace now has a shared/local split**) — `kol-dumpty/ubu-roi` is the public publishing surface, 67 files, generated by `humpty/bin/humpty-payload` (allowlist, copy-never-move, five pre-flight checks that refuse to stage on failure). Skills cut **35 → 18** in humpty and the same 20 quarantined from dotfiles (**82 → 62**). The 8 `output-l*` skills collapsed into one `layouts` skill — a BUG FIX, not tidying: all eight pointed at a register in `docs/`, which does not ship, so every one would have been broken on a marketplace install. `kol-goal`→`humpty-goal`. **The wiring problem and its fix:** `claude/settings.json` is symlinked from dotfiles, so both machines read ONE marketplace entry — a `directory` source pointing at this iMac's checkout is wrong for the MBP. Shared settings now carries the **github** source (correct everywhere) and `~/.claude/settings.local.json` (untracked, machine-local) overrides it back to `directory` here so hook edits stay live. `statusLine` had the same problem AND a worse one — `$CLAUDE_PLUGIN_ROOT` is only set inside hooks and statusLine is not one, so that substitution silently yields a blank line; `bin/kol-statusline` is now the stable target and locates the script (dev repo first, then newest plugin cache). Also added bytecode/lint caches to the delete gate's scratch list after it blocked its own author. **Left:** the 18 kept skills are live in BOTH repos and plugin skills are namespaced (`humpty:layouts` confirmed live) — the user's call. Concepts still 8 specs, 0 packaged. See `session-log/2026-08-03-ubu-roi-published-marketplace-split.md`. — *(entries 68–70 trimmed 2026-08-03; their records are in `session-log/`)*

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
| `docs/` | tooling **catalog**: 107 tools (2026-08-03), 14 categories of kol-docs `reference` docs + root INDEX, plus standalone `## Guides` (e.g. `14-supabase/`) and `## Explorations` (design surveys, not-yet-built — e.g. `19-kol-tui-plugin/`) |
| `claude/` | repo-backed `~/.claude`: CLAUDE.md, settings.json, skills/, hooks/, commands/, agents/, output-styles/ |
| `meta/` | secrets/setup: `BITWARDEN-SETUP.md`, `SECRETS_TO_MOVE.txt` |
| `macos/defaults.sh` | macOS defaults baseline (Finder/keyboard/screenshots/Dock/…) |
| `ref/` + `bin/ref` | the **18** reference cards (2026-08-03; yazi split out of explorer) — glow-rendered tables, filtered by section-title word. `bin/ref --lint` is the guard |
| `shell/` `git/` `ssh/` `iterm/` `vscode/` `mpv/` `nvim/` `tmux/` `bin/` `scripts/` | the usual dotfiles configs + helper scripts |
| `.kol/llm-context/` | this agent-context protocol |
| `LLM_RULES.md` + `claude/skills/{init-agent,log-work}` | session-boot protocol — global skills; repo-local `.claude/` retired 2026-07-03 |

`claude/skills/` — **64 skills** as of 2026-08-03 (82 before the agent-behaviour cut; 20 quarantined to `_tmp/`, +2 vendored by the Framer installer). Canon source is `~/dev/projects/kol-system/claude/skills/`; curated copies live here and are bundled self-contained (ARCHITECTURE §4). The `tmpl-` prefix is the output-contract family; `kol-*` the design-system/CDN family; `scaffold-*` the repo-shaping family.

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

- **Plugin skills are only reachable as `/humpty:<name>`, and the user rejects that.** Open since 2026-08-03. Next action is research, not a proposal: does Claude Code offer any alias / command-mapping so a plugin's commands resolve bare? I claimed it does not **without checking**. Do not quarantine the 18 dotfiles skill copies while this is open — they are what makes `/jana`, `/yona` and `/tmpl-*` work bare today. Brief: `session-bridge/handoff-2026-08-03-1830-plugin-skills-namespace-problem.md`.
- Three arcs closed — desk scoping, the lobby system, Magnet → Rectangle (2026-08-01). humpty publishing is 🏁 for **install and enforcement** (2026-08-03, verified on both machines) but not for skill access, per the item above. The 11 contested `ctrl-alt` chords are gone with Magnet itself; Rectangle's ten letter-chords live on `cmd-ctrl`, carded at `ref-desk rectangle namespace`.
- **Parked** in `llm-plan/01-parking-lot.md`, added at the humpty milestone — each is the user's call, none is a task: the **18 skills shadowed** in both humpty and dotfiles · **8 concepts, 0 packaged** (`concepts/09-memory` never written) · the **seven-TUI live cut** (paper verdict vifm, carried unchanged from 2026-08-01).
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

