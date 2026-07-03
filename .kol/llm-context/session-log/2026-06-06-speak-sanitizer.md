# 2026-06-06 — speak sanitizer (iMac)

`speak` read markdown unbearably — emoji as their Unicode names, parens/section signs/dashes vocalized. The alias is now a function that pipes `pbpaste` through a perl sanitizer before `edge-playback`. Also killed the red `[input]` errors that appeared on every run.

- `shell/.zshrc`: `speak` alias → function (+ `unalias speak` guard — shells with the old alias loaded choked on re-source, zsh expands aliases at parse time). Sanitizer: emoji/dingbats stripped, markdown markers (`*` backticks `#` bullets) stripped, links → label, `§` → "section", em/en-dashes + brackets + dangling slashes (`a/b/c` lists) → comma pauses, stutter collapsed. Verified against the offending text; perl extracted from the file verbatim and re-run clean.
- `mpv/input.conf:2`: `seek 0 absolute frames` → `seek 0 absolute+exact` — `frames` is not a valid seek flag; it spammed `[input]` errors on every mpv launch (including every `speak`).
- `docs/06-media-av/06-edge-tts.md`: table row + setup step updated to the function, sanitizer described.

Next: user ear-test (`source ~/.zshrc`, copy markdown, `speak`). Stop playback with `q`, not Ctrl-C — Ctrl-C dumps the Python traceback seen in the screenshot.
