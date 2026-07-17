# Accessibility Audit

Last reviewed: 2026-07-17 (bootstrap run). Manual review only — no
automated checker (axe/Lighthouse) has been run yet; see
`docs/technical-debt/backlog.md` #5.

## Known issues

1. **Heading hierarchy skips levels on the Trends Board.** `index.html`
   goes `<h1>` → `<h2>` → `<h4>` with no `<h3>`, 60 times. Fails WCAG
   2.4.6 and will be flagged by any automated checker. Tracked as
   backlog #4.
2. **No automated accessibility testing in place.** Every other item on
   this page is from a one-time manual read, not a systematic scan —
   treat this list as a starting point, not a complete audit. Tracked as
   backlog #5.

## Verified okay (from manual review)

- `lang="en"` present on every page.
- No images anywhere, so no missing-alt-text risk exists today (revisit
  if the content model ever adds raster images).
- Semantic `<nav>`, `<main>`, `<article>`, `<header>` landmarks used
  throughout the pages reviewed (`index.html`, `articles/index.html`,
  module pages).

## Not yet checked

- Keyboard navigation through interactive elements (tag filters, search,
  code tabs, dependency graph nodes in `manual/index.html`).
- Visible focus states.
- WCAG AA color contrast for the custom-property-driven light/dark
  palettes.
- Screen-reader label quality on non-text/interactive controls (e.g. the
  SVG dependency graph in `manual/index.html`).

These should be worked through as accessibility becomes the selected
priority in a future run, ideally with an automated tool once the tooling
ADR (backlog #6) is resolved.
