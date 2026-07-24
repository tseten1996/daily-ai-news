# Daily Improvements Log

Append-only. One entry per run of the Continuous Staff Engineer &
Architecture Review Agent.

## 2026-07-17
- Task: Bootstrap the `docs/` knowledge base (this file and its siblings) — no code changes.
- Category: Documentation (bootstrap run, per operating instructions)
- Why: The `docs/` knowledge base did not exist. Per the bootstrap protocol, the entire run is scoped to creating it accurately, with no code changes, so future runs have real state to read instead of starting cold.
- Files: `docs/architecture/overview.md`, `docs/decisions/README.md`, `docs/roadmap/roadmap.md`, `docs/technical-debt/backlog.md`, `docs/notes/daily-improvements.md`, `docs/performance/findings.md`, `docs/accessibility/audit.md`, `docs/seo/checklist.md`, `docs/testing/strategy.md`
- Verification: No build/lint/test pipeline exists in this repo (confirmed by audit — no `package.json`, no CI workflows, no test runner). Nothing to run; no code was touched to verify.
- Docs updated: all of the above (all newly created)
- Follow-ups: Backlog seeded with 8 open items across SEO (real meta tags/OG/Twitter/canonical, robots.txt + sitemap.xml, RSS feed), accessibility (heading hierarchy skip, no automated a11y testing), and architecture health (no build/lint/CI/test tooling at all, CSS/JS duplication across pages — flagged as an intentional tension pending an ADR, not a bug). Roadmap's "Immediate" section proposes real SEO meta tags as the first non-bootstrap task: mechanical, low-risk, no tooling-decision blocker.

## 2026-07-17 (same-day follow-up)
- Task: Scaffolded an Astro-based target architecture for the Articles stream and recorded the decision as an ADR, at the user's explicit request to start moving toward a componentized "SPA-route" architecture using best practices.
- Category: Architecture health (this is the ADR the previous entry's backlog item 6 said tooling changes were blocked on)
- Why: User-directed, not autonomously selected — but scoped conservatively per the agent's own safety rules: isolated under `site/`, not wired into deploy, legacy pages completely untouched, verified with a real build before committing.
- Files: `docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md`, `docs/architecture/overview.md`, `docs/roadmap/roadmap.md`, `docs/technical-debt/backlog.md`, `docs/seo/checklist.md`, `docs/testing/strategy.md`, `SCHEDULED_TASK_PROMPT.md`, and a full new `site/` Astro project (package.json, astro.config.mjs, tsconfig.json, content collection schema, `BaseLayout`/`ArticleLayout`, `CodeTabs`/`Figure`/`Judgment`/`FailureBlock` components, one working example article, `site/README.md`).
- Verification: `npm install`, `npm run build`, and `npx astro check` all pass clean (0 errors/warnings/hints). Generated `dist/articles/example-post/index.html` inspected directly — confirmed correct meta description, canonical, OG, Twitter, and JSON-LD tags. Rendered in a headless browser via Playwright: zero console errors; code-tab switching confirmed working via before/after screenshot. The live legacy site (`index.html`, `articles/*.html`, `manual/*.html`, `.github/workflows/deploy-pages.yml`) was not touched.
- Docs updated: all files listed above.
- Follow-ups: 3 new backlog items opened — wire `site/` into CI/deploy; decide the fate of the 3 already-published legacy articles (duplicate-content risk); migrate the pilot's first real (non-template) article once those two are resolved. `SCHEDULED_TASK_PROMPT.md` explicitly instructs future runs to keep authoring new articles in the legacy format until deploy wiring is confirmed live, to avoid shipping content that doesn't appear anywhere.

## 2026-07-24
- Task: Added real SEO meta tags (`<meta name="description">`, `rel="canonical"`, Open Graph, Twitter Card, JSON-LD) to `index.html` (Trends Board home) and the entire Articles stream (`articles/index.html` + all 3 published `articles/*.html` pages).
- Category: SEO (backlog #1, first slice)
- Why: Health check first (build + `astro check` on `site/`, the only tooled subtree — both clean, 0 errors/warnings). No failing build/security/broken-functionality items outrank SEO today. Backlog #1 and the roadmap's "Immediate" section have flagged this as the top mechanical, low-risk task since the 2026-07-17 bootstrap; it was never picked up in the two runs since (2026-07-17 same-day Astro pilot, 2026-07-19 merge). Scoped to a single safe slice (5 files, home page + Articles stream) rather than all 12 legacy pages at once, per the "split large tasks" instruction — `manual/*.html` (7 files) is next.
- Files: `index.html`, `articles/index.html`, `articles/opentelemetry-for-agents-full-stack-tracing.html`, `articles/streaming-agent-output-to-the-browser.html`, `articles/tool-design-as-api-design.html`.
- Verification: No pre-existing build/test pipeline covers these files (legacy pages have none — see testing strategy). Verified instead with: (1) a Python script confirming every inserted JSON-LD block is valid JSON and every required tag (`meta description`, `canonical`, `og:title`, `twitter:card`) is present in all 5 files; (2) a local static server + headless Playwright pass over all 5 URLs confirming 200 status, correct description/canonical values, and zero real console errors (one `/favicon.ico` 404 observed and confirmed pre-existing/unrelated — no favicon exists anywhere in this repo, before or after this change). `git status` confirms only the 5 intended files changed.
- Docs updated: `docs/seo/checklist.md`, `docs/technical-debt/backlog.md`, `docs/roadmap/roadmap.md`, this file.
- Follow-ups: (1) Apply the same treatment to `manual/*.html` (7 files) — next roadmap "Immediate" item. (2) The canonical base URL (`https://tseten1996.github.io/daily-ai-news/`) is inferred from GitHub Pages' default project-page convention, not confirmed against live Pages settings (no tool access to read that config, no `CNAME` file in the repo) — flagged in the roadmap for confirmation/correction. (3) No `og:image` set anywhere (site has no images at all, by design) — link previews are text-only; flagged as a future idea, not a blocker.
