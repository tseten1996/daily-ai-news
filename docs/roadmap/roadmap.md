# Roadmap

Last reviewed: 2026-07-24 (real SEO meta tags shipped for `index.html` +
Articles stream). Reflects the initial audit in
`docs/technical-debt/backlog.md` plus the SPA/Astro migration decision.
Re-prioritize as runs land.

## Immediate (next 1-3 runs)

- **Add real SEO meta tags to `manual/*.html`** (backlog #1, remaining
  slice): `index.html` and the Articles stream got real
  `<meta name="description">`/canonical/OG/Twitter/JSON-LD tags on
  2026-07-24 (same mechanical pattern, low-risk — see backlog #1 and
  `docs/notes/daily-improvements.md`). The 7 `manual/*.html` files
  (index + 6 published modules) are the one remaining legacy surface
  without real meta tags; each module already carries the same
  front-matter-comment convention the articles used, so the same
  extraction approach applies directly.
- **Wire `site/` into CI/deploy.** Decide the output path (e.g. Pages
  serves `site/dist/` at `/articles/` while the legacy root stays for
  everything else, vs. a subpath deploy) and add the build step to
  `.github/workflows/deploy-pages.yml`. Until this lands, `site/` is
  dev-only and cannot be treated as "shipped."
- **Decide the fate of the 3 already-published legacy articles**
  (`articles/*.html`): leave as-is, migrate into `site/` with redirects,
  or something else — needs its own short ADR given the duplicate-content
  SEO risk of two live versions of the same article. Blocks a clean
  cutover. (Note: these pages now carry real canonical URLs of their own
  as of 2026-07-24, which makes the duplicate-content risk of a future
  parallel `site/` version more concrete, not less — factor this into
  that ADR.)
- **Add `robots.txt` and a hand-maintained `sitemap.xml`** (backlog #2),
  covering both the legacy pages and whatever `site/` pages go live once
  deployed. Now that `index.html` and the Articles stream have real
  canonical URLs, a sitemap has real entries to list for those pages
  already; `manual/*.html` should get canonical URLs first (see above) so
  the sitemap can cover the whole legacy site in one pass.
- **Fix Trends Board heading hierarchy** (backlog #4): confirm intended
  outline, close the h2→h4 gap.
- **Confirm the live GitHub Pages base URL.** The canonical URLs added
  2026-07-24 use `https://tseten1996.github.io/daily-ai-news/`, inferred
  from the repo's default GitHub Pages project-page convention (no
  `CNAME` file exists, and this agent has no tool access to read the
  repository's live Pages configuration). If the actual served URL
  differs (custom domain, different path), correct all canonical/OG/
  JSON-LD `url` values in `index.html` and `articles/*.html` — a quick
  find-and-replace across the 5 files.

## Next

- Migrate the Astro pilot's first *real* (non-template) article, once CI
  wiring and the legacy-article-fate ADR above are both resolved — proves
  the pipeline end-to-end with production content, not just the example
  template.
- **Decide on tooling strategy for the legacy pages via ADR** (backlog
  #6): `site/` answers this question for new Articles-stream content, but
  the Trends Board and Manual streams remain fully tooling-free. Decide
  deliberately whether they should eventually adopt the same pipeline,
  stay hand-authored indefinitely, or land on a third option.
- Automated accessibility checks (backlog #5) — straightforward to add to
  `site/`'s build (e.g. via a Playwright + axe check) once CI exists for
  it; still blocked for the legacy pages on the tooling ADR above.

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
