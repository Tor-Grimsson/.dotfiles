---
name: tmpl-proposal
description: Stage a side-by-side visual-review page (current vs proposed, light+dark panes, size ramp, in-set refs, keyline-guides toggle) in the repo's _tmp/ for user approval. Use when presenting visual proposals — icons, component chrome, styling variants — for review before landing ("show me and I'll approve", "stage for review", "make them and show me").
---

# tmpl-proposal — the staged-proposal review page

Part of the `tmpl-` family: standardised output templates (user convention
2026-07-29 — `tmpl-` prefixes any future standardised-output skill).

The canonical way to SHOW visual work for approval. Proposals never touch the
real source until the user approves — they're staged as files plus ONE
self-contained HTML page the user opens locally. Born from the 2026-07-29
icon-stroke review (kol-ds-ui); keep this shape.

## Rules

1. **Stage, don't land.** Proposal files + `preview.html` go in the repo's
   `_tmp/<task>-proposals/` (verify `_tmp/` is gitignored; add it if missing).
   The package/app source is untouched until explicit approval.
2. **Both themes, always.** Two panes side by side — light `#fafafa`/`#111`,
   dark `#111`/`#fafafa`. Same content rendered into each; glyphs use
   `currentColor` so one payload serves both.
3. **Per item, four cells in one row** — the row label carries the item's
   TAXONOMY home (`rows · layout`, group dimmed) AND its repo-relative source
   path (dimmed, small, under or beside the name) — the user must always be
   able to jump to the file being judged (user law 2026-07-29: never show an
   icon/asset without printing its path):
   - **current** at large size (96) — what ships today
   - **proposed** at large size (96) — the candidate
   - **size ramp** of the proposed at real usage sizes (16 · 20 · 24 · 32 · 48)
   - **set refs** — 1–2 canonical neighbours from the live set at 24, behind a
     hairline left border, so weight/idiom is judged against the system, not
     in a vacuum

   **Annotate in text, not just pixels — and say each constant ONCE:** column
   facts (`current · 96px`, `proposed · 96px · stroke 6px`, ramp range, refs
   size) live in ONE dimmed header row above the rows — never repeated per
   cell; repeated long tags also break the column alignment (user ruling
   2026-07-29). Per-cell tags carry ONLY what varies by row: what the
   current file actually is (`stroke 1u → 4px` / `fill`) and the ramp step
   sizes. Stroke is stated in RENDERED px (it scales linearly with
   container/viewBox — ×4 at 96 on a 24 grid); authoring units appear ONCE
   in a page-level line mapping viewBox stroke to effective px per render
   size (e.g. 1.5u/24 → 1px @16 … 6px @96). When perceived weight disputes
   arise, MEASURE — rasterize to canvas and scanline the dark-pixel runs;
   equal strokes can still read unequal (ink-density optics: rings/junctions
   read heavier than isolated lines in whitespace).
4. **Guides toggle.** ONE toggle PER PANE, fixed at the bottom, same location
   in each, contrast-inverted per pane (dark chip on the light pane, light
   chip on the dark pane) — user ruling 2026-07-29. Findable by POSITION,
   never by loudness. **The page chrome conforms to the design system it
   serves**: in KOL that's mono type, the 4px radius law, hairline borders,
   no drop shadows, no accent fills, no pills — neutral chips whose state
   reads through text strength (`guides · on/off`, `aria-pressed`, dimmed
   when off; all chips toggle the one global state and update together).
   Both earlier 2026-07-29 failures live here too: a corner chip the user had
   to hunt for, then an over-corrected magenta pill with a drop shadow —
   foreign chrome inside the DS repo. Findable placement + quiet idiom, both. It toggles a keyline overlay on EVERY
   glyph cell. For KOL icons replicate `KeylineBg` **verbatim**
   (`showcase/src/lib/icon-controls.jsx` in kol-ds-ui): dashed diagonals
   `#0A8DA4`, keyline rects (4,2,16×20 · 3,3,18×18 · 2,4,20×16, rx 1) +
   center circle r4, stroke 0.1 dash `0.4 0.6` — **magenta `#CA3ABC` on
   light, yellow `#F2D24B` on dark**. Default the page to guides ON.
   Toggle the overlay with `visibility`, not `display` — layout rules like
   `.cell svg { display:block }` out-specify a `.guide { display:none }` and
   pin the overlay permanently on (the exact bug that shipped 2026-07-29).
