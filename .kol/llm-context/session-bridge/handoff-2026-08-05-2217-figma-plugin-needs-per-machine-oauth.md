# Handoff — 2026-08-05 22:17

## For the iMac — the Figma plugin arrives by pull, the connection does not

`claude/settings.json:38` now carries `"figma@claude-plugins-official": true`. That file is the
symlinked `~/.claude/settings.json`, so the iMac gets the **plugin** on its next pull with nothing
to install.

**It will not be connected.** The MCP server authenticates by OAuth against a Figma account, and
that token is per-machine — it lives outside the repo by design. On the iMac the plugin will show
under **Needs attention** until someone runs the flow:

```
/plugin → Installed → figma MCP → Enter → authorize in the browser
```

The account is `Kolkrabbi` (thordur.grimsson@gmail.com), **Full seat** on Kolkrabbi & Biskup,
Kaffistofan and Aftra. Full is what permits *writing* to a file; a Dev seat reads only.

## One artifact I could not clear

The install wrote its enablement at **both** user and project scope, which created
`~/.dotfiles/.claude/settings.json` — a repo-local `.claude/` of the kind retired 2026-07-03.
Moving it to `_tmp/` was **denied by a permission classifier**, so it is still sitting at the root.

Harmless: user scope is what makes the plugin resolve in every repo, and the project copy is a
duplicate of one line. Retire it when the classifier allows.

## The lobby inbox has grown to three — none of them mine

I did not touch these. Listing them because a handoff is where a queue gets seen.

| Ticket | Staged | Needs |
|---|---|---|
| `humpty-gates-misfire-on-docs-and-command-text.md` | 2026-08-03, MBP | The humpty checkout — not on this machine |
| `index-md-is-router-only.md` | — | A doctrine call about what INDEX.md is for |
| `llm-rules-bulletin-in-scaffold.md` | 2026-08-01, kol-ds-ui | Scaffold template + skill + one repo conversion |

**The token gate misfired again this session**, exactly as that first ticket describes — it refused
a shell script in a *scratch directory* on the grounds that "the repo defines 14 `--kd-*` tokens".
The script had no relationship to this repo's CSS. That is a second live sighting of the same
defect, from a different angle: the gate does not check whether the write target is even in the
token set's repo.

## Landed today, no action needed

- **potrace** tracked at `brewfile-cli:112` — it was already installed on this machine and in
  neither brewfile. Doc written. The pipe was run, not quoted.
- **`ref-remote`** gained the one-shot ssh form, the two flags that stop an agent-run ssh hanging
  forever, the mDNS-over-Tailscale failure, and a `## volumes` section. `ref --lint` clean at 22.
- **`fonttools`** installed via `uv tool install` — cmap coverage scans and glyph outline
  extraction. Used heavily; worth keeping.

## A candidate for `bin/`, deliberately not built

The session needed to preview a word in dozens of typefaces without installing any of them.
ImageMagick reads a font file directly by path — `magick -font /path/to/X.otf label:"word"` — and
that turned into a contact-sheet script that renders every font in a directory, light and inverse.

It currently lives in a **client repo** (`~/dev/studio16/cms/website/logo/type-sheet/sheet.sh`),
which is the wrong home for a general tool. `bin/font-sheet` is the right one. Not moved: it needs
the kol-appliant treatment (`--help`, a ref row, a docs entry), and that is a task, not a copy.

## Next intended action

Nothing is mid-flight here. The iMac authorizes Figma when it wants it, and picks up whichever
inbox ticket it has the checkout for.
