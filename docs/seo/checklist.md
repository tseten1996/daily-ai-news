# SEO Checklist

Last reviewed: 2026-07-24 (real meta tags shipped for `index.html` and
the Articles stream — see below). The table below reflects the **legacy
pages**. As of this review, `index.html`, `articles/index.html`, and all
3 published `articles/*.html` pages now carry real meta tags.
`manual/*.html` (7 files: index + 6 modules) is the **remaining slice**,
not yet done — see `docs/roadmap/roadmap.md`. **Any new article authored
through `site/`** (once deployed) gets every row marked ❌ below for free,
via `site/src/layouts/BaseLayout.astro` — see
`docs/technical-debt/backlog.md` #1 for details.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ✅ Done for `index.html` + `articles/*` (2026-07-24) · ❌ Still missing on `manual/*.html` | Article descriptions reused verbatim from each page's existing front-matter comment. |
| Canonical URLs (`rel="canonical"`) | ✅ Done for `index.html` + `articles/*` (2026-07-24) · ❌ Still missing on `manual/*.html` | Base URL used: `https://tseten1996.github.io/daily-ai-news/` — **inferred** from the repo's default GitHub Pages project-page URL (no `CNAME` file exists); confirm/update if a custom domain is ever added. |
| Sitemap (`sitemap.xml`) | ❌ Missing | Does not exist at repo root. |
| `robots.txt` | ❌ Missing | Does not exist at repo root. |
| Open Graph tags | ✅ Done for `index.html` + `articles/*` (2026-07-24) · ❌ Still missing on `manual/*.html` | No `og:image` set anywhere — the site has no images (text/SVG only, see accessibility audit); link previews will be text-only until/unless a default social image is introduced. |
| Twitter Card tags | ✅ Done for `index.html` + `articles/*` (2026-07-24) · ❌ Still missing on `manual/*.html` | Uses `summary` (not `summary_large_image`) since no image asset exists to satisfy the large-image card. |
| JSON-LD structured data (Article/BlogPosting) | ✅ Done for `index.html` + `articles/*` (2026-07-24) · ❌ Still missing on `manual/*.html` | `WebSite` on `index.html`, `CollectionPage` on `articles/index.html`, `BlogPosting` (with `datePublished` from `articles/LEDGER.md`) on each article. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## Priority for fixes

1. **Next slice**: apply the same meta-tag treatment to `manual/*.html`
   (7 files) — mechanical, same pattern as this run, see roadmap.
2. `robots.txt` + `sitemap.xml` (backlog #2) — natural follow-on once all
   legacy pages carry canonical URLs, so the sitemap has real URLs to list.
3. RSS/Atom feed (backlog #3).
4. Revisit `og:image` if the content model ever adds a default social-share
   image — not currently blocking (text-only previews still work), but
   worth a future look given the domain standards call out social sharing
   explicitly.
