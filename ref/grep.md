# grep — quick reference

Filter: `ref-grep <word …>` · `[e]` = example · your `grep` = **ugrep** (aliased); `rg` also installed

## grep — ugrep flags

| keys | does                          |
|------|-------------------------------|
| -r   | recurse a directory           |
| -i   | ignore case                   |
| -n   | line numbers                  |
| -l   | matching files only           |
| -v   | invert — lines NOT matching   |
| -c   | count matches                 |
| -C 3 | 3 lines of context            |
| -w   | whole word only               |

[e] — as typed:

```sh
grep -rn "socket" ~/.dotfiles/bin
grep -ril "kol-theme" docs
```

## regex

| keys    | does                                |
|---------|-------------------------------------|
| .       | any one character                   |
| .* .+   | any run (0+ · 1+)                   |
| ^ $     | line start · line end               |
| [abc]   | one of these — [0-9] digit          |
| [^abc]  | anything BUT these                  |
| \w \s \b | word char · whitespace · word edge |
| a\|b    | a or b                              |
| {2,4}   | repeat count                        |
| \.      | a literal dot (escape the special)  |

[e] — as typed:

```sh
grep -rn "^## " ref
grep -rniE "glow|mdcat" docs/scripts
```

## fzf

| keys | does                                 |
|------|--------------------------------------|
| C-r  | fuzzy shell-history search           |
| C-t  | insert a file path at the prompt     |
| M-c  | cd into a picked directory           |
| Tab  | fzf-powered tab completion           |
| fe   | pick a file → nvim                   |
| fzv  | fzf + image preview (chafa)          |

## in nvim

| keys | does                                          |
|------|-----------------------------------------------|
| telescope | `ref-nvim plugins telescope` — grep in nvim |

----
doc: docs/documentation/02-file-management/12-fzf.md
