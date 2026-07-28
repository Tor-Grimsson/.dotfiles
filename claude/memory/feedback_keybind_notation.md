---
name: keybind-notation-spell-it-out
description: "Write keybinds as Prefix + Ctrl+P — never tmux config shorthand (C-p) in chat, and always state the prefix explicitly"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 09c54eb4-8e17-4aaf-9c3d-5d9cdad6575a
  modified: 2026-07-27T22:15:01.392Z
---

When telling the user a keybind, spell it out: **Prefix + Ctrl+P**, not `C-p`, not `prefix C-p`. He has asked at least twice (2026-07-27 was the second time) — `C-` is not clear to him, and omitting the prefix made him think Ctrl+P alone.

**Why:** `C-p` is tmux *config* syntax (`bind X` = prefix-then-X implicitly; `bind -n` = no prefix). That convention lives in `.tmux.conf`, not in his head. Quoting config shorthand in conversation reads as ambiguous instructions.

**How to apply:** In chat and reports, tmux binds are "Prefix, then Ctrl+P" / "Prefix + Ctrl+P". Say "no prefix" explicitly for `bind -n` keys. Config files and the ref cards keep their own established notation (`ctrl-x` in cards, `C-p` in `.tmux.conf`) — this rule is about how I *talk*.