5. **Chrome stays quiet.** 13px JetBrains Mono, lowercase item names at 55%,
   10px tags at 45%, hairline separators. The work is the page; the chrome
   whispers.
6. **Self-verify before showing — render AND interaction.** Playwright blocks
   `file:` — spin `python3 -m http.server <port>` in the staging dir, note the
   PID, navigate, full-page screenshot, READ the screenshot and actually judge
   the render (weight vs refs, symmetry, gaps). Then **drive every control**:
   click the toggle and assert the effect flipped (e.g. computed `visibility`
   of a `.guide`), not just the label — a label that flips over a dead effect
   is the failure mode that shipped 2026-07-29. Then **kill exactly that PID**
   and delete the check screenshot. Never leave the server up; never
   screenshot to repo root.
7. **Hand over one command:** `open _tmp/<task>-proposals/preview.html`.
   The user reviews in their own browser (file:// is fine for humans).
8. **In the chat report:** a table of items with the target's repo-relative
   PATH, a one-line proposal + source of truth each ("legacy stroke twin",
   "current v1 geometry", "user instruction"), plus the scan verdicts you did
   NOT build (dupes → cull, deliberate designs → keep) so the review is over
   the whole scan, not just the built subset. Every named file, everywhere,
   with its path.
9. **After approval:** land the approved files into the real source, bump +
   publish per the repo's release ritual, then delete the staging folder.

## Page skeleton

Adapt the payload; keep the structure. Everything inline — no CDNs, no build.

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>REPO — TASK proposals</title>
<style>
  body { margin: 0; font: 13px/1.5 "JetBrains Mono", monospace; display: flex; min-height: 100vh; }
  .pane { flex: 1; padding: 32px 40px; }
  .pane.light { background: #fafafa; color: #111; }
  .pane.dark  { background: #111; color: #fafafa; }
  h1 { font-size: 14px; font-weight: 600; margin: 0 0 24px; }
  .row { margin-bottom: 36px; }
  .name { font-size: 12px; opacity: .55; margin-bottom: 10px; }
  .cells { display: flex; align-items: flex-end; gap: 28px; }
  .cell { display: flex; flex-direction: column; align-items: flex-start; gap: 6px; }
  .cell .tag { font-size: 10px; opacity: .45; }
  .ramp { display: flex; align-items: flex-end; gap: 14px; }
  .refs { display: flex; gap: 14px; align-items: center; padding-left: 20px;
          margin-left: 8px; border-left: 1px solid rgba(128,128,128,.3); }
  .sep { height: 1px; background: rgba(128,128,128,.25); margin: 28px 0; }
  /* labels align LEFT to their column edge — never centered (user ruling 2026-07-29) */
  .head { display: flex; gap: 28px; font-size: 10px; opacity: .45; margin: 0 0 18px; }
  .head .c96 { width: 96px; text-align: left; }
  .head .cramp { width: 196px; text-align: left; }
  .head .crefs { padding-left: 20px; margin-left: 8px; }
  .icel { position: relative; display: inline-block; line-height: 0; }
  /* visibility, not display — .cell svg { display:block } out-specifies .guide */
  .guide { position: absolute; inset: 0; width: 100%; height: 100%;
           pointer-events: none; visibility: hidden; }
  body.guides-on .guide { visibility: visible; }
  .guides-btn { position: fixed; bottom: 16px; transform: translateX(-50%);
    z-index: 10; font: 11px/1 "JetBrains Mono", monospace; letter-spacing: 1px;
    padding: 8px 14px; border-radius: 4px; cursor: pointer;
    border: 1px solid rgba(128,128,128,.4); }
  #guides-btn-l { left: 25%; background: #1a1a1d; color: rgba(250,250,250,.92); }
  #guides-btn-r { left: 75%; background: #fafafa; color: rgba(17,17,17,.92); }
  body:not(.guides-on) #guides-btn-l { color: rgba(250,250,250,.45); }
  body:not(.guides-on) #guides-btn-r { color: rgba(17,17,17,.45); }
  .name .cat { opacity: .55; }
</style>
</head>
<body class="guides-on">
<button id="guides-btn-l" class="guides-btn" type="button" aria-pressed="true">guides · on</button>
<button id="guides-btn-r" class="guides-btn" type="button" aria-pressed="true">guides · on</button>
<div class="pane light"><div id="mount-light"></div></div>
<div class="pane dark"><div id="mount-dark"></div></div>
<script>
const ICONS = { /* name: { current: `<svg viewBox="0 0 24 24" ...>`, proposed: `...` } */ };
const REFS  = { /* name: `<svg ...>` — canonical set neighbours */ };
const refFor = { /* itemName: ['refA','refB'] */ };

const GUIDE = (bgLight) => {
  const diag = '#0A8DA4';
  const key = bgLight ? '#CA3ABC' : '#F2D24B';   // KeylineBg verbatim
  return `<svg class="guide" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
    <g stroke="${diag}" stroke-width="0.1" stroke-dasharray="0.4 0.6" fill="none">
      <path d="M0 0 L24 24"/><path d="M24 0 L0 24"/></g>
    <g stroke="${key}" stroke-width="0.1" stroke-dasharray="0.4 0.6" fill="none">
      <rect x="4" y="2" width="16" height="20" rx="1"/>
      <rect x="3" y="3" width="18" height="18" rx="1"/>
      <rect x="2" y="4" width="20" height="16" rx="1"/>
      <circle cx="12" cy="12" r="4"/></g></svg>`;
};
const sz = (svg, n, bgLight) =>
  `<span class="icel">${svg.replace('<svg ', `<svg width="${n}" height="${n}" `)}${GUIDE(bgLight)}</span>`;

function render(mount, label) {
  const bgLight = label === 'light';
  let html = `<h1>TASK proposals — ${label}</h1>`;
  // page-level sub line: authoring units → effective px mapping, stated once
  html += `<div class="head"><span class="c96">current · 96px</span><span class="c96">proposed · 96px · stroke 6px</span><span class="cramp">proposed ramp 16–48px</span><span class="crefs">set refs · 24px</span></div>`;
  for (const [name, v] of Object.entries(ICONS)) {
    html += `<div class="row"><div class="name">${name} <span class="cat">· ${GROUP[name]}</span></div><div class="cells">`;
    html += `<div class="cell">${sz(v.current, 96, bgLight)}<span class="tag">${CUR_NOTE[name]}</span></div>`;
    html += `<div class="cell">${sz(v.proposed, 96, bgLight)}</div>`;
    html += `<div class="cell"><div class="ramp">${[16,20,24,32,48].map(n =>
      `<div class="rstep">${sz(v.proposed, n, bgLight)}<span class="tag">${n}</span></div>`).join('')}</div></div>`;
    html += `<div class="refs">${refFor[name].map(r => sz(REFS[r], 24, bgLight)).join('')}</div>`;
    html += `</div><div class="sep"></div></div>`;
  }
  mount.innerHTML = html;
}
render(document.getElementById('mount-light'), 'light');
render(document.getElementById('mount-dark'), 'dark');
const btns = [document.getElementById('guides-btn-l'), document.getElementById('guides-btn-r')];
btns.forEach((b) => b.addEventListener('click', () => {
  const on = document.body.classList.toggle('guides-on');
  btns.forEach((x) => {
    x.textContent = `guides · ${on ? 'on' : 'off'}`;
    x.setAttribute('aria-pressed', String(on));
  });
}));
</script>
</body>
</html>
```

## Non-icon adaptations

Components/chrome: swap the 24-viewBox payload for rendered HTML snippets in
an iframe-free block; drop the keyline GUIDE (or replace with a baseline/
spacing grid) but KEEP panes, current-vs-proposed, ramp (breakpoint widths
instead of pixel sizes), refs, and the staging + verify + approval rules —
they are the skill; the SVG mechanics are just this page's payload.
