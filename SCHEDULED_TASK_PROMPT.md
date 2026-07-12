# Daily Run Prompt — AI Trends Learning Log + Agentic Systems Field Manual

> This is the prompt for the automated daily task. Paste it (or point the scheduled task
> at it) so each run — which has no memory of previous runs — knows exactly what to do.
> The repo itself is the state: read it first, then extend it.

## Repository layout — SINGLE-PAGE APP (since 2026-07-12)

The entire site is ONE file: `index.html` — a self-contained single-page app with one
design system (the bookmark-board look) and hash routing:

- `#` → the Trends Board (bookmark cards); `#<article-id>` → an article in the reader.
- `#manual` → the Field Manual home (dependency graph + site map + capstones), whose
  markup lives in `<div id="manual-view">` inside index.html.
- `#manual/module-NN` → a module page, rendered from
  `<section class="module" id="module-NN" data-title="...">` elements stored inside
  `<div id="manual-store">` in index.html.

Details:

- TRENDS: articles are `<article class="topic">` elements inside `<main id="articles">`
  (see the HTML comment at the top of index.html for the exact contract).
- MANUAL: `module-00` in the store is the reference implementation of the module format —
  match it. `module-01` is the second reference point; it shows how a later module
  cross-links instead of repeating a mechanism Module 00 already covered, and how a topic
  spanning multiple system layers gets code for each layer (see "Full-stack code" below).
- Every module section opens with an HTML comment **front-matter block**: `title`, `slug`,
  `pillar` (the module's category label from its site-map card in `#manual-view` —
  FOUNDATIONS / ARCHITECTURE / INTEGRATION / RUNTIME / ASSURANCE / PRODUCTION / APPLIED /
  CONSULTING — plus a short topic gloss), `difficulty` (Foundations / Practitioner /
  Principal), `series` ("The Agentic Systems Field Manual (module N of 16 + 3 capstones)"),
  `tags` (3–6, comma-separated), a one-sentence `meta description`, and estimated
  `read time`. Metadata for future runs and outside tooling — not rendered.
- Module CSS is shared and already in index.html (`.module-body …` rules — figures,
  code-tabs, judgment/failure blocks, tables, lab blocks, pager). New modules add NO CSS
  and NO `<script>`; tab switching is a delegated handler that already exists. All internal
  links are hash routes: `#manual`, `#manual/module-NN`, `#<article-id>`.
- `manual/*.html` are redirect stubs kept for old inbound links. New modules do NOT create
  files there — they go into `#manual-store` in index.html only.
- The page stays self-contained: inline CSS/JS, no external dependencies, light/dark via
  `prefers-color-scheme`.

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

1. Read `#manual-view` in index.html to find the lowest-numbered module still marked
   QUEUED, and read its site-map card (objectives, lab, prereqs) — that card is the
   module's brief.
