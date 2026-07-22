# Architecture Overview

Last reviewed: 2026-07-22 (fixed a recurring missing-sitemap-entry regression and added a verify-only CI check — see backlog #2, #10)

## What this repository is

A personal AI-news blogging platform, in transition from static,
hand-authored HTML to a componentized, build-based architecture (Astro).
Content is added by an automated daily agent run (see
`SCHEDULED_TASK_PROMPT.md` at the repo root, which is the operating spec for
that run — distinct from the architecture-review agent that owns this `docs/`
tree).

**Current vs. target state:** `index.html`, `articles/*.html`, and
`manual/*.html` at the repo root are the **legacy architecture** — still
live, still how the site is served today, unchanged by the migration below.
`site/` is the **target architecture** — a real Astro project, not yet
wired into deployment, currently piloted only for new Articles-stream
content. See `docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md`
for the full rationale and migration plan, and
`docs/roadmap/roadmap.md` for what's still open (CI/deploy wiring, the
fate of the 3 already-published legacy articles, whether the Trends Board
and Manual follow the same pattern).

## Stack

**Legacy (repo root — live today):**
- HTML5 + inline CSS + inline vanilla JS. No TypeScript, no JSX, no
  templating language.
- Dependencies: none. Every page is fully self-contained — no CDNs, no
  external fonts, no npm packages. Light/dark theming uses
  `prefers-color-scheme` media queries only.
- Build pipeline: none. The files in the repo are exactly what a browser
  receives.
- Tests: none. No test runner, no Playwright config committed (Playwright
  is used ad hoc by the daily agent run for manual verification, per
  `SCHEDULED_TASK_PROMPT.md`).

