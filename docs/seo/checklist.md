# SEO Checklist

Last reviewed: 2026-07-28 (added real meta description/canonical/OG/
Twitter tags to `index.html` and all 7 `manual/*.html` pages — see
maintenance note below). The table
below reflects the **legacy pages** (`index.html`, `manual/*.html`, and
all 15 already-published `articles/*.html` files) — none of which are
covered by the Astro pilot yet. **Any new article authored through `site/`** (once
deployed) gets every row marked ❌ below for free, via
`site/src/layouts/BaseLayout.astro` — see `docs/technical-debt/backlog.md`
#1 for details. See `docs/technical-debt/backlog.md` #1-3, #9 for the
corresponding backlog items.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ⚠️ Partial (Trends Board + Manual done 2026-07-28) | Present and emitted on `index.html` and all 7 `manual/*.html` pages (reusing each page's existing lede/front-matter description verbatim). Still ❌ missing on all 15 `articles/*.html` pages — PR #11 (open since 2026-07-20) proposes this for articles but hasn't merged and is now stale against the current article count. |
| Canonical URLs (`rel="canonical"`) | ⚠️ Partial (Trends Board + Manual done 2026-07-28) | Present on `index.html` and all 7 `manual/*.html` pages, matching the URL convention already used in `sitemap.xml`. Still ❌ missing on `articles/*.html`. |
| Sitemap (`sitemap.xml`) | ✅ Present (2026-07-18) | Generated from the published pages + their git history by `scripts/generate-sitemap.sh` as of 2026-07-25 — no longer hand-maintained. Lists all 23 published pages. `deploy-pages.yml` regenerates it fresh before every deploy, so the *live* sitemap can never be stale; `.github/workflows/check-sitemap.yml` fails CI if the committed copy drifts from the generator's output. |
| `robots.txt` | ✅ Present (2026-07-18) | At repo root: allows all crawlers, disallows `/docs/` (internal engineering knowledge base, not blog content), points to the sitemap. |
| Open Graph tags | ⚠️ Partial (Trends Board + Manual done 2026-07-28) | `og:type`/`og:title`/`og:description`/`og:url`/`og:site_name` present on `index.html` and all 7 `manual/*.html` pages. No `og:image` — the site has no images anywhere (text/SVG only), so it's correctly omitted rather than pointing at a missing asset. Still ❌ missing on `articles/*.html`. |
| Twitter Card tags | ⚠️ Partial (Trends Board + Manual done 2026-07-28) | `twitter:card` (`summary` — no image available, so not `summary_large_image`), `twitter:title`, `twitter:description` present on `index.html` and all 7 `manual/*.html` pages. Still ❌ missing on `articles/*.html`. |
| JSON-LD structured data (Article/BlogPosting) | ❌ Missing | Not found on any page. Deliberately out of scope for this slice (backlog #1 slice b) — do it once basic tags exist everywhere. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## Maintenance note: `sitemap.xml` is now generated, not hand-maintained

This was hand-maintained XML through 2026-07-22, with a verify-only CI
check (`scripts/check-sitemap.sh` / `.github/workflows/check-sitemap.yml`)
added that day to catch missing entries. **It went stale a third time
anyway** — the 2026-07-25 run found the newest article
(`articles/mcp-anatomy-hosts-clients-servers-primitives.html`) missing
from the sitemap, and separately found an already-present entry
(`context-compaction-for-long-running-agents.html`) carrying a wrong
`<lastmod>` (one day off from its actual last commit) — the CI check only
ever caught missing entries, not stale dates, so that second class of
drift had gone completely undetected.

Two prior fixes both relied on the sitemap staying hand-accurate: a
prose reminder in `SCHEDULED_TASK_PROMPT.md` (recurred once), then a
verify-only CI check (recurred again for a different reason). Both
assumed a human or agent would remember to update the file correctly;
neither removed the opportunity to forget. **2026-07-25 fix:**
`scripts/generate-sitemap.sh` derives the entire file mechanically —
every published legacy HTML page (repo root, `articles/`, `manual/`) plus
its own `git log` last-commit date, with priority/changefreq assigned by
path convention. `sitemap.xml` in the repo is now this script's
committed output, `.github/workflows/check-sitemap.yml` fails CI if the
committed file and the generator's output ever diverge, and
`deploy-pages.yml` runs the generator itself immediately before
uploading the Pages artifact — so even if a future content-authoring run
forgets to regenerate the committed file, the *live, deployed* sitemap is
always correct. This closes the gap structurally rather than relying on
a fourth reminder: nothing publishable can reach the live site with a
stale sitemap, and the check step never blocks a deploy (it only
regenerates, it cannot fail). See `docs/technical-debt/backlog.md` item 2.

## Priority for fixes

See `docs/roadmap/roadmap.md` "Immediate" section — real meta tags
(description, canonical, Open Graph, Twitter Card) are done for the
Trends Board and Field Manual; `articles/*.html` (15 files) is the
remaining slice, pending PR #11 or a fresh implementation against the
current article count. JSON-LD follows once basic tags exist everywhere.
