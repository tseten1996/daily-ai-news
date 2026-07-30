# Roadmap

Last reviewed: 2026-07-27. Added real SEO meta tags (description,
canonical, OG, Twitter, JSON-LD) to `index.html` and all 7
`manual/*.html` files (backlog #1). Discovered in the process: PR #17
(SEO tags for `index.html` + old Articles pages) merged into the wrong
base branch, not `main` — a second occurrence of the exact bug backlog
#13 already fixed once for the Astro pilot. New backlog item #14 tracks
the pattern; a human decision is needed on PR #11 vs. the stranded PR #17
before `articles/*.html`'s meta tags (the remaining slice of #1) can be
added without a third collision.

## Immediate (next 1-3 runs)

- **Resolve PR #11 vs. the stranded PR #17 for `articles/*.html`**
  (backlog #1 remaining slice, #14): both propose SEO meta tags for
  overlapping-but-different subsets of the 14 published article pages,
  and neither reflects the current file set. Needs a human (or a future
  run explicitly scoped to this) to close/rebase one and write a single
  fresh pass over all 14 files — not a merge of either as-is.
- **Investigate root cause of backlog #14** (PRs landing on
  `claude/daily-ai-trends-tutorial-txft7z` instead of `main`): grep the
  repo and any PR-authoring tooling/templates for hardcoded references to
  that branch name. Recurred twice now across unrelated task types.
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
