# Roadmap

Last reviewed: 2026-07-23 (robots.txt + sitemap.xml added). Reflects the
initial audit in `docs/technical-debt/backlog.md` plus the SPA/Astro
migration decision. Re-prioritize as runs land.

## Immediate (next 1-3 runs)

- **Wire `site/` into CI/deploy.** Decide the output path (e.g. Pages
  serves `site/dist/` at `/articles/` while the legacy root stays for
  everything else, vs. a subpath deploy) and add the build step to
  `.github/workflows/deploy-pages.yml`. Until this lands, `site/` is
  dev-only and cannot be treated as "shipped."
- **Decide the fate of the 3 already-published legacy articles**
  (`articles/*.html`): leave as-is, migrate into `site/` with redirects,
  or something else — needs its own short ADR given the duplicate-content
  SEO risk of two live versions of the same article. Blocks a clean
  cutover.
- **Add real SEO meta tags to the still-legacy pages** (backlog #1,
  slice a): `index.html` and `manual/*.html` are unaffected by the Astro
  pilot (which only covers new Articles-stream content) and still have
  zero real `<meta name="description">`/canonical/OG/Twitter tags.
  Mechanical, low-risk — do not wait on the Astro migration to fix this
  for the pages Astro doesn't cover yet.
- **Fix Trends Board heading hierarchy** (backlog #4): confirm intended
  outline, close the h2→h4 gap.
- **Keep `sitemap.xml` in sync** (backlog #2 follow-up): it's hand-
  maintained, not generated. Any run that adds a new article, module, or
  trend-board entry should add its URL to `sitemap.xml` in the same
  change, or the sitemap will silently go stale.

## Recently completed

- **`robots.txt` + `sitemap.xml`** (2026-07-23, backlog #2) — done for
  all 12 current legacy URLs. Ships automatically via the existing
  whole-repo-root Pages deploy; no CI change needed. Will need the same
  treatment for `site/` URLs once that pilot is wired into deploy.

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
