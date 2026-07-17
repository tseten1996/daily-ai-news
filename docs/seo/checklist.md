# SEO Checklist

Last reviewed: 2026-07-17 (bootstrap run). State as found — nothing fixed
yet (bootstrap runs make no code changes). See
`docs/technical-debt/backlog.md` #1-3 for the corresponding backlog items.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ❌ Missing | Present only inside HTML authoring-comments on some pages (not emitted as an actual tag). |
| Canonical URLs (`rel="canonical"`) | ❌ Missing | Not found on any page. |
| Sitemap (`sitemap.xml`) | ❌ Missing | Does not exist at repo root. |
| `robots.txt` | ❌ Missing | Does not exist at repo root. |
| Open Graph tags | ❌ Missing | Not found on any page. |
| Twitter Card tags | ❌ Missing | Not found on any page. |
| JSON-LD structured data (Article/BlogPosting) | ❌ Missing | Not found on any page. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## Priority for fixes

See `docs/roadmap/roadmap.md` "Immediate" section — real meta tags +
robots.txt/sitemap are the first candidates; JSON-LD follows once basic
tags exist.
