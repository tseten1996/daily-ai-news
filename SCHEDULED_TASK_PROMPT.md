# Daily Run Prompt — AI Trends Learning Log + Agentic Systems Field Manual

> This is the prompt for the automated daily task. Paste it (or point the scheduled task
> at it) so each run — which has no memory of previous runs — knows exactly what to do.
> The repo itself is the state: read it first, then extend it.

## Repository layout

- `index.html` — the Trends Board: a bookmark-card site of daily AI trends. Self-updating
  UI; new topics are appended as `<article>` elements (see the HTML comment at the top of
  the file for the exact contract).
- `manual/index.html` — the Field Manual home: interactive module dependency graph +
  site map of all 16 modules + capstone track. Contains each module's status.
- `manual/module-NN.html` — one page per published module. `manual/module-00.html` is the
  reference implementation of the format — match it.
- All pages are self-contained (inline CSS/JS, no external dependencies, light/dark via
  `prefers-color-scheme`).

## Every daily run does two jobs

### Job 1 — Trends Board (research stream)

1. Read `index.html`; extract the list of topics already covered. Never duplicate one.
2. Web-search what's trending in AI right now across social platforms, Reddit
   (r/LocalLLaMA, r/artificial), Hacker News, and AI newsletters. Pick the 3–5 most
   notable NEW topics that are (a) genuinely new or newly popular, (b) learnable/buildable,
   (c) not already on the site.
3. For each topic, append an `<article class="topic">` at the TOP of `<main id="articles">`
   with the required data attributes (`data-title`, `data-date`, `data-tag`, `data-emoji`,
   `data-hue`, `data-blurb`) and four sections: What it is · Why it's trending ·
   Hands-on tutorial (numbered steps, code in `<pre><code>`) · Go deeper (2–4 source links).
   Only include tutorial steps you're confident are correct.

### Job 2 — Field Manual (curriculum stream)

Execute the **next queued module** in full depth — one module per run, in numeric order
(M01, M02, … M15, then the three capstones as their own pages).

1. Read `manual/index.html` to find the lowest-numbered module still marked QUEUED, and
   read its site-map card (objectives, lab, prereqs) — that card is the module's brief.
2. Read `manual/module-00.html` in full. It is the format contract. Every module page must
   include, in this structure and visual style:
   - Topbar breadcrumb, doc-id header (`FM-NN`), title, one-line summary, meta row
     (published date, depth, prereqs, lab).
   - Numbered sections (`§ N.0` orientation first).
   - **Figures as inline SVG** in `<figure class="fig">` with mono captions
     (`FIG N.M — …`) and a `<details class="mermaid-src">` block containing the Mermaid
     source. No external libraries.
   - **Code in tabbed tracks** (`.code-tabs`): Python default (PydanticAI/LangGraph or
     raw SDK), TypeScript (Claude Agent SDK/Mastra), Java (Spring AI/LangGraph4j) when the
     pattern differs meaningfully by ecosystem.
   - **Every pattern gets its failure modes** (`.failure` block). Content without failure
     modes is marketing, not engineering.
   - At least two **"Principal's Judgment Call"** asides (`.judgment`) explaining the
     tradeoff a senior architect would weigh. Opinionated, no vendor cheerleading; where
     reasonable engineers disagree, present both positions and give a judgment.
   - Closing blocks in order: **Lab** with acceptance criteria (`.block`), **Consultant's
     checklist**, **Design-review questions (staff+)** with what strong answers include,
     **Go deeper** links, and an `AS-OF <date>` volatility note flagging fast-moving claims.
   - Pager linking back to the manual home and naming the next module.
3. Research before writing: web-search the module's subject for current framework versions,
   spec revisions (MCP, A2A), and best practices. Prefer current, verifiable claims; state
   as-of dates on anything volatile. Target the depth estimate on the module's card.
4. Update `manual/index.html`:
   - The module's graph node: class `queued` → `published`, `href` → `module-NN.html`,
     aria-label updated.
   - The module's site-map card: status → `PUBLISHED <MM-DD>`, title wrapped in a link to
     the module page.
   - The next module's card status → `QUEUED · NEXT UP`.
   - The topbar progress pill (`NN / 16 PUBLISHED`).
5. Update the previous module's pager "NEXT" link to point at the newly published page.
6. Update the Trends Board banner's status line (`.mb-status`) — published count.

### Audience & voice (both jobs, especially the manual)

Senior engineers with strong backend fundamentals, new-to-intermediate in agentic AI.
Do not water down content — production depth. Every concept answers: *why does this
exist, when does it fail, and what would a principal engineer decide here?* Blueprint
field-manual style: authoritative, opinionated, engineering-first.

## Finish every run

1. Verify: open the changed pages in the headless browser (Playwright is preinstalled;
   chromium lives under `/opt/pw-browsers/`); confirm no console errors, nav works
   (board → article, graph node → module, tabs switch), and take a screenshot.
2. `git add -A && git commit` with message:
   `Daily run <YYYY-MM-DD>: trends — <topics>; manual — Module NN <title>`
3. Push to the designated branch (see the session's branch instructions; do not push to
   other branches).
4. Final summary: date, trend topics added (one line each), module published, total counts
   (topics on board, modules published), commit link, any problems hit.

## Rules

- ADD, never delete or rewrite past content (fixing a real error is allowed; note it in
  the summary).
- Keep every page self-contained: no CDNs, no external fonts/scripts/images.
- Accuracy over volume. Only ship tutorial steps and claims you're confident in; flag
  volatile claims with as-of dates.
- Keep the two streams distinct: trends = what's hot today; manual = the stable curriculum.
