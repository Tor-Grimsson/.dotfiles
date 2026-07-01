# Session: AeroSpace quick disable/enable toggle hotkey

**Date:** 2026-06-24
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Added a one-key `enable toggle` to `aerospace/aerospace.toml` so AeroSpace can be flipped fully off (keys + window management released) when working in apps that need their own shortcuts (Figma, Affinity), then back on. Confirmed the user's "missing" alt commands were already bound.

## Changes Made

### Files Modified
- `aerospace/aerospace.toml` — added `cmd-alt-shift-d = 'enable off'` in `[mode.main.binding]` (right after `cmd-alt-shift-f = 'fullscreen'`). Reloaded live (`aerospace reload-config` → OK; live path is the repo symlink). **Started as `enable toggle` but the user confirmed it does NOT toggle back** — while disabled AeroSpace ignores all keys, so its own binding can't re-enable it. Changed to `enable off` to be honest about what the key does.
- `docs/09-productivity-desktop/05-aerospace.md` — documented the feature: new **"Disabling for apps that need their own shortcuts"** section (D-off / E-on flow, why two keys, Raycast script + CLI fallback, the server-vs-CLI-binary gotcha, `layout floating` alternative), a `Cmd+Alt+Shift+D` row in the keymap table, a `covers:` line, `updated: 2026-06-24`.
- `raycast/scripts/aerospace-enable.sh` — **new.** Raycast Script Command (`@raycast.mode silent`) that runs `aerospace enable on` — the re-enable path, because Raycast captures keys system-wide even while AeroSpace is off. Sets `PATH=/opt/homebrew/bin:/usr/local/bin:$PATH` so the CLI client resolves under Raycast's minimal env without a single-prefix hardcode (§1). Verified under `env -i` (stripped env). `chmod +x`, `bash -n` clean.

### Features Added/Removed
- **AeroSpace disable hotkey + Raycast re-enable hotkey.** `Cmd+Alt+Shift+D` → `enable off` (AeroSpace stops managing windows *and* stops intercepting keys, so Figma/Affinity get all shortcuts). Re-enable with **`Cmd+Alt+Shift+E`** assigned in Raycast to the new script (D off / E on — separate keys because the D key is dead while disabled).

## Current State

### Working
- `Cmd+Alt+Shift+D` disables AeroSpace — live (reloaded this session). `aerospace enable on` in any terminal is the always-on fallback.
- **Raycast re-enable wired + confirmed on the iMac** (user: "PERFECT"): added `~/.dotfiles/raycast/scripts` via Raycast Settings → Extensions → Scripts → **Add Directories**, and recorded **`Cmd+Alt+Shift+E`** on the `Enable AeroSpace` command. Full loop now: ⌘⌥⇧D off → ⌘⌥⇧E on.
- Confirmed already-bound (not missing): `alt-minus` = `resize smart -50` (`:128`), `alt-2` = `workspace 2` (`:133`), `alt-shift-t` = `move-node-to-workspace T` (`:189`). If these ever don't fire it's a live-config reload issue, not a missing binding.

### Known Issues / gotchas
- **The disable key does NOT re-enable** (user-confirmed, ends the doc ambiguity): while AeroSpace is off it ignores ALL keys, so no AeroSpace binding can turn it back on. Re-enable must come from outside AeroSpace — hence the Raycast script.
- **The CLI client is NOT the app-bundle binary.** `/Applications/AeroSpace.app/Contents/MacOS/aerospace` is the *server* and rejects `enable on` ("Unrecognized flag 'enable'"); the CLI client is the brew-symlinked `aerospace` (`/usr/local/bin` on Intel, `/opt/homebrew/bin` on AS). The Raycast script puts both on PATH.
- **No native per-app disable.** AeroSpace can't auto-disable keybindings only when a given app is focused (would need Karabiner-Elements/skhd). The toggle is global. For *tiling*-only exemption (let an app float but keep alt bindings working), use `on-window-detected` → `run = 'layout floating'` instead — not wired this session.

### Comparison done (no change adopted)
- Reviewed josean-dev's `aerospace.toml`. It is **not** more capable — it's the stock template with fewer workspaces (1-9 + B/D/E/M/N/P/T/V) and uses a `cmd-ctrl-alt-shift` hyper-key for all move/destructive commands instead of the user's `alt-shift`. The user's config is the superset (full alphabet, `persistent-workspaces`, `config-version = 2`, 7 app rules). Only thing josean has that the user lacks: `on-focus-changed = 'move-mouse window-lazy-center'` (per-window mouse follow) — not adopted.

## Next Steps
1. **MBP:** rides along via the tracked file on next sync — no redo; reload AeroSpace there (or relaunch) to pick it up.
2. Optional: if Figma/Affinity should *float but stay managed* rather than full-disable, add `on-window-detected` + `layout floating` rules for `com.figma.figma` / `com.canva.affinity`.
3. Optional QoL: add josean's `on-focus-changed = 'move-mouse window-lazy-center'` if per-window mouse-follow is wanted.
