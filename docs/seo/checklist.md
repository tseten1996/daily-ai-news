# SEO Checklist

Last reviewed: 2026-07-23 (robots.txt + sitemap.xml added). The table
below reflects the **legacy pages** (`index.html`, `manual/*.html`, and
the 3 already-published `articles/*.html` files) — none of which are
covered by the Astro pilot yet. **Any new article authored through
`site/`** (once deployed) gets every row marked ❌ below for free, via
`site/src/layouts/BaseLayout.astro` — see `docs/technical-debt/backlog.md`
#1 for details. See `docs/technical-debt/backlog.md` #1, #3, #9 for the
remaining open backlog items.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ❌ Missing | Present only inside HTML authoring-comments on some pages (not emitted as an actual tag). |
| Canonical URLs (`rel="canonical"`) | ❌ Missing | Not found on any page. |
| Sitemap (`sitemap.xml`) | ✅ Present (2026-07-23) | Hand-maintained at repo root, covering all 12 live legacy URLs (Trends Board, articles index + 3 articles, manual index + 6 modules). Not yet wired to auto-update — see follow-up in the changelog. |
| `robots.txt` | ✅ Present (2026-07-23) | At repo root; allows all crawlers, points to `sitemap.xml`. |
| Open Graph tags | ❌ Missing | Not found on any page. |
| Twitter Card tags | ❌ Missing | Not found on any page. |
| JSON-LD structured data (Article/BlogPosting) | ❌ Missing | Not found on any page. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## Priority for fixes

See `docs/roadmap/roadmap.md` "Immediate" section — real meta tags
(description/canonical/OG/Twitter) on the legacy pages are next, since
robots.txt/sitemap are now done; JSON-LD follows once basic tags exist.