2. Read the `module-00` and `module-01` sections in `#manual-store` in full. Together they
   are the format contract — module-00 for baseline structure, module-01 for how a later
   module should behave (cross-linking instead of repeating, full-stack code). Every module
   section must include, in this structure and visual style:
   - Front-matter HTML comment (see "Repository layout" above).
   - Doc-id header (`FM-NN`), title, one-line summary, meta row (published date, depth,
     prereqs, lab) — no topbar; the SPA supplies navigation.
   - Numbered sections (`§ N.0` orientation first). **The orientation's opening 2–4
     sentences must land on a concrete production scenario, symptom, or failure — never a
     bare definition.** ("The orchestrator's fourth subagent re-read the same 40k-token
     file its sibling just read" beats "Reasoning strategies are approaches an agent uses
     to decide what to do next.")
   - **Figures as inline SVG** in `<figure class="fig">` with mono captions
     (`FIG N.M — …`) and a `<details class="mermaid-src">` block containing the Mermaid
     source. No external libraries.
   - **Code in tabbed tracks** (`.code-tabs`): Python default (PydanticAI/LangGraph or
     raw SDK), TypeScript (Claude Agent SDK/Mastra), Java (Spring AI/LangGraph4j) when the
     pattern differs meaningfully by ecosystem.
   - **Full-stack code, not just the agent loop.** For every module past M00, identify
     which of the four layers the topic touches — (a) frontend/UX (streaming UI, approval
     surfaces, progress rendering), (b) API/transport (SSE, WebSockets, REST, auth),
     (c) agent runtime (the loop, tools, orchestration), (d) data/infra (DB, vector store,
     queues, session state) — and ship runnable code for **at least two** of them, showing
     how the same object/schema flows between layers (e.g. a typed plan crossing runtime →
     SSE endpoint → frontend component). A module whose only code is the agent loop, with
     no transport/UI/data connection, is under-scoped — go back and add a layer. M00 is the
     sole exception (it's establishing the loop itself).
   - **Every pattern gets its failure modes** (`.failure` block), each naming the symptom
     you'd see in a trace or log. Content without failure modes is marketing, not
     engineering.
   - At least two **"Principal's Judgment Call"** asides (`.judgment`), each stating the
     tradeoff as a decision rule ("reach for X when...; stay with Y when...") — not a
     restatement of the surrounding prose. Opinionated, no vendor cheerleading; where
     reasonable engineers disagree, present both positions and give a judgment.
   - **Never re-explain a mechanism an earlier module already covered in depth** — name the
     module/section and cross-link instead (module-01 §1.1 does this with M00's loop). This
     applies within the manual and against the Trends Board's past topics alike.
   - Closing blocks in order: **Lab** with acceptance criteria (`.block`) — if the module
     touches multiple layers, the lab must produce something observable via a UI or `curl`,
     not just a passing check on the agent loop alone — **Consultant's checklist**,
     **Design-review questions (staff+)** with a strong-answer sketch for each, **Go deeper**
     links (2–4 primary sources: specs, framework docs, original papers/posts — no
     listicles), and an `AS-OF <date>` volatility note flagging fast-moving claims.
   - Pager linking back to the manual home and naming the next module.
3. Research before writing: web-search the module's subject for current framework versions,
   spec revisions (MCP, A2A), and best practices. Prefer current, verifiable claims; state
   as-of dates on anything volatile. Target the depth estimate on the module's card — this
   format runs long by design (~4,500–5,500 words is normal); don't compress it to fit a
   generic blog-post length.
4. Self-check before updating `#manual-view` — reject and silently rewrite the draft if
   any of these fail: (a) the orientation's opening reads as a definition, not a
   scenario; (b) any code example would not run as written; (c) fewer than three failure
   modes; (d) a Judgment Call restates the body instead of giving a decision rule; (e) the
   module reads like it could appear on any generic AI blog; (f) the code covers only the
   agent loop with no transport/UI/data connection (see the full-stack rule above); (g) any
   section substantially re-explains material `module-00.html` or an earlier module already
   covers instead of cross-linking it.
5. Publish inside index.html (no new files):
   - Append the new `<section class="module" id="module-NN" data-title="Module NN — …">`
     at the TOP of `<div id="manual-store">`.
   - In `#manual-view`: the module's graph node class `queued` → `published`, `href` →
     `#manual/module-NN`, aria-label updated; the module's site-map card status →
     `PUBLISHED <MM-DD>` with the title wrapped in a link to `#manual/module-NN`; the next
     module's card status → `QUEUED · NEXT UP`; `#progress-pill` (`NN / 16 PUBLISHED`);
     the hero doc-id REV date.
   - Add a redirect stub at `manual/module-NN.html` pointing to
     `../index.html#manual/module-NN` (copy an existing stub), so deep links stay valid.
6. Update the previous module's pager "NEXT" link (inside its store section) from a
   disabled span to `<a href="#manual/module-NN">`.
7. Update the Trends Board banner's status line (`.mb-status`) — published count.

### Audience & voice (both jobs, especially the manual)

Senior engineers building toward principal-level, **full-stack** agentic expertise — they
want to own the entire system from the browser to the model to the database, not just the
agent loop. They know backend engineering cold (microservices, event-driven systems, CI/CD);
they want production truth about agents. Never treat the agent loop as the whole system:
per the full-stack code rule above, the UX, transport, and data layers are where agentic
products succeed or fail in production, and modules must reflect that. Do not water down
content — production depth. Every concept answers: *why does this exist, when does it fail,
and what would a principal engineer decide here?* Blueprint field-manual style: authoritative,
opinionated, engineering-first, zero hype. Where reasonable engineers disagree, present both
positions, then commit to a judgment with reasoning.

## Finish every run

1. Verify: open index.html in the headless browser (Playwright is preinstalled; chromium
   lives under `/opt/pw-browsers/`); confirm no console errors and that every route works —
   board → `#<new-article-id>`, `#manual` (graph node for the new module is solid and
   clickable), `#manual/module-NN` (renders, code tabs switch, pager links resolve) — and
   take a screenshot of the new module and the board.
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
