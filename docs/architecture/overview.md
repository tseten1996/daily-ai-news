# Architecture Overview

Last reviewed: 2026-07-20

## What this repository is

A personal AI-news blogging platform published as static, hand-authored HTML.
There is no application framework, no build step, and no server-side code —
every page is a self-contained `.html` file that a browser renders directly.
Content is added by an automated daily agent run (see
`SCHEDULED_TASK_PROMPT.md` at the repo root, which is the operating spec for
that run — distinct from the architecture-review agent that owns this `docs/`
tree).

## Stack

- **Language:** HTML5 + inline CSS + inline vanilla JS. No TypeScript, no
  JSX, no templating language.
- **Dependencies:** none. Every page is fully self-contained — no CDNs, no
  external fonts, no npm packages, no `package.json`. Light/dark theming
  uses `prefers-color-scheme` media queries only.
- **Build pipeline:** none. There is no bundler, no transpiler, no minifier.
  The files in the repo are exactly what a browser receives.
- **Hosting:** GitHub Pages, deployed by
  `.github/workflows/deploy-pages.yml` on every push to `main` (uploads
  the repo root verbatim — no build step in the pipeline either).
- **Tests:** none exist. No test runner, no Playwright config, and the
  one CI workflow that exists only deploys — it runs no lint, no test,
  and no validation of any kind.

## Repository layout

```
index.html              Trends Board — home page, bookmark-card UI of daily AI trend topics
robots.txt              Crawler policy; points at sitemap.xml (added 2026-07-18)
sitemap.xml             Hand-maintained sitemap of all published pages (added 2026-07-18)
articles/                Long-form article stream ("The Daily AI News")
  index.html             Article listing page
  LEDGER.md              Append-only dedup ledger of published articles (topic/date/concepts)
  <slug>.html            One file per published article, self-contained
manual/                  "The Agentic Systems Field Manual" — a 16-module curriculum
  index.html             Manual home: dependency graph (SVG) + site-map cards + module statuses
  module-NN.html         One file per published module (00-05 published so far)
SCHEDULED_TASK_PROMPT.md Operating spec for the daily content-generation agent run
.github/workflows/       deploy-pages.yml — deploys repo root to GitHub Pages on push to main
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

### 3. Articles (`articles/`)
- A newer, third content stream ("pillar"-organized full-stack agentic
  engineering articles), tracked via `articles/LEDGER.md` for dedup by
  topic/concept rather than exact title match.
- As of this review: 6 articles published. All 7 `articles/*.html` files
  (the 6 articles plus `articles/index.html`) carry real SEO meta tags
  (description, canonical, Open Graph, Twitter Card) as of 2026-07-20 —
  see `docs/seo/checklist.md`.

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

No build step: there is no `package.json`, no lockfile, no linter config,
and no test runner anywhere in the repository. A single CI workflow
(`.github/workflows/deploy-pages.yml`) deploys the repo root to GitHub
Pages verbatim on every push to `main` — it performs no build, lint, or
test step of any kind before deploying. "Verification" for the daily
content-authoring run is manual/agent-driven (opening pages in a headless
browser via Playwright per `SCHEDULED_TASK_PROMPT.md`'s "Finish every run"
section), not an automated gate. This is a significant gap from a
stewardship standpoint — see `docs/technical-debt/backlog.md` #6.

## Notable conventions worth preserving

- **Append-only content:** past articles/topics/modules are never deleted
  or rewritten wholesale (only real-error fixes, noted in commit
  summaries).
- **Self-containment:** no external network dependency for any page to
  render correctly, including offline.
- **Ledger-based dedup:** `articles/LEDGER.md` and the Trends Board's own
  DOM are the source of truth for "has this been covered before" checks by
  future automated runs — do not remove or reformat past entries.
