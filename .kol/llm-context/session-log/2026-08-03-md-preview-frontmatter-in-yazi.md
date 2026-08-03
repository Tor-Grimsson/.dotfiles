# Session: md-preview — frontmatter visible in the yazi markdown preview

**Date:** 2026-08-03
**Agent:** Claude Code (Grim) — MBP
**Summary:** yazi's markdown preview hid every doc's frontmatter because both renderers in the chain discard it by design. Added `bin/md-preview`, which prints the frontmatter as a properties block and hands the body to mdcat unchanged.

## The finding

- **mdcat renders the preview pane, not glow.** glow is only an opener (`yazi.toml:67`, `glow -p`). The preview previewer was `mdcat` (`yazi.toml:160`). Both strip frontmatter, so the symptom looked the same from either side.
- **The strip is positional, not content-based.** A `---` YAML block at byte 0 is parsed as a metadata block and discarded. Verified: the identical block preceded by one blank line renders as a thematic break plus a setext H2 — so it is "the first block is metadata", not "YAML gets hidden".
- **glow 2.1.2 has no flag for it** — nothing in `--help` matching front/meta/yaml/raw. mdcat 2.14.0 same behaviour. There is no configuration that gets both rendering and frontmatter out of these two tools.

## Changes Made

- `bin/md-preview` — **new.** Splits at the frontmatter fence: keys in 214, gutter + values dim, a rule, then `mdcat -` on the body. Falls through to plain `mdcat` when a file has no frontmatter.
- `yazi/yazi.toml:160` — the `.md`/`.markdown` previewer repointed from `mdcat` to `piper -- md-preview "$1"`, with the fallback line noted in the comment.

## Install — done by the user, same session

- **`ya pkg add yazi-rs/plugins:piper`** run by the user. `package.toml` now carries the dep at `rev b9598e6`, and the plugin deployed to `yazi/plugins/piper.yazi`. yazi previewers take a plugin name rather than a shell command; piper is the bridge that lets `md-preview` be one.
- **Not visually confirmed in yazi yet** — the user will check later. The renderer itself is proven standalone (below); what is unconfirmed is the piper hand-off inside the preview pane.

## Not done

- No doc written under `docs/scripts/`. The kol-appliant contract wants one; skipped for time, and `md-preview` carries its own why-comment in the meantime.

## Verified

- `md-preview` run against `docs/operations/systems/agent-system/12-setup-a-to-z.md`: all seven frontmatter keys printed including the nested `tags:`/`related:` lists, rule, then the body rendered by mdcat as before.
- `~/bin` → `~/.dotfiles/bin`, so `which md-preview` already resolves — no PATH work needed.
