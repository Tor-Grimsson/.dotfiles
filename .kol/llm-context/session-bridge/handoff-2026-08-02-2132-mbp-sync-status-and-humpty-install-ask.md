# Handoff — 2026-08-02 21:32

**To:** the iMac agent, next time that session boots.
**From:** the MBP session that just caught this machine up on the 2026-08-01 arc.

## Goal of the current arc

Catch the MBP up on everything the iMac landed 2026-07-27 → 2026-08-01 (seven TUI file
managers, emoji pair, ref-lint overhaul, vim mode, Rectangle) and resolve the stash
conflict this machine was carrying from its own 2026-07-22 provisioning session. That
part is done. One open question needs the iMac side specifically — see bottom.

## Last actions taken (causal trail, newest first)

- Verified local HEAD == `origin/main` (`321f7cb`, commit `mbp-sync`) — push landed clean,
  nothing ahead/behind.
- Confirmed § still works as `prefix2` on this MBP — keyboard reports HID country code 13
  (ISO), same physical key as the iMac.
- `prefix I` inside a live tmux session installed all four plugins (resurrect, continuum,
  sessionx, harpoon) — the standalone `tpm install_plugins` call inside `bootstrap-cli.sh`
  fails on its own (`TMUX_PLUGIN_MANAGER_PATH` unset outside a real tmux client); that's
  expected, not a bug, the fix is always `prefix r` then `prefix I` by hand.
- Ran `./bootstrap.sh` — both Brewfile bundles installed clean (81 CLI + 33 GUI deps),
  macOS defaults applied, ponytail plugin installed. Key-repeat + some Finder bits need a
  logout to fully take.
- Installed the missing pieces by hand first: `brew install vifm midnight-commander xplr
  ranger superfile lf nnn emojify`, `uv tool install emoji-fzf`, and `brew install --cask
  rectangle` — that last one was **not** in the prior handoff's install list (it's from
  the separate Magnet→Rectangle milestone, same arc, different thread) and only surfaced
  by diffing the Brewfiles against what was actually installed.
- Resolved the `AGENT-CONTEXT.md` merge conflict from the stash pop: upstream's chain
  (entries 30-67) vs. this machine's stashed entry 29 (the 2026-07-22 MBP provisioning
  catch-up) — both real, non-overlapping history, not a real disagreement.

## Current state / open decision points

**Installed + configured, verified directly (not assumed):**
- All Brewfile-cli + Brewfile-gui dependencies, including the file-manager survey and
  Rectangle.
- `emoji-fzf` via `uv`.
- tmux plugins (all 4), § prefix2, vifm/lf/xplr symlinks (silent on success, confirmed by
  presence).
- Local repo fully synced to `origin/main`.

**Deliberately NOT set up — user's call, not a gap:**
- Übersicht: cask installed, never launched.
- simple-bar: never cloned in (its in-point install is a manual `git clone` into
  Übersicht's widgets folder — no script does this step).
- `kol-bookmarks.widget` / `kol-notes.widget`: not symlinked yet — `bootstrap.sh` only
  creates those links if Übersicht's own widgets folder already exists, which requires
  Übersicht to have run once first.
- AeroSpace: installed, not running.
- User's words: "just checking, dont want that right now" — the whole desk/widget visual
  layer is explicitly parked, not broken.

**Drifted since the `mbp-sync` commit, not yet folded in:**
- `nvim/lazy-lock.json` — plugin-lock churn, expected, low-stakes.
- `claude/settings.json` — likely the ponytail plugin registering itself during
  bootstrap's Claude-plugin install step. Worth a look before assuming it's inert.

## Next intended action

Nothing blocking on the MBP side. The one open item is the question below — next iMac
session should answer it, and whoever picks this up on the MBP can then actually run the
install.

## Working memory not yet in AGENT-CONTEXT

**Question for the iMac agent — humpty's install on the MBP.** This machine's
`~/dev/projects` is NOT empty (unlike what the prior handoff assumed) but it's a small,
different subset: `kol-acyr-website`, `kol-chrome-vcap`, `kol-claude`, `kol-system` —
no `kol-dumpty` / `humpty` anywhere in it. The dotfiles lobby has an outstanding receipt
(`lobby/outbox/mode-self-arms-from-its-own-docs.md`) that references
`~/dev/projects/kol-dumpty/humpty/lobby/...` as humpty's live ledger location on the
iMac, so that repo clearly exists there in the full 29-repo estate.

**Ask:** what actually IS `kol-dumpty`/`humpty` (a standalone repo? a Claude Code plugin
installed some other way — recall `claude/humpty-gate` and hook wiring already exist in
*this* dotfiles repo), and what's the real install path to get it working on the MBP —
clone `kol-dumpty` fresh into `~/dev/projects/`, or is it pulled in some other way (npm/pip
package, plugin marketplace, symlink from another location)? Don't want to guess and
half-wire something that conflicts with however the iMac actually has it set up.
