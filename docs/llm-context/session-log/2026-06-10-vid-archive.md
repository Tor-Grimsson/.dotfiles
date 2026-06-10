# 2026-06-10 — vid-archive.sh (10-bit CRF archive encoder)

Added a new `vid-` family member that fills a real gap: the existing scripts force a choice between **10-bit but ~200 Mbps** (`vid-h265-10b`, a near-lossless mezzanine barely smaller than ProRes) and **small but 8-bit** (`vid-h265-small*`, which bands on motion-graphic gradients). `vid-archive.sh` is the missing **small + 10-bit** option: software `libx265` at constant-quality **CRF** (not fixed bitrate), `yuv420p10le`, `.mp4` — the keep-forever copy that also plays everywhere, 10–30× smaller than ProRes.

## Changes
- `bin/vid-archive.sh` — **new.** Batch cwd-globber with optional flags (hybrid of the zero-flag globbers + `vid-convert`'s getopts). `libx265 -preset medium -crf 20 -pix_fmt yuv420p10le -tag:v hvc1 +faststart -c:a copy`. Flags: `-s <height>` (downscale, **never upscales** — ffprobe-gated `min(srcH,target)`), `-q <crf>` (default 20), `-g` (`-tune grain` for live footage). Resolution-agnostic: 4K→4K, 1080p→1080p, same command. Globs `.mp4` too but skips its own `*_h265.mp4`/`*_h265_<H>p.mp4` outputs; existing output left untouched → idempotent. Output `<name>_h265.mp4` / `<name>_h265_<H>p.mp4`.
- `docs/12-scripts/vid-archive.md` — **new** playbook companion (Overview → 0. Prereqs → CRF+10-bit rationale → one-liner → script+flags → §4 downscale/no-upscale → §5 grain (animation vs live) → §6 family placement → §7 verification).
- `docs/12-scripts/02-video.md` — `related` += vid-archive; new **archive vs mezzanine vs delivery** intro para; table row (after `vid-convert`, tagged "Archive default"); per-script section; `updated` 06-10.
- `docs/12-scripts/INDEX.md` — vid family **12 → 13**, flagship line += `vid-archive.sh`, `updated` 06-10.
- `docs/12-scripts/video-archive-pipeline.md` — **new** workflow playbook (broader than the per-script ref): the end-to-end archive pipeline. ASCII flow diagram, 3-tier model (master / archive / derivative+delivery) table, keep-the-ProRes decision table, `-s` derivative table, delivery/reframe fork table, full **file-naming reference** table, and a worked 10.37 GB 4K → ~0.85 GB example. Reciprocal `related:` back-links added to `vid-archive.md` + `02-video.md`. Caught + fixed one correctness bug in the worked example: `vid-h264-web.sh` globs the whole cwd and only skips `*_web.mp4`, so it'd web-encode the `_h265` files too → example now runs the delivery step on the master in a scratch subfolder, with a batch-globber caveat callout.

## Why this, not a `.zshrc` function
First instinct (from the kol-claude side of the conversation) was a `vshrink` shell function — wrong for this repo. The convention is `bin/vid-*.sh` + `--help` + a catalog doc; a loose function would fragment the family. `-h` stays the universal help flag, so height is `-s`.

## Verified (real encode, synthetic 4K + 1080p ProRes sources)
- Native: `hevc / yuv420p10le / hvc1`, x265 log `CRF-20.0` (constant-quality confirmed).
- `-s 1080` on 4K → `_h265_1080p.mp4` at exactly 1920×1080, still 10-bit.
- `-s 2160` on 1080p → native `_h265.mp4`, **no** `_2160p` (no-upscale guard works).
- Idempotent re-run skips everything; own outputs never re-archived. `bash -n` clean.

## Not a Brewfile change
ffmpeg is already in the Brewfile and its default build includes libx265 (confirmed `ffmpeg -encoders | grep libx265`). No VideoToolbox needed (pure software path). Nothing to install.

## Next (user-owned — agent never runs git)
1. Commit so the MBP picks up `bin/vid-archive.sh` + the three doc changes. `~/bin` is a **dir symlink** → the script is live on PATH immediately on both machines, no bootstrap.
2. Optional: stamp a Finder Quick Action via `qa-make.sh` if you want a right-click "Archive video" (not done — speed-bound software encode is awkward as a one-click action).
