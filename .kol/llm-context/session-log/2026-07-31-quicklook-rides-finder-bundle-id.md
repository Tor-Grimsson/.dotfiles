# Session: QuickLook rides Finder's bundle id — and the flag syntax that proved it

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Summary:** Spacebar-previewing in Finder threw the QuickLook panel onto the other monitor and dragged that monitor's workspace with it. Cause: the panel reports as `com.apple.finder`, so every Finder `on-window-detected` rule catches it. Found by forcing `list-windows` to print fields its default output hides.

## Changes Made

### Files Modified
- `aerospace/aerospace.toml` — new `[[on-window-detected]]` **above** the Finder rule: `if.app-id = 'com.apple.finder'` + `if.window-title-regex-substring = 'Quick Look'` → `layout floating`. Comment carries the verified evidence, the query that produced it, and the first-match-wins reason it must stay on top. Finder rule's own comment corrected — it still claimed "and still lands on W" after the user had removed `move-node-to-workspace W`.
- `ref/desk.md` — new `## aerospace — panels` section: the trap, the tell, the symptom, the cause, the guard, and `list-windows` ≠ `list-apps`.
- `docs/documentation/09-productivity-desktop/05-aerospace.md` — the investigation technique, written up as reusable procedure.

## The technique — forcing a hidden window to identify itself

`aerospace list-apps` will never show QuickLook. **It is not an app** — it's a window drawn by `QuickLookUIService.xpc`, an XPC service running on Finder's behalf, so the Accessibility API attributes it to Finder's process. It exists only at the window layer.

```sh
aerospace list-windows --monitor all --app-bundle-id com.apple.finder \
  --format '%{window-id} | %{app-bundle-id} | %{app-name} | %{window-title}'
```

Live result, with a preview open:

```
108 | com.apple.finder | Finder | /Users/biskup/dev/projects/kol-website/docs/operations
800 | com.apple.finder | Finder | Quick Look
```

Three flags do the work:

| flag | why it's load-bearing |
|---|---|
| `list-windows` | one row per **window**, not per app — the only layer the panel exists on. `list-apps` is structurally incapable of showing it. |
| `--monitor all` | a filtering flag is **required**. Bare `--all` conflicts with `--app-bundle-id` and exits 2 — the same silent failure that made `aero-add`'s window-catch loop report `0 open window(s) moved` on 2026-07-30. |
| `--format '%{…}'` | the default output is `id \| app-name \| title`, which shows the title but **not the bundle id**. The explicit format prints `app-bundle-id`, which is what proves the panel genuinely *is* `com.apple.finder` rather than something that merely looks like Finder. |

**The generalisable move:** when a window behaves as if it belongs to an app it isn't part of, don't reason about it — make the tool print the fields it hides by default, with the window on screen. `--format` turns a guess into a fact. The panel is transient, so it must be open at the moment you ask; an identical query an hour earlier returned only the two real Finder windows.

## Current State

### Working
- The title is the literal string **`Quick Look`** — not the previewed filename — so it is a stable discriminator for `if.window-title-regex-substring`.
- Guard rule sits above the Finder rule; `aerospace reload-config --dry-run` → OK.
- `ref-desk panels` renders and filters.

### Known Issues
- The guard is a **no-op today**: the user had already stripped `move-node-to-workspace W` from the Finder rule while debugging. It exists so the bug cannot return silently if W comes back — which the rule's comment says is the intent.
- The same trap applies to any XPC-hosted panel (share sheets, Open/Save dialogs, other preview surfaces). Only QuickLook has been enumerated.

## Next Steps
1. If Finder's `move-node-to-workspace W` is restored, confirm the guard holds — preview a file and check the panel stays put.
2. Run the same `--format` query on a share sheet / Open dialog if either starts getting caught by an app rule.
