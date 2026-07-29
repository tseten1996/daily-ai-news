# SEO Checklist

Last reviewed: 2026-07-29. **Caveat: as of this review, `Deploy to GitHub
Pages` has failed on 18/18 runs since it was created (see
`docs/technical-debt/backlog.md` #14) — every row below describes what's
committed to `main`, not confirmed to be reachable by a crawler.** Also
paused: item #1 (real meta tags) has three separate unmerged PRs already
proposing overlapping fixes (backlog #15) — do not open a fourth until
those are triaged.

Prior review: 2026-07-25 (sitemap staleness recurred a third time; the
verify-only CI check itself was replaced with a generated sitemap — see
maintenance note below). The table
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
(description, canonical, Open Graph, Twitter Card) are next; JSON-LD
follows once basic tags exist.
