---
artist: a & e sounds
album: parametric audio
albumartist: a & e sounds
year: 2015
genre: Electronic
# cover: auto-detected from _assets/cover.jpg — or set it explicitly, e.g. cover: _assets/cover.jpg
tracklist:
  - swerve
  - no time, sometimes
  - fast lane
  - blunt force trauma
  - airlines
---

# parametric audio — example album folder

This is a real, working `au-tag.sh` metadata file. The cover lives in
`_assets/cover.jpg` (au-tag checks the folder first, then `_assets/`). Drop your
`.mp3` / `.flac` files into THIS folder, next to `album.md`, then run:

```sh
au-tag.sh .
```

au-tag reads only the YAML frontmatter above; everything below is liner notes
and is ignored by the tagger — so it's a fine place to keep details that don't
map to audio tags:

- catalog: kst 003
- recorded / mixed: 050615–021215, im konsulat (e_14)
- credits: adt—w.ad; v.p. & o.h.; f. alfredo_bft
- master: d.r.
- source: 44.1 kHz / 24-bit, 00:22:29

The tracklist order pairs to the files in sort order, so name them with
zero-padded numbers — `01 swerve.mp3`, `02 no time, sometimes.mp3`, … —
and the titles + track numbers land correctly.
