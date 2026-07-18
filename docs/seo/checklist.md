# SEO Checklist

Last reviewed: 2026-07-18. See `docs/technical-debt/backlog.md` #1-3 for
the corresponding backlog items.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ❌ Missing | Present only inside HTML authoring-comments on some pages (not emitted as an actual tag). |
| Canonical URLs (`rel="canonical"`) | ❌ Missing | Not found on any page. |
| Sitemap (`sitemap.xml`) | ✅ Present (2026-07-18) | Hand-maintained at repo root, lists all 13 published pages. Update it whenever a page is added/removed — see maintenance note below. |
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

## Priority for fixes

See `docs/roadmap/roadmap.md` "Immediate" section — real meta tags
(description, canonical, Open Graph, Twitter Card) are next; JSON-LD
follows once basic tags exist.
