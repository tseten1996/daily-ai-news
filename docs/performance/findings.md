# Performance Findings

Last reviewed: 2026-07-17 (bootstrap run). No measurements taken yet — no
prior tooling existed to take them with, and the "no claim without a
measurement" rule means nothing is recorded here until a real run does.

## Budgets

Not yet defined. To be set once a first baseline measurement exists (e.g.
via Lighthouse/WebPageTest against the largest page, `index.html` at
~84KB uncompressed as of this review).

## Baseline observations (unmeasured, for context only)

- No build step means no minification, no bundling, no tree-shaking —
  pages ship exactly as authored. `index.html` is ~84KB; individual
  module pages run 35-62KB; all are plain text (HTML/CSS/JS), no images.
- No external requests on any page (no CDN scripts, fonts, or images) —
  this removes an entire class of performance risk (render-blocking
  third-party requests, font FOIT/FOUT) by construction.
- Client-side rendering script on `index.html` builds the bookmark board
  from DOM `<article>` elements at load time; not yet measured for cost
  as the topic count grows (16 topics today).

## Open questions for the first real performance run

- Establish LCP/CLS/INP baselines for `index.html`, an article page, and
  a module page.
- Decide whether `index.html`'s growing inline `<article>` list (one per
  trend topic, append-only, never deleted) needs pagination or lazy
  rendering once it grows large enough to matter — not a problem at 16
  topics, worth watching.
