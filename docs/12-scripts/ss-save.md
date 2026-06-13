# ss-save.sh — path cheat sheet

Saves the **clipboard image** to a file via `pngpaste`.

**Help:** `ss-save.sh --help` prints the full usage (args, defaults, examples) — same rules as below.

## The mental model (this is the part that trips people up)

```
ss-save.sh   [NAME]   [DIR]
              arg 1     arg 2
```

Two **separate** args: a **name** first, a **directory** second.
It is **NOT** one combined filepath. Don't do `ss-save.sh ~/Pictures/photo.png` — that makes
`~/Pictures/photo.png` the *name* and dumps it in the current directory.

## Rules

| Thing | Behavior |
|---|---|
| `NAME` (arg 1) | defaults to `clip_<YYYYMMDD_HHMMSS>` |
| `.png` | auto-appended if you leave it off (`shot` → `shot.png`) |
| `DIR` (arg 2) | defaults to the current directory (`$PWD`) |
| `~` in DIR | expanded to `$HOME` (only when it's the **first** character) |
| missing DIR | created automatically (`mkdir -p`) |
| no image in clipboard | errors out, saves nothing |

## Examples

```sh
ss-save.sh
# → ./clip_20260604_213500.png           (timestamped default, current dir)

ss-save.sh my_shot
# → ./my_shot.png                        (.png added for you)

ss-save.sh my_shot.png
# → ./my_shot.png                        (already had .png — fine)

ss-save.sh photo "~/Pictures"
# → ~/Pictures/photo.png                 (name, THEN dir)

ss-save.sh diagram "~/Pictures/specs"
# → ~/Pictures/specs/diagram.png         (dir created if missing)

ss-save.sh shot /tmp
# → /tmp/shot.png                        (absolute dir works too)
```

## Quick rule of thumb
**WHAT** to call it → arg 1. **WHERE** to put it → arg 2. Never glue them together.
