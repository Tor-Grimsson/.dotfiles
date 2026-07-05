---
name: scaffold-dev-stack
description: Scaffold a new Vite + React + Tailwind 4 project in the current directory — pnpm, Vite (react template), Tailwind CSS v4 via @tailwindcss/vite, react-router-dom, and a minimal App + single-route shell. Headless — no design system. For the KOL design-system variant use /scaffold-dev-stack-kol. No agent context — run /scaffold-llm-context separately.
disable-model-invocation: true
allowed-tools: Bash, Edit, Write, Read, AskUserQuestion
---

# scaffold-dev-stack

> Sibling: `/scaffold-dev-stack-kol` scaffolds this same stack wired to the published KOL design system (`@kolkrabbi/kol-*` from npm — AppShell/SideNav, theme, the 4-point contract). Use **this** one for a clean base with no design system.

Bootstrap a new web app in the current working directory — an unopinionated stack, nothing to rip out:

- pnpm · Vite (react jsx template) · Tailwind CSS v4 (`@tailwindcss/vite`) · react-router-dom
- a minimal `App` behind a one-route `BrowserRouter` — extend from there
- Umami analytics in `index.html`, commented out — uncomment to opt in

---

## Prerequisites

1. `which pnpm` — if missing, stop: `brew install pnpm`.
2. `pwd` — **the cwd IS the project root**; the skill scaffolds into `.`, never a subfolder.
3. `ls -A` — if anything besides `.git`/`.DS_Store` exists, stop and tell the user to `cd` into an empty directory.

## Steps

### 1. Derive project name + confirm

`PROJECT_NAME` = `basename "$(pwd)"`. Show a short summary (name, root, pnpm, vite react, tailwind 4, router, umami commented out, **no design system**) and confirm via `AskUserQuestion` before touching anything.

### 2. Scaffold + deps

```sh
pnpm create vite . --template react
pnpm install
pnpm add tailwindcss @tailwindcss/vite react-router-dom
```

### 3. vite.config.js

Add the Tailwind plugin (read the file, apply the equivalent edit if the template drifted):

```js
import tailwindcss from '@tailwindcss/vite'
// plugins: [react(), tailwindcss()]
```

### 4. src/index.css

Overwrite entirely — Tailwind, nothing else:

```css
@import "tailwindcss";
```

### 5. Shell + router

- `src/main.jsx` — `BrowserRouter` → `Routes` → one index route rendering `<App />`. (Add routes as the app grows.)
- `src/App.jsx` — minimal: an `<h1>` of `PROJECT_NAME` and one Tailwind-styled `<button>` so the render proves Tailwind utilities generate.
- Delete `src/App.css`.

### 6. index.html

- `<title>` = PROJECT_NAME.
- Umami snippet commented out with a `<!-- uncomment to opt in -->` note.

### 7. Verify — actually run it

`pnpm dev`, load the page, confirm: the `PROJECT_NAME` heading renders, the button picks up its Tailwind classes (utilities generating), no console errors. Report what works and anything left for the user (umami).

## Docs

For per-repo agent context, run `/scaffold-llm-context` (lands `LLM_RULES.md` + `.kol/llm-context/`); for the docs system, run `/scaffold-docs-system` separately.
