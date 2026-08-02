---
name: feedback_print_the_path
description: Never show an icon/asset/file finding without printing its path — the path IS the handle to the source
metadata:
  type: feedback
---

When showing or discussing any concrete file artifact — an icon, an SVG, a component, a config block, a rendered preview cell — **print its repo-relative path in the same message**. Never make the user ask "where is that?".

**Why:** repeated failure (called out hard 2026-07-29, kol-ds-ui icon review): glyphs were shown, compared, and ruled on across a whole session with no path anywhere — the user had no way to jump to the source. A finding without its path is unactionable.

**How to apply:** every icon/file mentioned by name gets its path on first mention (`packages/icons/src/kol-icon-set-v1/editing/scribble.svg`); review pages/tables include a path column or per-item path line; `file:line` form when a specific spot matters. Applies in every repo.
