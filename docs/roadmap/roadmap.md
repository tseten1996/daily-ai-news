# Roadmap

Last reviewed: 2026-07-22. Fixed a recurring missing-sitemap-entry
regression (a new article shipped without one for the second time despite
a documentation-only reminder) and added `.github/workflows/check-sitemap.yml`
as a verify-only CI check so this class of gap no longer depends on a
human or agent remembering to check by hand (backlog #2, #10). The
Immediate items below are otherwise unchanged from the 2026-07-21 review.

## Immediate (next 1-3 runs)

- **Add real SEO meta tags per page** (backlog #1, slice a): unique
  `<meta name="description">`, `rel="canonical"`, Open Graph, and Twitter
  Card tags on `index.html`, `articles/*.html`, and `manual/*.html` (now
  15 pages total — likely needs its own slicing across 2+ runs to stay
  under the ~10-file-per-run guideline). Mechanical, low-risk,
  high-value — the top open SEO item since `robots.txt`/`sitemap.xml`
  landed 2026-07-18. Unaffected by the Astro pilot, which only covers
  new Articles-stream content going forward.
- **Fix Trends Board heading hierarchy** (backlog #4): confirm intended
  outline, close the h2→h4 gap.
- **Wire `site/` into CI/deploy, or decide not to.** Now that the pilot's
  history is reconciled into `main`, it needs an owner decision: either
  add a real build step to `.github/workflows/deploy-pages.yml` (deciding
  the output path — e.g. Pages serves `site/dist/` at `/articles/` while
  the legacy root stays for everything else, vs. a subpath deploy), or
  formally shelve it. Until one of those happens, `site/` remains
  dev-only and cannot be treated as "shipped."
- **Decide the fate of the 7 already-published legacy articles**
  (`articles/*.html`): leave as-is, migrate into `site/` with redirects,
  or something else — needs its own short ADR given the duplicate-content
  SEO risk of two live versions of the same article. Blocks a clean
  cutover.

## Next

- **JSON-LD Article/BlogPosting structured data** (backlog #1, slice b)
  for article and module pages, once basic meta tags exist.
- **Decide on tooling strategy for the legacy pages via ADR** (backlog
  #6): `site/` answers this question for new Articles-stream content, but
  the Trends Board and Manual streams remain fully tooling-free, and
  there's no lint/a11y/link-checking without introducing a build step
  that conflicts with the "fully self-contained page" design principle.
  Options to weigh: (a) CI-only tooling that lints/tests the checked-in
  HTML without changing how pages ship, (b) a minimal dev-only tooling
  layer, (c) stay tooling-free and rely on agent-driven manual
  verification indefinitely. Blocks backlog items #5, #7, #8.
- Migrate the Astro pilot's first *real* (non-template) article, once the
  CI-wiring and legacy-article-fate decisions above are both resolved —
  proves the pipeline end-to-end with production content, not just the
  example template.
- Automated accessibility checks (backlog #5) — straightforward to add to
  `site/`'s build once CI exists for it; still blocked for the legacy
  pages on the tooling ADR above.

## Future

- RSS/Atom feed (backlog #3).
- Evaluate whether the Trends Board and/or Field Manual should migrate to
  the same Astro pattern — a separate decision, not assumed by ADR-0001.
- Revisit CSS/JS duplication across the *legacy* pages (backlog #7) — the
  Astro pilot already resolves this for anything built through it via
  shared layouts/components.

## Ideas (unscoped, not yet backlog items)

- Revisit whether a lightweight, dependency-free image pipeline is needed
  if the content model ever adds screenshots/diagrams as raster images
  (currently all diagrams are inline SVG — keep it that way if possible;
  `site/`'s `Figure` component only supports inline SVG today, by
  design).
