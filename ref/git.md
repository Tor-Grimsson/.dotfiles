# git — quick reference

Filter: `ref-git <word …>` · `[e]` = example · pfx = tmux prefix

## create

in the project folder, top to bottom — NAME is the only thing you replace

| keys    | does                                            |
|---------|-------------------------------------------------|
| init    | git init -b main                                |
| stage   | git add -A                                      |
| commit  | git commit -m "init"                            |
| publish | gh repo create NAME --private --source . |
| open    | --public instead of --private                   |

[e] — as typed (paste all four; plain `git push` works from here on):

```sh
git init -b main
git add -A
git commit -m "init"
gh repo create NAME --private --source . --push
```

rescue A — publish said "not a git repository", or origin points at a dead repo:

```sh
git remote remove origin
gh repo create NAME --private --source . --push
```

rescue B — repo exists but push says "no configured push destination":

```sh
git remote add origin "$(gh repo view NAME --json url -q .url).git"
git push -u origin main
```

----
doc: docs/documentation/17-git/01-git.md

## branch

| keys     | does                        |
|----------|-----------------------------|
| create   | git switch -c NAME          |
| publish  | git push -u origin NAME     |
| back     | git switch main             |
| list     | git branch                  |
| delete   | git branch -d NAME          |

[e] — as typed:

```sh
git switch -c fix-topnav
git push -u origin fix-topnav
```

----
doc: docs/documentation/17-git/01-git.md

## delete

made a branch in the wrong repo: back out, kill it locally, kill it remotely (only if it was pushed)

| keys        | does                            |
|-------------|---------------------------------|
| back        | git switch main                 |
| kill local  | git branch -D NAME              |
| kill remote | git push origin --delete NAME   |

[e] — as typed:

```sh
git switch main
git branch -D fix-topnav
git push origin --delete fix-topnav
```

----
doc: docs/documentation/17-git/01-git.md

## lazygit

| keys       | does                             |
|------------|----------------------------------|
| pfx C-g    | the popup (tmux, cwd)            |
| space      | stage / unstage · Enter = hunk   |
| c  A       | commit · amend                   |
| P  p       | push · pull                      |
| s r d e    | (commits) squash · reword · drop · edit |
| q          | quit                             |

----
doc: docs/documentation/17-git/03-lazygit.md

## gh

| keys    | does                                |
|---------|-------------------------------------|
| create  | gh repo create NAME --private --source . |
| rename  | gh repo rename NEW [-R owner/old]   |
| browse  | gh browse                           |
| url     | gh repo view --json url -q .url     |
| clone   | gh repo clone OWNER/NAME            |
| pr      | gh pr create / checkout / merge     |
| ci      | gh run watch / view --log-failed    |
| issues  | gh issue create / list              |
| api     | gh api … --jq                       |

----
doc: docs/documentation/17-git/02-gh.md
