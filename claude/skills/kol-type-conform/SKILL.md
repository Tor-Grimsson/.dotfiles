---
name: kol-type-conform
description: Conform text styling to the KOL type protocol — every string uses a kol-* type class or the theme's font variables; mono splits on ONE fault line (line-height-bearing kol-mono-* for anything that can wrap vs line-height-1 kol-helper-* for single-line chrome); no freestyle Tailwind sizing, no foreign font families, no monorepo-only variables. Use when porting code from other repos (monorepo, clients), when text renders in the wrong mono (Right Grotesk instead of JetBrains), when auditing a component/CSS for type conformance, or when the user says "type conform", "wrong mono", "fix the fonts".
---

# kol-type-conform — the KOL text-styling protocol

Canonical reference: `kol-design-system/docs/documentation/01-foundations/03-typography.md`. This skill is the portable enforcement procedure.

## The protocol (the part that never changes)

1. **Every piece of text uses a `kol-*` type class** — never freestyle Tailwind sizing (`text-sm`, `text-[13px]`, ad-hoc `font-size`).
2. **Mono splits on ONE fault line — "can this string ever wrap?"**
   - **No (structurally single-line)** → `kol-helper-*` — `line-height: 1`, weight 500, letter-spaced. Menu rows, labels, chips, badges, KPI/value readouts, captions, label/value pairs.
   - **Yes (can run to more than one line)** → `kol-mono-*` — carries leading, weight 400. Paragraphs, descriptions, notes, code, multi-word labels in narrow containers.
   - Never give a helper class to anything that can wrap (it sets solid); never give leading to structural chrome.
3. **One mono family:** `var(--kol-font-family-mono)` = **JetBrains Mono**. Right Grotesk cuts are the SANS families (base/narrow/compact) — Right Grotesk is never a mono.
4. **Vendored/ported CSS** (workshop-style mini-systems with their own classes) may keep its class names, but each text class must resolve to the theme's font variables and obey the fault line for its `line-height`.

## The inventory

**Helper scale** — mono, weight **500**, `line-height: 1`, letter-spaced (labels, not copy):

| Class | Size | LS | | Class | Size | LS |
|---|---|---|---|---|---|---|
| `kol-helper-8` | 8px | 0.10em | | `kol-helper-14` | 14px | 0.06em |
| `kol-helper-10` | 10px | 0.10em | | `kol-helper-16` | 16px | 0.06em |
| `kol-helper-12` | 12px | 0.06em | | `kol-helper-20` | 20px | 0.06em |

**Mono scale** — mono, weight **400**, with leading:

| Class | Size/LH | | Class | Size/LH |
|---|---|---|---|---|
| `kol-mono-8` | 8/12px | | `kol-mono-14` | 14/18px |
| `kol-mono-10` | 10/14px | | `kol-mono-16` | 16/22px |
| `kol-mono-12` | 12/16px | | `kol-mono-20` | 20/26px |

**Sans sets** (with leading): `kol-sans-display-01/02` (56/44px, LH 100%, narrow 600) · `kol-sans-heading-01` (48px, 110%, narrow 500) · `kol-sans-heading-02/03/04/05` (40/32/24/20px, compact 500) · `kol-sans-body-01/02/03` (16/14/12px, LH 150–160%, base 400).

Between helper stops? Take the tighter one (precedent: an 18px glyph → `kol-helper-16`). Above the largest helper (20px) → drop to 20, don't invent sizes.

## The sweep (porting or auditing)

1. **Foreign families:** `grep -rniE "font-family" <target>` — every hit must be `var(--kol-font-family-{mono,sans,sans-narrow,sans-compact})` or a `kol-*` class. Literal `'Right Grotesk Mono'`, `'SF Mono'`, etc. → replace.
2. **Undefined variables (the classic porting bug):** grep for `var(--kol-font-family-` names NOT in `kol-theme`/`kol-base-tokens` — e.g. the monorepo's `--kol-font-family-dash` (which *there* = JetBrains, here = undefined → silent fallback to the sans). Point at `--kol-font-family-mono`.
3. **Freestyle sizing in JSX:** grep `text-\[|text-(xs|sm|base|lg|xl)` — map to the nearest `kol-*` class (helper if single-line, mono/sans set if wrappable).
4. **LH audit on ported text classes:** single-line-by-design classes (values, labels, captions, detail rows) → `line-height: 1`; wrappable (body, titles that can break) → keep leading.
5. **Verify rendered, not asserted:** load the page, `getComputedStyle` on a chrome element and a copy element — expect `"JetBrains Mono"` and LH = font-size (chrome) / > font-size (copy).

## Precedents

- 2026-07-02 conformance sweep: package source is clean and machine-checked (`pnpm extract:docs` runs a freestyle-type offender report in kol-design-system).
- 2026-07-03: ported monorepo dashboards rendered the wrong mono via undefined `--kol-font-family-dash` (case 2 above) — fixed to `--kol-font-family-mono` + LH-1 on `dash-value`/`dash-detail`/`dash-caption`.
