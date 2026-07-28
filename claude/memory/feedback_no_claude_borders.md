---
name: no-claude-borders
description: "User hates default \"claude-style\" rounded bordered cards and pill chips — especially in terminal-styled artifacts/UI. Flat surfaces, hairlines, block highlights, tiny radii."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4fba9653-822c-4c06-8e3c-8130faf49dc4
---

"I HATE these claude borders — always have, always will." And: "when is the last time you saw a pill in the terminal? me personally? probably never."

**Why:** The default AI-design look (rounded bordered cards, pill-shaped chips/buttons/badges) reads as templated slop to him, and it's factually wrong for terminal aesthetics — terminals are flat: hairline separators, block (statusline-segment) highlights, gutter sign-bars, bracket `[key]` notation.

**How to apply:** In any artifact/UI for him (especially terminal-themed, but as a general default):
- **No bordered rounded cards** — flat rows/sections separated by 1px hairlines, or left gutter bars (2-3px solid) for state/flags.
- **No pills** — active states are solid rectangular blocks (statusline-style, radius 0); keys as plain colored text or `[ bracket ]` notation.
- **Radius scale:** 4–8px ONLY at the window level (AeroSpace-like); inside content it steps 4 > 2 > 1 > 0 — default 0.
- Derive style from the KOL DS (`~/dev/projects/kol-ds-ui`, /claude-kol-ds skill): fg-opacity hairlines, tokens, JetBrains Mono ([[kol-vs-ds-terminology]]).
- Exception: mocks that reproduce a reference the user supplied (e.g. simple-bar's capsule menubar) follow the reference.
