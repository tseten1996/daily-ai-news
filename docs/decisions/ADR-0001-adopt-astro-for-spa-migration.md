# ADR-0001: Adopt Astro as the target framework for a componentized, SEO-first site architecture

Status: Accepted
Date: 2026-07-17

## Context

The user asked to start moving the site "into the single page application route,
using the best architecture practices," and delegated the specific framework
choice.

The current architecture (documented in `docs/architecture/overview.md`) is
static, hand-authored, dependency-free HTML: every page independently
redefines its own CSS design tokens, its own `<head>`, and (per
`docs/technical-debt/backlog.md` #1) none of them actually carry real SEO
metadata — no `<meta name="description">`, canonical URLs, Open Graph tags,
Twitter Cards, or JSON-LD, despite that being a stated platform goal. The
site is also now live: `.github/workflows/deploy-pages.yml` deploys the
repo root to GitHub Pages on every push to the trunk branch.

A classic client-rendered SPA (React Router / Vue Router with no
pre-rendering) was considered and rejected: this is a content/blog site
where fast article loads and discoverability are explicit goals, and
client-only rendering would make the SEO gaps in the backlog *harder* to
close, not easier — crawlers and link-preview bots see an empty shell
before the article renders.

## Decision

Adopt **Astro** as the framework for new site architecture, targeting a
static-first, component-based site rather than a client-rendered SPA:

- Astro ships pre-rendered HTML by default (zero client JS unless a
  component opts in), which preserves and extends this site's existing
  "fast, self-contained page" characteristic instead of trading it away.
- Content collections (Astro's typed-content system) give the authoring
  workflow schema validation — a malformed front-matter field now fails
  the build loudly, instead of silently shipping a page with a missing
  `description` the way every legacy page does today.
- A shared layout means SEO metadata (canonical, OG, Twitter, JSON-LD) is
  written once and applied to every page, instead of being hand-copied
  (and in practice omitted) per file.
- Output is still static files with no required server runtime, so it
  slots into the existing GitHub Pages hosting without requiring a new
  hosting platform.

**Migration approach: incremental, forward-only, isolated.** The new
pipeline lives entirely under `site/` (an Astro project with its own
`package.json`) and does not touch or replace any existing file at the
repo root. `index.html`, `articles/*.html`, and `manual/*.html` continue
to be served exactly as they are today — nothing about the live site
changes as a result of this ADR. The **Articles stream is the pilot**:
going forward, new articles should be authored as Astro content
collection entries under `site/src/content/articles/` (see
`site/src/content/articles/example-post.mdx`, a working, buildable
template exercising every shared component). The Trends Board and Field
Manual streams are explicitly **out of scope** for this first slice —
their migration is a separate future decision, not assumed by this ADR.

**Deployment cutover is deliberately deferred.** `site/dist/` (the Astro
build output) is not wired into `.github/workflows/deploy-pages.yml` in
this change. The live site is unaffected. Wiring the build into CI/deploy,
and deciding what happens to the 3 already-published legacy article pages
(migrate with redirects? leave as-is indefinitely? retire once mirrored?)
are both open follow-ups — see `docs/roadmap/roadmap.md`.

## What was built in this slice

- `site/` — a working Astro 7 project (verified: `npm install`,
  `npm run build`, and `astro check` all pass clean — 0 errors, 0
  warnings, 0 hints).
- `site/src/layouts/BaseLayout.astro` — shared `<head>`: real meta
  description, canonical URL, Open Graph, Twitter Card, and JSON-LD
  (`BlogPosting`) support, applied uniformly to every page built through
  it.
- `site/src/layouts/ArticleLayout.astro` — article-specific chrome (nav,
  header, meta row) built on top of `BaseLayout`.
- `site/src/components/{CodeTabs,Figure,Judgment,FailureBlock}.astro` —
  componentized versions of the four recurring content patterns every
  legacy article/module page currently hand-codes inline
  (`.code-tabs`, `.fig`, `.judgment`, `.failure`).
- `site/src/content.config.ts` — a Zod schema for the `articles`
  collection mirroring the fields every legacy article already carries by
  convention in its front-matter HTML comment (title, description,
  pillar, difficulty, series, tags, publishDate, readTime).
- `site/src/pages/articles/[...slug].astro` and
  `site/src/pages/articles/index.astro` — the dynamic article route and
  listing page.
- `site/src/content/articles/example-post.mdx` — a real, working template
  article (not counted as published content) that exercises every
  component and documents the authoring workflow for future runs.
- Verification: build output inspected directly — the generated
  `dist/articles/example-post/index.html` carries a correct
  `<meta name="description">`, `rel="canonical"`, full OG/Twitter tags,
  and valid `BlogPosting` JSON-LD. Rendered in a headless browser
  (Playwright): zero console errors, code-tab switching confirmed
  working via screenshot.

## Consequences

**Easier:**
- New articles get correct SEO metadata automatically instead of by
  author discipline.
- Front-matter typos/omissions are caught at build time instead of
  shipping silently.
- Shared UI patterns (code tabs, figures, judgment calls, failure blocks)
  are defined once and reused, instead of hand-copied per file.

**Harder / new costs:**
- The repository now has a real build step and a Node/npm dependency
  tree for the `site/` subtree — a genuine reversal of the "fully
  self-contained, zero-dependency page" principle the legacy pages follow
  (see `docs/technical-debt/backlog.md` #6/#7, which first flagged this
  tension). That tradeoff is accepted here deliberately, scoped to the
  Articles pilot only.
- Two parallel authoring workflows now exist (hand-authored HTML for
  Trends Board/Manual/legacy articles; Astro/MDX for new articles) until
  a future ADR decides whether/how to extend the migration further.
- CI/deploy wiring, and the fate of the 3 already-published legacy
  articles, remain open — see roadmap.

## Migration path / follow-ups

Tracked in `docs/roadmap/roadmap.md`:
1. Decide and implement CI/deploy wiring for `site/` (build step in
   `deploy-pages.yml`, output path).
2. Decide the fate of the 3 already-published legacy `articles/*.html`
   pages (leave as-is / migrate with redirects / retire) — needs its own
   ADR given the duplicate-content SEO risk of running both versions
   live at once.
3. Evaluate, in a later run, whether the Trends Board and/or Field Manual
   should follow the same pattern — not assumed by this ADR.
