# SEO Checklist

Last reviewed: 2026-07-22 (fixed a recurring missing-sitemap-entry
regression and added a CI check to catch it going forward). The table
below reflects the **legacy pages** (`index.html`, `manual/*.html`, and
all 8 already-published `articles/*.html` files) — none of which are
covered by the Astro pilot yet. **Any new article authored through `site/`** (once
deployed) gets every row marked ❌ below for free, via
`site/src/layouts/BaseLayout.astro` — see `docs/technical-debt/backlog.md`
#1 for details. See `docs/technical-debt/backlog.md` #1-3, #9 for the
corresponding backlog items.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ❌ Missing | Present only inside HTML authoring-comments on some pages (not emitted as an actual tag). |
| Canonical URLs (`rel="canonical"`) | ❌ Missing | Not found on any page. |
| Sitemap (`sitemap.xml`) | ✅ Present (2026-07-18) | Hand-maintained at repo root, lists all 17 published pages (verified 2026-07-22). Update it whenever a page is added/removed — see maintenance note below. As of 2026-07-22, `.github/workflows/check-sitemap.yml` fails CI if any published page is missing an entry. |
| `robots.txt` | ✅ Present (2026-07-18) | At repo root: allows all crawlers, disallows `/docs/` (internal engineering knowledge base, not blog content), points to the sitemap. |
| Open Graph tags | ❌ Missing | Not found on any page. |
| Twitter Card tags | ❌ Missing | Not found on any page. |
| JSON-LD structured data (Article/BlogPosting) | ❌ Missing | Not found on any page. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## Maintenance note: keeping `sitemap.xml` fresh

`sitemap.xml` is hand-maintained (no build step generates it — consistent
with this repo's dependency-free design). Whenever a future run publishes
a new article, module, or index page, it must add a matching `<url>`
entry (with an accurate `<lastmod>`) to `sitemap.xml`, the same way
`articles/LEDGER.md` is updated on every new article. This checklist and
`docs/technical-debt/backlog.md` should flag it as stale if a run adds
content without updating the sitemap.

**This happened twice:** the 2026-07-19 daily content run published
`articles/no-framework-200-line-harness.html` without a matching
`sitemap.xml` entry (caught and fixed same-day; a reminder step was then
added to `SCHEDULED_TASK_PROMPT.md`'s "finish every run" checklist). It
recurred on 2026-07-22 — `articles/tool-descriptions-are-prompts.html`
shipped without a sitemap entry despite that reminder already being in
place, proving a prose reminder alone doesn't reliably prevent this.

**Durable fix (2026-07-22):** `scripts/check-sitemap.sh`, run by
`.github/workflows/check-sitemap.yml` on every push and pull request,
fails the "Check sitemap freshness" status check if any published legacy
HTML page (repo root, `articles/`, `manual/`) has no matching
`sitemap.xml` `<loc>` entry. This is a verify-only check — it doesn't
change what ships and doesn't gate `deploy-pages.yml` — so a future
content-authoring run that forgets the sitemap update will get a failing
CI check instead of a silently-undiscoverable page. See
`docs/technical-debt/backlog.md` items 2 and 10.

## Priority for fixes

See `docs/roadmap/roadmap.md` "Immediate" section — real meta tags
(description, canonical, Open Graph, Twitter Card) are next; JSON-LD
follows once basic tags exist.
