# 🏁 Milestone: the desk layer — ref cards made findable, aero-add built

**Date:** 2026-07-30
**Agent:** Claude Code (Grim)
**Arc:** Opened on "I need Magnet's centre key back and I can't hold a mental image of my keybinds"; closes with the desk reference made searchable by tool name and a rule editor that replaces hand-editing `aerospace.toml`.
**Delivered:** `bin/aero-add` (state view + two-toggle form), the `ref-desk`/`ref-grep` naming fix, three behaviour skills, and a humpty port.

## What closed

- **Magnet's centre key** → resolved, no build needed: `ctrl-alt-c` is `workspace C`; `ctrl-alt` and `ctrl-alt-shift` are 100% spent on workspaces. The free band is `cmd-alt` (only `b d g m n r s u` taken), so Magnet's letters survive with only the prefix changed. User owns Magnet already — re-enable it and point its own hotkeys at `cmd-alt`.
- **`ref-desk` couldn't find "aerospace"** → **done**. The filter matches `## ` titles only, and desk named its sections by *function* while every other card names them by *tool*. Renamed to the compound form already used by `files/folders.md`, `ref/media.md`, `ref/explorer.md` — `## aerospace — focus`, `## simple-bar — bar`, `## widgets — toggles`, `## grep — ugrep flags`. Substring matching keeps every old filter word alive. 7 dead words → 0; 22 words verified.
- **`aero-add`** → **built and live** on `prefix Ctrl+W`. App list shows every running app with its *current* rule in column 3 and its real TOML block in the preview; a two-toggle form (`1` float⇄snaps, `2` workspace + letter, `⌫`/`-` remove, `d` clear both) writes, edits in place, or removes. Hand-written rules ask `y/n`; rules with extra conditions are marked `*` and never auto-edited. Verified byte-clean: add → change → add a second → remove → remove returns `aerospace.toml` byte-identical, marker header pruned with the last rule.
- **Monitors** → **dropped by the user**, mid-arc. Findings stand in the transcript: `outer.right = 304` is flat so both screens lose the widget gutter (per-monitor form documented at `aerospace.toml:78-83`), all three Übersicht widgets are `showOnAllScreens:true` in `~/Library/Application Support/tracesOf.Uebersicht/WidgetSettings.json`, and simple-bar has its own `showOnDisplay` per widget.
- **Caps→hyper and the USB numpad** → **dropped by the user**. Both need Karabiner-Elements, which is not installed and not in either brewfile; Karabiner's device-conditional rules would have covered the numpad without writing a remapper.
- **Finder's rule** → **fixed**: its comment claimed "floats and still lands on W" but the array held one element. Restored to `["move-node-to-workspace W", "layout floating"]`, which is now the in-repo example of the two-element form.
- **Three behaviour skills** → **written and ported**: `tmpl-yn` (+`/yn`), `tmpl-done`, `tmpl-path`, with `humpty/lobby/no-path.md` carrying the two failures and the screenshot to the muzzle repo. 70 skills.
- **aero-add's automatic reload** → **parked** at `llm-plan/01-parking-lot.md` § aero-add. The user asked for a button; the tool reloads on its own. The agreed shape (form stays open on `enter`, `r` makes it live, `esc` goes back) is written up there with kill criteria.
- Prior parked items unchanged: footer-gate re-emit loop · broot Enter-on-md · Raycast-as-trigger.

## The arc (brief)

- Started as a keybind question and turned into a discoverability one: the reference card existed, but nothing in it was named after the tool it described.
- `aero-add` went through four shapes before landing — one-shot appender, refuse-on-duplicate, 34-row fzf menu, and finally the two-toggle form the **user sketched in five lines**. Scrolling a list to express two booleans was the error; his sketch replaced it wholesale.
- Every subsequent fix came from him using it: the popup vanishing on a refusal (`-E` → `-EE`), arrows closing the form (bash 3.2 floors a fractional `read -t` to zero), the cursor inviting typed input, `w` colliding with W-for-Window, esc at the `y/n` prompt exiting instead of going back.
- Two of my test runs wrote to the live `aerospace.toml` — a stray `tv.jellyfin.player` rule, and `com.apple.ActivityMonitor` moved out of its hand-written group. Both caught and restored; the config is byte-identical to its pre-session backup.
- The arc's own lesson, and why the three skills exist: the agent kept handing work back — unresolved concerns, reprinted settled state, automation nobody asked for. `humpty/lobby/no-path.md` is that correction addressed to the repo that can enforce it.
