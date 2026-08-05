# shell — explainer notes

Filter: `notes-shell <word …>` · what the syntax MEANS, not which flag to pass

## $ — variables and expansion

`$` is not a command and not a prefix in the tmux sense. It is the character
that tells the shell: **what follows is a name — put its value here.**

So `$w` reads as "the value of the variable named `w`". Any name can follow it,
and there can be as many different variables as you like.

| you write | it means                                    |
|-----------|---------------------------------------------|
| `$w`      | the variable named `w`                      |
| `$HOME`   | the variable named HOME → `/Users/kolkrabbi` |
| `${w}`    | same as `$w` — braces bound the name |
| `${w:-80}`| `w`, or `80` if unset — `:-` is a fallback |
| `$1`      | **not a name** — positional argument 1      |
| `$0`      | the name the script was called as            |
| `$@`      | every argument, as separate words            |
| `$?`      | exit status of the last command              |

A **name** after `$` means "look this up". A **number** means "the Nth argument
I was handed". Same `$`, different thing after it.

[e] — both kinds, live in one line of yazi config:

```
{ url = "*.{md,markdown}", run = 'piper -- md-preview "$1"' }
```

`$1` there is the file path piper passes in. Inside `bin/md-preview`, `$w` is a
variable piper exported before running it:

```lua
:env("w", job.area.w)   -- pane width, in columns
:env("h", job.area.h)   -- pane height, in rows
:env("t", ...)          -- "light" or "dark"
```

So the script reads `$w` and knows how wide to render — the value came from
somewhere else entirely, which is the whole point of an environment variable.

Quoting matters: `"$w"` keeps the value as ONE word even if it contains spaces.
Bare `$w` lets the shell split it on whitespace. Quote it unless you want the split.

----
doc: docs/documentation/01-shell-terminal/INDEX.md
