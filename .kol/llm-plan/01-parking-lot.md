---
title: dotfiles — future exploration & parked work
description: Speculative, not-yet-committed ideas and deferred cleanups for ~/.dotfiles — each with premise, shape, tradeoffs, and kill criteria. The parking lot; graduate an item into AGENT-CONTEXT.md (Open items) when it becomes real work.
_template:
  version: 1
  path: .kol/llm-plan/01-parking-lot.md
  sync: skip
---

# dotfiles — future exploration & parked work

The parking lot for ~/.dotfiles: speculative ideas and deferred cleanups, held here so they're recorded and off the working memory. Nothing here is committed. Graduate an item into `llm-context/AGENT-CONTEXT.md` (Open items) when it becomes real work.

---

## macOS ricing 2025 (linkarzu) → see dedicated doc

**Premise:** a themed wishlist of tools/scripts to evaluate — btop, simple-bar, skitty-notes, a cross-tool colorscheme selector, tmux pane arrows, osascript menubar-hide + osascript learning, and his dotfiles *organizational* layout. Too big for one parking-lot entry.

Captured with links + open questions in [`docs/research/ricing-2025-backlog.md`](../../docs/research/ricing-2025-backlog.md) — moved to the user-facing vault (`.kol/` is agent-only, `docs/` is what the user reads). Discuss after rest.

---

## mbp ↔ iMac Claude reconcile

**Premise:** the MBP's `~/.claude` lives in iCloud Workbox and has diverged (different CLAUDE.md, different skills) from the repo. Bring it under git without losing the fresher iCloud-side work.

### shape
A one-time merge run from either machine: union the skills (newest-wins on collisions), reconcile CLAUDE.md, then point the MBP's `~/.claude` at the repo via `bootstrap.sh`. Leave the iCloud copy as a frozen backup until verified.

### open questions
- Is the MBP's `~/.claude` a symlink into iCloud, or a real dir copied there? Determines the cutover steps.
- Which CLAUDE.md wins, or do they merge? (User: "idc, whatever" — default to the newer MBP one, port any repo-only rules.)

### kill criteria
If the MBP work turns out to be throwaway, just `bootstrap.sh` the MBP and overwrite.

---

## macOS defaults coverage

`macos/defaults.sh` is a baseline. Could grow: trackpad/scroll tuning, Safari/Finder power-user flags, screenshot subtypes, hot corners — but keep it to defaults the user actually wants, not a 300-line dump.

---

## Zero-friction torrent search

**Premise:** anywhere in the UI → global hotkey → terminal drops down → `tor-search query` → pick → downloading. Full friction analysis in `docs/scripts/07-torrent.md` § Streamlining.

### shape
1. launchd user agents (`KeepAlive`) for Jackett + `transmission-daemon` — no cold start, the big win.
2. iTerm2 Hotkey Window (built-in) as the global-hotkey terminal — zero code.
3. Optional: self-healing daemon start + query stash inside `tor-search`; fzf result picker; loop mode.

### open questions
- launchd plists tracked in the repo (machine-local paths — Jackett binary is gitignored) or documented per-machine in `meta/`?
- Does the iMac want transmission-daemon always-on, or on-demand?

### kill criteria
If the hotkey window goes unused after a few weeks, drop the launchd agents and keep plain `tor-search`.

---

## Doc link syntax — wikilinks vs standard markdown  (ONGOING — not deciding today, revisit later)

**Premise:** the kol-docs catalog + the Obsidian vault use Obsidian `[[wikilinks]]`. Outside Obsidian (mdcat, GitHub, pandoc) those render as raw text, and image **embeds** `![[img.png]]` don't render in the yazi mdcat preview at all (mdcat is CommonMark, `![[...]]` isn't). Surfaced while wiring mdcat as the `.md` previewer: should docs move toward standard markdown for portability? **Deferred.**

