# SEO Checklist

Last reviewed: 2026-07-26 (sitemap staleness recurred a fourth time and
was root-caused — see maintenance note below). The table
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
| Sitemap (`sitemap.xml`) | ✅ Present (2026-07-18) | Generated from the published pages + their git history by `scripts/generate-sitemap.sh` as of 2026-07-25 — no longer hand-maintained. Lists all 18 published pages. `deploy-pages.yml` regenerates it fresh before every deploy, so the *live* sitemap can never be stale; `.github/workflows/check-sitemap.yml` fails CI if the committed copy drifts from the generator's output. |
| `robots.txt` | ✅ Present (2026-07-18) | At repo root: allows all crawlers, disallows `/docs/` (internal engineering knowledge base, not blog content), points to the sitemap. |
| Open Graph tags | ❌ Missing | Not found on any page. |
| Twitter Card tags | ❌ Missing | Not found on any page. |
| JSON-LD structured data (Article/BlogPosting) | ❌ Missing | Not found on any page. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## Maintenance note: `sitemap.xml` is now generated, not hand-maintained

This was hand-maintained XML through 2026-07-22, with a verify-only CI
check (`scripts/check-sitemap.sh` / `.github/workflows/check-sitemap.yml`)
added that day to catch missing entries. That still let staleness recur
a third time and missed a second drift class (stale `<lastmod>` dates)
entirely, so on 2026-07-25 the file was replaced with
`scripts/generate-sitemap.sh`, which derives every entry (URL, priority,
changefreq, `<lastmod>` from each page's own `git log`) mechanically from
the published pages on disk. `check-sitemap.sh` diffs the committed file
against the generator's output, and `deploy-pages.yml` runs the generator
itself immediately before uploading the Pages artifact — so the *live,
deployed* sitemap can never be stale regardless of what's committed.

**It still recurred a fourth time (2026-07-26):** `check-sitemap.yml` was
found failing on `main` after PR #19 added
`articles/memory-taxonomies-for-agents.html` without the committed
`sitemap.xml` being regenerated. Root cause: `SCHEDULED_TASK_PROMPT.md` —
the separate daily content-authoring agent's own operating spec — was
never updated when the generator shipped; it still instructed that agent
to hand-add a `<url>` entry itself. **Fixed 2026-07-26:** regenerated and
committed `sitemap.xml`; rewrote `SCHEDULED_TASK_PROMPT.md` step 1a to
call `./scripts/generate-sitemap.sh` instead of hand-editing. This is the
first fix that corrects the instruction source rather than only the
generated file or the CI tooling. See
`docs/technical-debt/backlog.md` item 2 for full history.

## Priority for fixes

See `docs/roadmap/roadmap.md` "Immediate" section — real meta tags
(description, canonical, Open Graph, Twitter Card) are next; JSON-LD
follows once basic tags exist.
