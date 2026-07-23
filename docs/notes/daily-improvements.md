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

## 2026-07-23
- Task: Added `robots.txt` and a hand-maintained `sitemap.xml` at the repo root, covering all 12 current live legacy URLs (Trends Board, articles index + 3 published articles, manual index + 6 published modules).
- Category: SEO (priority 5) — backlog item #2.
- Why: Highest-priority safely-completable item this run. Build/lint/tests all pass (site/`npm run build` and `astro check` both clean; legacy pages have no tooling to run). No security or broken-functionality issues found on inspection. Of the open SEO items, robots.txt/sitemap was lower-risk and higher-leverage than the meta-tags slice (backlog #1): it's two brand-new files, touches zero existing content, and immediately gives crawlers a discovery path to every live page, whereas the meta-tags task would edit 8+ existing HTML files for a smaller one-run slice. Chosen over the roadmap's first two "Immediate" bullets (wiring `site/` into CI/deploy, and the legacy-article-fate ADR) because those are architecture-priority (7) decisions with real deploy-risk and open design questions, while this is SEO-priority (5), mechanical, and reversible.
- Files: `robots.txt` (new), `sitemap.xml` (new).
- Verification: `sitemap.xml` parsed as well-formed XML (`python3 -c "import xml.dom.minidom as m; m.parse(...)"`). Ran `site/`'s full build (`npm install && npm run build`) and `npx astro check` — both clean (0 errors/warnings/hints), confirming this change (which doesn't touch `site/`) didn't regress it. No legacy HTML files were modified, so no risk to the live site. `deploy-pages.yml` uploads the entire repo root already, so both new files ship on next deploy with no workflow change.
- Docs updated: `docs/seo/checklist.md`, `docs/technical-debt/backlog.md`, `docs/roadmap/roadmap.md`.
- Follow-ups: `sitemap.xml` is hand-maintained, not generated — any future run that adds a new article, module, or trend-board topic must add its URL to `sitemap.xml` in the same change or the sitemap will drift stale. Recorded in the roadmap's "Immediate" section as an ongoing checklist item. The base URL used (`https://tseten1996.github.io/daily-ai-news/`) is the default GitHub Pages project-page URL, inferred from the repo slug and the absence of a `CNAME` file — if a custom domain is ever configured, both `robots.txt` and `sitemap.xml` will need updating.
