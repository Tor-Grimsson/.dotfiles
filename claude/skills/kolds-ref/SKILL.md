---
name: kolds-ref
description: Every decision must reference the kol design system — cite the existing token, component or pattern by name and path before proposing anything new. New CSS, new components and new tokens require proof that nothing existing covers it. Triggered by /kolds-ref (user-invoked only).
---

# kolds-ref — reference the system, don't improvise

`/kolds` names the subject. **`/kolds-ref` binds the method:** nothing gets built that the system already answers.

## The contract

1. **Name the precedent first.** Before proposing markup, styling or a component, cite what exists — `packages/component/src/…`, a `--kol-*` token, an established layout contract — with its path.
2. **"None exists" is a claim, not a shrug.** If you say nothing covers it, show where you looked (the package, the token file, the docs page).
3. **Tailwind before new CSS.** A new rule or variable needs a reason Tailwind genuinely can't express (pseudo-elements, descendant selectors into unstylable markup, cascade theming).
4. **No new tokens** when an existing one is within reason. Duplicate scales are how `--kol-fg-*` and `.text-fg-*` drifted apart.
5. **Respect the tiers.** Elements are the product; apparatus/layout is consumer taste. Don't rebuild structure into the packages.
6. **Casing, copy and transform are content-layer** — components never auto-uppercase or capitalize.

## Output shape

Every proposal line carries its reference:

```
proposal            ← reference (path or token)
```

A line with no reference is either a genuine gap (say so) or improvisation (delete it).