### where the conversation landed
- **Keep wikilinks** — Obsidian-native, concise; embeds + block-refs + autocomplete + rename-safety. Cost: raw text everywhere else; images invisible in mdcat.
- **Go full standard** (`[label](path.md)` / `![](img.png)`) — renders in mdcat/GitHub/pandoc. Cost: verbose, loses note-transclusion `![[note]]` (no CommonMark equivalent) + block-refs, and **diverges from the kol-docs `[[path|display]]` convention** (it's mandated in CLAUDE.md).
- **Split — the leaning option, not committed:** images as standard `![](...)` (render in mdcat *and* Obsidian), note links stay `[[...]]`. Snag: Obsidian's *Files & Links → "Use [[Wikilinks]]"* toggle is vault-wide, so flipping it to get standard image-embeds-on-paste *also* makes note links standard — so the split needs manual authoring discipline, not a setting.

### open questions
- Do we actually read image-heavy notes in the terminal? If not, the whole thing is moot.
- Is GitHub/pandoc rendering of these docs a real workflow, or only Obsidian + mdcat?
- If we ever switch: new-links-only via the toggle, or bulk-convert existing via the **Link Converter** community plugin?

### current state (no action taken)
- dotfiles `docs/` has ~**0** `![[...]]` image embeds and 1 standard `![](...)` image → nothing to convert there; the question is really about the broader vault + future authoring habit.
- No syntax changed, no plugin installed, no vault setting touched.

### kill criteria
If terminal/GitHub reading never becomes a habit, keep wikilinks as-is and close this — converting + diverging from the kol-docs convention isn't worth it for cosmetic link rendering.

---

## AeroSpace keybind conflict — move off the Alt modifier

**Premise:** AeroSpace's default modifier is Alt (Option), which collides with Figma/Affinity (Option-drag to duplicate, measurements, etc.). Currently worked around by manually toggling `aerospace enable` when moving between apps — high friction, wants automating.

### shape
Move AeroSpace's base modifier from `alt` → **`ctrl-alt`** across all binds in `aerospace/aerospace.toml`. Those apps live on Option + Cmd, not Ctrl+Alt, so the collision class disappears and AeroSpace stays always-on — no more enable/disable dance. Removes the conflict rather than managing it.

### the tradeoff
Move-window binds become 4-key chords (`ctrl-alt-shift-<letter>`). If that grates, the upgrade is a **Hyper key** (Caps Lock → Ctrl+Alt+Cmd+Shift via Karabiner-Elements) bound as the AeroSpace mod — clean single chords, but adds Karabiner as a dependency.

### why not auto-toggle
No native per-app disable in AeroSpace; `on-window-detected` only sets layout, not keybind suppression. A focus-watcher script calling `aerospace enable off/on` is fragile — fires on every focus change, and `enable off` unmanages/reflows windows.

### kill criteria
If Ctrl+Alt chords feel fine in practice, ship them and close. If they're awkward and Karabiner's unwanted, stay on the manual toggle.

---

## AGENT-CONTEXT status-list trim

**Premise:** `AGENT-CONTEXT.md` is ~66 KB — the "Status at a glance" bullet list has grown append-only across every session since 2026-06-04. It loads every session, so the bloat is a real cost. `session-log/` is the archive; AGENT-CONTEXT should be *current state* only.

### shape
Trim the "Status at a glance" list to a bounded window (the same ~5-recent rule already applied to the "Last updated" chain). Each old bullet already links its own `session-log/…md`, so cutting the tail loses nothing — the detail is one hop away. Keep only enough recent state for a fresh session to orient.

### kill criteria
Once the file is back under ~30 KB and the list holds a sane window, done. Recurs as sessions pile up — re-trim when it drifts past ~30 KB again.

**Trimmed 2026-07-11:** 70 KB → 21 KB (chain capped at 5, status list cut to an orientation window). Recurring — re-run at ~30 KB.

---

## active → canonical status pass

**Premise:** all 207 docs carry `status: active`. The kol-docs spec distinguishes `active` (might shift under an agent) from `canonical` (an agent can act without verifying). Stable tool-reference docs are really `canonical`; blanket-`active` undersells them.

### shape
Reclassify the settled reference docs to `canonical`, leaving genuinely-in-flux ones `active`. Judgment per doc, not a blind sweep — which is why it wasn't folded into the 2026-07-08 frontmatter-conform pass.

### kill criteria
Low priority — cosmetic/metadata accuracy, no functional impact. Do it if a status-driven query ever needs the distinction; otherwise leave.

---

## Torrent space — consolidated guide (+ Prowlarr on OrbStack)

**Agreed 2026-07-08.** The torrent stack is scattered across five docs/scripts; consolidate it into one guide, and capture the Prowlarr-on-OrbStack upgrade. (mpd+rmpc terminal music — the item that used to live here — shipped this session; see AGENT-CONTEXT (17).)

### what exists (to link, not duplicate)
- `06-media-av/05-transmission-cli.md` — Transmission daemon + `transmission-remote`.
- `scripts/07-torrent.md` — `tor-search` / `tor-jackett` (search → magnet → Transmission).
- `18-tui-shell-layout/02-tmux-dashboards.md` §3 — the `torrent` tmuxinator dashboard (the "localised home").
- Jackett — run via the `tor-jackett` symlink; key in the vault.

### shape
- New **guide** (its own category, like Supabase/Cloudflare/Google) — the pipeline in one place: search (Jackett/tor-search) → magnet → download (Transmission daemon) → the `torrent` cockpit.
- Add the **missing operational glue**: the daemon must be running for `transmission-remote`/the dashboard; it's not auto-started → document a launchd-agent option (same mount/agent pattern as mpd).
- **Prowlarr-on-OrbStack chapter** — OrbStack is installed + running; Prowlarr is not. Prowlarr (the modern Jackett successor) in a Docker container via OrbStack, feeding Transmission. Document the container setup; optionally stand it up.

### open question
- Does `tor-search` stay on Jackett, or get repointed at Prowlarr once it's up?

---

## gcalcli OAuth token dead — `invalid_grant` (re-auth needed)

**Symptom (2026-07-08):** every gcalcli command (`cbrief`/`cplan`/agenda) dies with `google.auth.exceptions.RefreshError: invalid_grant: Token has been expired or revoked.`

**Root cause (most likely):** gcalcli's **OAuth consent screen is in "Testing" mode** → Google **expires the refresh token after 7 days**. Recurring by design until the app is published. (Not billing-related — Calendar API is free, unaffected by the suspended billing account. See [[01-console-map|Google console map]].)

### quick fix (try first — no console needed)
- Delete the stale token: `rm ~/Library/Application\ Support/gcalcli/oauth`
- Re-run: `gcalcli agenda` (or `gcalcli init`) → approve in the browser → fresh token cached. Re-auth reuses the client ID/secret already in gcalcli's config, so this shouldn't need the console **unless the OAuth client itself was deleted**.

### permanent fix (stops the 7-day death)
- `console.cloud.google.com` → the project holding gcalcli's OAuth client (one of the kolkrabbi projects) → **APIs & Services → OAuth consent screen → Publish app** (Testing → In production). The "unverified app" warning is fine for personal use.

### when un-salted
- Add this re-auth troubleshooting to `docs/documentation/01-shell-terminal/14-gcalcli.md` (Known issues / re-auth section).

---

Nothing here is committed. This is a thought exercise until items move to `llm-context/AGENT-CONTEXT.md`.
