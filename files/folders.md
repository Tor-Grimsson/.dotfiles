# folders — quick jump targets

List with `files <word …>` (e.g. `files kol`, `files config`). Jump with `to <word>` — one match cd's straight in, several fzf-pick, no arg picks from all.
Edit this file when folders move — it's a hand-kept list, not generated, and every path must be real.

## dev — root

| path                                      | what                                                  |
|-------------------------------------------|-------------------------------------------------------|
| ~/dev/projects                            | all projects                                          |
| ~/dev/projects/kol-apps                   | all app repos (kol-client-*, kol-editor, …) |

## kol — ds

| path                                      | what                    |
|-------------------------------------------|-------------------------|
| ~/dev/projects/kol-ds-fxr                 | design-system — fxr     |
| ~/dev/projects/kol-ds-ui                  | design-system — ui      |
| ~/dev/projects/kol-ds-type                | design-system — type    |

## kol — apps

| path                                      | what                                        |
|-------------------------------------------|---------------------------------------------|
| ~/dev/projects/kol-studio                 | studio                                      |
| ~/dev/projects/kol-website                | website                                     |
| ~/dev/projects/kol-symlink                | docs aggregator — every repo, one vault |
| ~/dev/projects/kol-apps/kol-editor        | editor app                                  |
| ~/dev/projects/kol-apps/kol-media-admin   | media-admin (kol-media R2 bucket)           |

## kol — vault

| path                                      | what                                          |
|-------------------------------------------|-----------------------------------------------|
| ~/dev/projects/kol-vault                  | personal Obsidian vault                       |
| ~/dev/projects/kol-symlink/repos          | the symlinked repo-docs trees (one per repo)  |

## lobby

staging bays for issues/specs — the last path segment before `/lobby` is the flag name.
entries land in `<lobby>/inbox/`, the ledger is `<lobby>/INDEX.md` (humpty: `LEDGER.md`),
closed in `done/`, parked in `archive/`, evidence in `_assets/`, and `outbox/` holds the
receipts for tickets THIS repo filed elsewhere — 📌 means closed there, still owed here.
file: `clip-drop.sh --<repo> NAME` (screenshot) or `/lobby-<repo>` (a conversation).
read: `/lobby-list` · `bin/lobby` (Prefix + Ctrl+K) · `bin/lobby --outbox` (the receipts) ·
`/ag-init` prints anything owed back to the repo you booted in.
spec: `docs/operations/systems/lobby/`

| path                                      | what                                        |
|-------------------------------------------|---------------------------------------------|
| ~/dev/projects/kol-ds-ui/lobby            | design-system: component specs + UI issues  |
| ~/dev/projects/kol-dumpty/humpty/lobby    | agent behaviour: muzzle, output discipline  |
| ~/dev/projects/kol-website/lobby          | website: content + UI issues                |
| ~/.dotfiles/lobby                         | dotfiles: tooling + config issues           |

## config — dotfiles

| path                                      | what                                           |
|-------------------------------------------|------------------------------------------------|
| ~/.dotfiles                               | dotfiles root                                  |
| ~/.dotfiles/shell                         | zsh config (.zshrc, .p10k.zsh, .nanorc)        |
| ~/.dotfiles/bin                           | your CLI scripts (ref, files, img-*, au-*) |
| ~/.dotfiles/ref                           | ref-card data (tmux, nvim, git, …)             |
| ~/.dotfiles/files                         | this folder catalog (folders.md)               |
| ~/.dotfiles/docs                          | the per-tool docs catalog (Obsidian vault)     |

## config — claude

| path                                      | what                                            |
|-------------------------------------------|-------------------------------------------------|
| ~/.dotfiles/claude                        | repo-backed ~/.claude                           |
| ~/.dotfiles/claude/skills                 | your skills (keys-add, files-add, log-work, …)  |
| ~/.dotfiles/claude/hooks                  | your hooks (agent-reinforce, footer-gate, …)    |
| ~/.dotfiles/claude/commands               | your slash commands                             |
