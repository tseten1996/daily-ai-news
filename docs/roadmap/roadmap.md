# Roadmap

Last reviewed: 2026-07-29. Two critical findings this run, both blocking
and neither fixable by this agent — see backlog items 14 and 15. They now
lead "Immediate" ahead of everything else, including the previously-top
SEO item, which should stay paused until item 15 is resolved (three
separate unmerged PRs already propose overlapping slices of it).

## Immediate (next 1-3 runs)

- **[BLOCKED on repo owner] Fix `Deploy to GitHub Pages`** (backlog #14):
  18/18 runs of this workflow have failed on `main` since it was created
  12 days ago — the site has likely never successfully deployed. Root
  cause is almost certainly GitHub repo Settings → Pages not having
  "GitHub Actions" selected as the source (or Pages being unavailable for
  this repo). No agent-accessible tool can read or fix repo Settings; a
  human needs to check Settings → Pages and re-run the workflow. This
  outranks every other item below until confirmed fixed.
- **[BLOCKED on repo owner] Triage the 5 open, unmerged PRs** (backlog
  #15): #11, #16, #20, #22, #23 — several duplicate each other. Nothing
  merges automatically in this repo's workflow; a human needs to
  review/merge/close them, oldest first, before any future run picks up
  another slice of the same backlog items and adds PR #6 to the pile.
- **Add real SEO meta tags per page** (backlog #1, slice a) — **paused**
  until item 15 clears. `index.html` and `manual/*.html` already have two
  separate unmerged attempts in flight (PR #22, PR #23); `articles/*.html`
  has one (PR #11). Re-attempting this before those are triaged just adds
  a fourth overlapping diff. Once triaged: unique
  `<meta name="description">`, `rel="canonical"`, Open Graph, and Twitter
  Card tags are still needed across all ~16 pages.
- **Fix Trends Board heading hierarchy** (backlog #4): confirm intended
  outline, close the h2→h4 gap. Not blocked by the above — safe to pick up
  next if items 14/15 aren't yet resolved when a future run lands.
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
