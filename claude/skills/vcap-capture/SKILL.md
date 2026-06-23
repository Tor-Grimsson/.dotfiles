---
name: vcap-capture
description: >
  Author a kol-vcap console command to screen-record a page region (canvas/stage)
  as MP4 or transparent WebM. Use when the user wants to record/capture animated or
  generative output that has no built-in export, a transparent-background clip, or
  any DOM region that can't be exported programmatically. This skill WRITES the
  command + the keystroke steps — it does NOT drive Chrome (tabCapture is gesture-gated).
---

# vcap-capture

[kol-vcap](https://github.com/Tor-Grimsson/kol-vcap) is a Chrome MV3 extension exposing
`window.vcap` in the page console. It records the active tab via `chrome.tabCapture`,
crops to a CSS selector in an offscreen canvas, and downloads the file. **Starting a
capture needs a real user gesture (the ⌘⇧V / Ctrl+Shift+V hotkey) — it cannot be fired
from JS or reliably from CDP/Playwright.** So this skill's job is to emit the exact
`vcap.start(...)` command and the human steps, not to automate the capture.

## 0. Decide whether vcap is even the right tool

vcap is the **manual escape hatch**, not the default. Check first:

1. **Does the page already export what's needed?** A built-in PNG/SVG/WebM export or a
   `captureStream`-based recorder (e.g. Drift's *Record loop*) is exact, automatable, and
   higher-res. If it covers the ask, point the user there and stop.
2. **Use vcap only for the gap:** transparent-background clips, CSS/SVG/SMIL animation,
   third-party/foreign DOM, composited chrome, or any page with no native export.

## 1. The target marker (the convention vcap depends on)

vcap crops to a selector's bounding box. Target a **stable marker on the artboard element
itself** — the `<canvas>`/`<svg>`/stage box, tight to the visible output:

```
data-vcap="stage"          → selector  '[data-vcap="stage"]'
```

- Put it on the element whose box equals the rendered output. **Not** the centering flex
  wrapper — that box includes letterbox padding and you'd record the margins.
- **If the page has no marker:** add it (one attribute on the artboard element), then
  proceed. This is how the convention spreads — lazily, per page, never a big sweep.
- Seeded pilot: `src/pages/drift/DriftEditor.jsx` (`<canvas data-vcap="stage" …>`).

## 2. Derive the options

`vcap.start(selector, opts)` — relevant keys (full defaults in §4):

| key | how to set it |
|---|---|
| `duration` | ms; auto-stops. For a looping page, use **exactly one loop**: loop-length seconds × 1000 (Drift: the preset's `period` × 1000). Else ask / default 5000. |
| `background` | `'transparent'` → WebM/VP9 (subject to comp). A colour or `null` → opaque MP4/H.264. |
| `scale` | output multiplier (default `2` = @2×). Bump for higher-res, drop to `1` for size. |
| `isolate` | `true` to hide everything but the target (clean element-only / transparent capture when panels overlap the bbox). |
| `margin` | px padding around the bbox; default `0`. |
| `filename` | optional; else auto-named. |

## 3. Emit the command + the steps

Output the one-liner and the checklist. Example (Drift "Storm", `period` 6s, opaque):

```js
vcap.start('[data-vcap="stage"]', { duration: 6000, scale: 2, margin: 0 })
```

Transparent subject clip:

```js
vcap.start('[data-vcap="stage"]', { duration: 6000, background: 'transparent', isolate: true, scale: 2 })
```

Then tell the user, in order:
1. Chrome with the kol-vcap extension installed; open the page; set its state (preset,
   playing, aspect) the way it should record.
2. Open DevTools console, paste the command above.
3. Press **⌘⇧V** (Mac) / **Ctrl+Shift+V** to begin; it auto-stops at `duration` (or
   `vcap.stop()`). The file downloads.

## 4. kol-vcap reference

`window.vcap = { start, stop, config, status, capabilities, help }`

`start(selector?, opts?)` or `start({ selector, ... })`. DEFAULT_CONFIG:

```js
{ selector: null, isolate: false, background: null, stripEffects: false,
  margin: 0, scrollIntoView: true, trackElement: false, scale: 2,
  duration: null, format: 'auto', filename: null }
```

- `vcap.stop()` — halt + clear isolation · `vcap.status()` → `{ mode: idle|armed|recording }`
- `vcap.config(opts)` — set session defaults · `vcap.capabilities()` → codec support · `vcap.help()`

## 5. Constraints (state these every time)

- **Chrome-only**, extension must be installed; the hotkey gesture is mandatory.
- Captures the **tab** at display size × `scale` — frame the page before recording.
- **Don't change aspect/resize mid-record** — the canvas resizes under the stream → glitch frame.
- vcap ≠ deterministic frame-stepping. For an *exact* seamless loop on a page we own, prefer a
  built-in `captureStream` recorder; reach for vcap when its transparency/DOM-region reach is the point.