**Target (`site/` — pilot, not yet deployed, not yet on `main`):**
- [Astro](https://astro.build) (static output, component islands),
  TypeScript (`astro check` strict mode), MDX for content authoring, Zod
  via Astro Content Collections for front-matter schema validation. See
  `docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md`.
- Has its own `package.json`/`node_modules` (gitignored) — the first
  Node/npm dependency tree in this repository.
- **Status as of this review:** this pilot was built and committed on a
  branch that got merged into a stale non-default branch instead of
  `main` (see backlog #10). It is being reconciled into `main`'s history
  as part of this run; it still is not wired into deploy or CI.

**Hosting:** GitHub Pages, via `.github/workflows/deploy-pages.yml`
(deploys the entire repo root on push to `main`). This workflow uploads
raw files with no build step; it does not build or publish anything from
`site/` — see the roadmap for that follow-up.

## Repository layout

```
index.html              [legacy, live] Trends Board — home page, bookmark-card UI of daily AI trend topics
robots.txt              Crawler policy; points at sitemap.xml (added 2026-07-18)
sitemap.xml             Hand-maintained sitemap of all published pages (added 2026-07-18)
articles/                [legacy, live] Long-form article stream ("The Daily AI News")
  index.html             Article listing page
  LEDGER.md              Append-only dedup ledger of published articles (topic/date/concepts)
  <slug>.html            One file per published article, self-contained
manual/                  [legacy, live] "The Agentic Systems Field Manual" — a 16-module curriculum
  index.html             Manual home: dependency graph (SVG) + site-map cards + module statuses
  module-NN.html         One file per published module (00-05 published so far)
site/                    [target, pilot — not deployed, not yet on main] Astro project; see ADR-0001
  src/content/articles/  New articles authored as MDX + typed front matter here going forward
  src/layouts/           BaseLayout (SEO: meta/OG/Twitter/JSON-LD) + ArticleLayout
  src/components/        Shared CodeTabs, Figure, Judgment, FailureBlock components
SCHEDULED_TASK_PROMPT.md Operating spec for the daily content-generation agent run
scripts/                 check-sitemap.sh — verify-only sitemap-completeness check, run in CI
.github/workflows/       deploy-pages.yml (deploys repo root to GitHub Pages on push to main);
                         check-sitemap.yml (fails CI if a published page is missing from sitemap.xml)
docs/                    This knowledge base (architecture-review agent's memory)
```

## Content model

### 1. Trends Board (`index.html`)
- All content lives as `<article class="topic">` elements inside
  `<main id="articles">`.
- New topics are **prepended** (never deleted) with required data
  attributes: `data-title`, `data-date`, `data-tag`, `data-emoji`,
  `data-hue`, `data-blurb`.
- An inline `<script>` at the bottom of the file reads these `<article>`
  elements at load time and renders the bookmark-card board, date
  groupings, tag filters, and counts client-side. There is no separate
  table-of-contents to maintain — the DOM *is* the data source.
- As of this review: 16 topic articles on the board.

### 2. Field Manual (`manual/`)
- A 16-module curriculum ("The Agentic Systems Field Manual") plus 3
  capstones, published one module per daily run, in numeric order.
- `manual/index.html` renders a dependency graph (inline SVG) and a
  site-map of cards; each card and graph node tracks a module's status
  (`queued` → `published`) and links to `module-NN.html` once published.
- `module-00.html` is the format's reference implementation; every module
  opens with an HTML front-matter comment (title, slug, pillar,
  difficulty, series, tags, meta description, read time) that is metadata
  only — not rendered on the page.
- As of this review: modules 00–05 published (6/16), module 06 queued
  next.

### 3. Articles — legacy (`articles/`) and pilot (`site/`)
- A "pillar"-organized full-stack agentic engineering article stream,
  tracked via `articles/LEDGER.md` for dedup by topic/concept rather than
  exact title match. As of this review: 8 articles published, all as
  legacy hand-authored HTML.
- **The Astro pilot (`site/`, ADR-0001) exists but new articles are still
  being authored in the legacy format** — the pilot was never wired into
  CI/deploy and its branch history only just got reconciled into `main`
  (see backlog #10), so `SCHEDULED_TASK_PROMPT.md` continues to instruct
  the daily run to use the legacy format until that's resolved. None of
  the 7 published legacy articles have been migrated to `site/`; whether
  to do that is still an open roadmap item.

## Data flow

There is no runtime data flow in the traditional sense — no client-server
API calls, no database, no CMS. "Data flow" here means the daily authoring
loop:

1. The scheduled agent run reads existing content (topic list, ledger,
   module statuses) directly out of the checked-in HTML/Markdown files —
   the repository itself is the state store.
2. It researches new trend topics / writes the next queued module / drafts
   the next article.
3. It appends new HTML directly into the relevant file(s) and updates
   status trackers (`manual/index.html` graph + cards, `LEDGER.md`).
4. It commits and pushes to its designated branch.

At page-view time, each HTML file is fully self-rendering: inline CSS for
styling/theming, inline JS only where needed (the Trends Board's
card-rendering script; module pages' tab-switching JS).

## Build & deploy pipeline

**Legacy site:** deployed via `.github/workflows/deploy-pages.yml`, which
uploads the entire repo root to GitHub Pages on push to `main` — no build
step, no lint/type-check. As of 2026-07-22, a second, independent workflow
(`.github/workflows/check-sitemap.yml`) runs `scripts/check-sitemap.sh` on
every push/PR and fails the check if a published page is missing from
`sitemap.xml` — a verify-only gate that doesn't affect what
`deploy-pages.yml` ships. Beyond that one structural check, "verification"
for the daily content-authoring run is still manual/agent-driven (opening
pages in a headless browser via Playwright per
`SCHEDULED_TASK_PROMPT.md`'s "Finish every run" section), not an automated
gate. Broader legacy-page CI (lint, HTML validation, a11y) remains a real
gap — see `docs/technical-debt/backlog.md` #6.

**`site/` (Astro pilot):** has a real build step (`npm run build`) and a
type-checker (`astro check`), both verified clean when built, but **not
wired into CI** — a push to `main` today does not build or deploy
anything from `site/`. Wiring that up is an explicit, deliberately
deferred follow-up (see roadmap) so that introducing the new pipeline
could not, even accidentally, break the live site.

## Notable conventions worth preserving

- **Append-only content:** past articles/topics/modules are never deleted
  or rewritten wholesale (only real-error fixes, noted in commit
  summaries).
- **Self-containment:** no external network dependency for any page to
  render correctly, including offline.
- **Ledger-based dedup:** `articles/LEDGER.md` and the Trends Board's own
  DOM are the source of truth for "has this been covered before" checks by
  future automated runs — do not remove or reformat past entries.
