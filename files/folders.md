# folders — quick jump targets

List with `files <tag …>` (e.g. `files kol`, `files config`). Jump with `to <tag>` — one match cd's straight in, several fzf-pick, no arg picks from all.
Edit this file when folders move — it's a hand-kept list, not generated, and every path must be real.

## #dev #root
~/dev/projects                            all projects
~/dev/projects/kol-apps                   all app repos (kol-client-*, kol-editor, kol-radar, …)

## #kol #ds
~/dev/projects/kol-ds-fxr                 design-system — fxr
~/dev/projects/kol-ds-ui                  design-system — ui
~/dev/projects/kol-ds-type                design-system — type

## #kol #apps
~/dev/projects/kol-studio                 studio
~/dev/projects/kol-website                website
~/dev/projects/kol-symlink                docs aggregator vault (every repo's docs, one Obsidian vault)
~/dev/projects/kol-apps/kol-editor        editor app
~/dev/projects/kol-apps/kol-media-admin   media-admin (kol-media R2 bucket)

## #kol #vault
~/dev/projects/kol-vault                  personal Obsidian vault
~/dev/projects/kol-symlink/repos          the symlinked repo-docs trees (one per repo)

## #config #dotfiles
~/.dotfiles                               dotfiles root
~/.dotfiles/shell                         zsh config (.zshrc, .p10k.zsh, .nanorc)
~/.dotfiles/bin                           your CLI scripts (keys, files, img-*, vid-*, au-*)
~/.dotfiles/keys                          keybinds reference data (keybinds.md)
~/.dotfiles/files                         this folder catalog (folders.md)
~/.dotfiles/docs                          the per-tool docs catalog (Obsidian vault)

## #config #claude
~/.dotfiles/claude                        repo-backed ~/.claude
~/.dotfiles/claude/skills                 your skills (keys-add, files-add, log-work, …)
~/.dotfiles/claude/hooks                  your hooks (agent-reinforce, footer-gate, …)
~/.dotfiles/claude/commands               your slash commands
