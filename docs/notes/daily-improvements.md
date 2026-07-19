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

## 2026-07-18
- Task: Added `robots.txt` and a hand-maintained `sitemap.xml` at the repo root.
- Category: SEO (priority 5)
- Why: The site started at zero SEO tooling with no build pipeline; between the last run and this one the repo gained a real `GitHub Pages` deploy workflow (`.github/workflows/deploy-pages.yml`, merged via PR #5/#6), so the site is now actually live and crawlable — making the total absence of a sitemap/robots policy (backlog #2) a live gap rather than a theoretical one. It's small (2 new files), mechanical, fully completable in one run, and unblocks nothing risky. Chose it over the larger per-page meta-tag task (backlog #1, ~13 files across index/articles/manual) which is better sliced across 2+ runs to stay within the file-count guideline; that stays queued as the new top "Immediate" item.
- Files: `robots.txt` (new), `sitemap.xml` (new)
- Verification: No build/lint/test pipeline exists in this repo (confirmed unchanged from bootstrap audit — still no `package.json`, and the one CI workflow only deploys, it doesn't test). Manually verified `sitemap.xml` is well-formed XML (`python3 -c "import xml.dom.minidom as m; m.parse('sitemap.xml')"` — passed) and cross-checked it lists exactly the 13 currently-published HTML pages (confirmed via `find . -name "*.html"` and cross-referencing `manual/index.html`'s published/queued module markers, so unpublished modules 06-15 are correctly excluded). `robots.txt` syntax matches the standard format and its `Sitemap:` line points at the correct absolute URL for this repo's default GitHub Pages URL (no `CNAME` file present, so `https://tseten1996.github.io/daily-ai-news/`).
- Docs updated: `docs/seo/checklist.md` (marked sitemap/robots done, added a maintenance note that future runs must add a `<url>` entry when publishing new pages), `docs/technical-debt/backlog.md` (#2 marked DONE; #6 updated to reflect the new deploy-only CI workflow and note that verify-only CI wouldn't violate the no-build-step principle — sharpens the pending tooling ADR), `docs/roadmap/roadmap.md` (removed the now-done item, reprioritized real meta tags as the sole "Immediate" item with a slicing note), `docs/architecture/overview.md` (corrected stale "no deploy workflow found" / "2 articles published" statements — the repo moved since the 2026-07-17 bootstrap review).
- Follow-ups: (1) Real per-page SEO meta tags (description/canonical/OG/Twitter) — now the top Immediate roadmap item, likely needs 2 runs to cover all 13 pages within the file-count guideline. (2) Sitemap is hand-maintained — every future run that adds/removes a page must update it, flagged in both the SEO checklist and backlog. (3) No new backlog items created beyond what already existed.
