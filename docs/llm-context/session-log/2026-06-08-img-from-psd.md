# 2026-06-08 — img-from-psd.sh + docs (iMac)

A `_tmp/` PSD→image quick-action script/doc got landed into the repo under house convention: new `bin/img-from-psd.sh` + catalog/companion docs.

- `bin/img-from-psd.sh`: PSD → JPG/PNG converter (ImageMagick `[0]` composite, `-f/-r/-q/-d/-o` flags, batch). Renamed off the doc's `psd2img.sh` to the `img-` domain-prefix scheme (parallels `pdf-from-images.sh`). Header/help rewritten from the doc's brittle `sed -n` self-extract to the house `usage()` heredoc + `case … -h|--help` dispatch. `chmod +x`, `--help` + no-args error smoke-tested OK.
- `docs/12-scripts/03-image.md`: added table row + per-script section (count is the catalog home); `related:` → companion deep-dive.
- `docs/12-scripts/img-from-psd.md`: the `_tmp` playbook moved in as the family companion doc (pattern = `[[ss-save]]`). §2 full script body swapped for a source pointer; `-resize` cheat sheet + Quick-Action wiring (incl. §5 resolution-prompt) kept; hardcoded `/usr/local/bin` → `$(brew --prefix)/bin` for cross-arch; added a `qa-make.sh` one-liner form.
- `docs/12-scripts/INDEX.md`: img count 7 → 8, Quick Action note added.
- `docs/12-scripts/10-quick-actions.md`: PSD example added to "Making your own" + `related:` cross-ref.
- Removed `_tmp/03-psd-to-image-quick-action.md` and the now-empty `_tmp/`.

- **Quick-Action PATH fix (same session):** caught that `$(brew --prefix)/bin` in the QA wiring is broken under Automator's bare PATH (`brew` itself isn't on it to resolve). Swapped every QA `export PATH` to list **both** brew prefixes literally — `/opt/homebrew/bin:/usr/local/bin` — so `magick` resolves on either machine (absent prefix = ignored PATH entry). Touched `img-from-psd.md` (§4 manual body, §4 qa-make one-liner, §5 prompt body, step-4 text), and `10-quick-actions.md` (PSD example, swept the `img-web` "Web export" example too, + a new bare-PATH bullet in "How it works"). **Deliberate bend of ARCHITECTURE §1** (no hardcoded brew prefixes) — flagged to user, accepted: the both-prefixes form stays cross-machine-portable, and §1's own escape hatches (bare PATH / `$(brew --prefix)`) don't work in the Automator context.

Next: nothing required. Optional — actually stamp the Quick Action (`qa-make.sh …`) if you want it live in Finder. User owns git; nothing committed.
