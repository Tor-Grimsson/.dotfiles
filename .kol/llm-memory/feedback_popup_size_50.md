---
name: popup-size-default-50
description: tmux display-popup default is 50% x 50% — never 75/85% unless the user asks for big
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 09c54eb4-8e17-4aaf-9c3d-5d9cdad6575a
  modified: 2026-07-28T01:00:37.742Z
---

New tmux `display-popup` binds default to **`-w 50% -h 50%`**. The user resized ref-pick 85→50 (2026-07-27) and had to correct the clip-drop menu 75→50 the very next day ("why do you always default to huge popups?").

**Why:** He works on a desk layout with widgets and tiled panes — a huge popup covers what he's referencing. 50% is his comfort size.

**How to apply:** Any new `display-popup` bind: start at 50%×50%. Go bigger only if he asks or the content provably needs it (and say so when proposing). Existing larger popups (yazi C-y, clip filing) are his to resize, not mine to "fix".
