# Roadmap

Last reviewed: 2026-07-19. Reflects the audit in
`docs/technical-debt/backlog.md`. Re-prioritize as runs land.

## Immediate (next 1-3 runs)

- **Add real SEO meta tags per page** (backlog #1, slice a): unique
  `<meta name="description">`, `rel="canonical"`, Open Graph, and Twitter
  Card tags on `index.html`, `articles/*.html`, and `manual/*.html` (13
  pages total — likely needs its own slicing across 2 runs to stay under
  the ~10-file-per-run guideline). Mechanical, low-risk, high-value —
  now the top open SEO item since `robots.txt`/`sitemap.xml` landed
  2026-07-18.
- **Fix Trends Board heading hierarchy** (backlog #4): confirm intended
  outline, close the h2→h4 gap.

## Next (once Immediate items land)

- **JSON-LD Article/BlogPosting structured data** (backlog #1, slice b)
  for article and module pages, once basic meta tags exist.
- **Decide on tooling strategy via ADR** (backlog #6): can we get
  lint/a11y/link-checking without introducing a build step that conflicts
  with the "fully self-contained page" design principle? Options to
  weigh in the ADR: (a) CI-only tooling that lints/tests the checked-in
  HTML without changing how pages ship (no bundler in the served
  artifact), (b) accept a minimal dev-only tooling layer, (c) stay
  tooling-free and rely on agent-driven manual verification indefinitely.
  This blocks backlog items #5, #7, #8.
- **Decide the fate of the orphaned Astro pilot / ADR-0001** (backlog
  #10): the SPA-migration decision and scaffold merged into a stale
  branch, not `main`, and is now undocumented on `main`. Needs a
  deliberate call (revive, formally shelve via a superseding ADR, or at
  least re-document), not a mechanical fix.

## Future

- RSS/Atom feed (backlog #3) — depends on the tooling ADR if generated,
  or can proceed hand-maintained in parallel with the sitemap.
- Automated accessibility checks (backlog #5) — depends on tooling ADR.
- Playwright E2E smoke tests for critical journeys — depends on tooling
  ADR.
- Revisit CSS/JS duplication across pages (backlog #7) as a deliberate
  ADR-driven decision, not an ad hoc refactor.

## Ideas (unscoped, not yet backlog items)

- Consider whether the Trends Board's client-side rendering script should
  be reused (not necessarily extracted) across the Articles and Manual
  index pages for consistency, once the tooling ADR clarifies what
  "shared code without an external dependency" is allowed to look like.
- Revisit whether a lightweight, dependency-free image pipeline is needed
  if the content model ever adds screenshots/diagrams as raster images
  (currently all diagrams are inline SVG — keep it that way if possible).
