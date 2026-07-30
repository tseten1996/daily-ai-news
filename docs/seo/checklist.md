# SEO Checklist

Last reviewed: 2026-07-27 (added real meta tags to `index.html` and all 7
`manual/*.html` files — see maintenance note below). The table below
reflects the **legacy pages** (`index.html`, `manual/*.html`, and all 14
already-published `articles/*.html` files) — none of which are covered by
the Astro pilot yet. **Any new article authored through `site/`** (once
deployed) gets every row marked ❌ below for free, via
`site/src/layouts/BaseLayout.astro` — see `docs/technical-debt/backlog.md`
#1 for details. See `docs/technical-debt/backlog.md` #1-3, #9 for the
corresponding backlog items.

| Item | Status | Notes |
|---|---|---|
| Unique `<title>` per page | ✅ Present | Every page reviewed has a distinct, descriptive `<title>`. |
| Real `<meta name="description">` | ⚠️ Partial | ✅ on `index.html` + all 7 `manual/*.html` (fixed 2026-07-27). ❌ still missing on all 14 `articles/*.html` — open PR #11 (unmerged, stale) proposed this for 7 of them before article count grew; needs a fresh pass, not a merge of #11 as-is. |
| Canonical URLs (`rel="canonical"`) | ⚠️ Partial | Same split as above — done for `index.html` + `manual/*.html`, open for `articles/*.html`. |
| Sitemap (`sitemap.xml`) | ✅ Present (2026-07-18) | Generated from the published pages + their git history by `scripts/generate-sitemap.sh` as of 2026-07-25 — no longer hand-maintained. `deploy-pages.yml` regenerates it fresh before every deploy, so the *live* sitemap can never be stale; `.github/workflows/check-sitemap.yml` fails CI if the committed copy drifts from the generator's output. |
| `robots.txt` | ✅ Present (2026-07-18) | At repo root: allows all crawlers, disallows `/docs/` (internal engineering knowledge base, not blog content), points to the sitemap. |
| Open Graph tags | ⚠️ Partial | Same split — done for `index.html` + `manual/*.html`, open for `articles/*.html`. |
| Twitter Card tags | ⚠️ Partial | Same split — done for `index.html` + `manual/*.html`, open for `articles/*.html`. |
| JSON-LD structured data (Article/BlogPosting) | ⚠️ Partial | `WebSite` schema on `index.html` + `manual/index.html`; `BlogPosting` schema on all 6 published modules. Still missing on all 14 `articles/*.html`. |
| RSS/Atom feed | ❌ Missing | Does not exist. |
| Clean, crawlable URLs | ✅ Present | Static `.html` files, human-readable slugs (e.g. `articles/streaming-agent-output-to-the-browser.html`). |
| Semantic heading structure | ⚠️ Partial | Trends Board skips heading levels (h2→h4); see accessibility audit. |

## 2026-07-27 fix and a recurrence of the wrong-base-branch bug

This run found that real SEO meta tags for `index.html` and the Articles
stream had *already been written and merged* once before — PR #17
(2026-07-24, "Add real SEO meta tags to index.html and the Articles
stream"). But PR #17's base branch was `claude/daily-ai-trends-tutorial-txft7z`,
not `main` (confirmed via `mcp__github__pull_request_read`: `base.ref` =
that branch). The merge succeeded, so the PR shows as "merged," but the
commit never reached `main` — the exact same failure mode backlog item
#13 (RESOLVED 2026-07-21) already diagnosed once for the Astro pilot
(ADR-0001) landing on the same wrong branch. This is now a **second
confirmed occurrence** of agent-authored PRs targeting a stale branch
instead of the true default branch, three days after PR #17 itself and
six days after item #13 called it resolved.

**What this run recovered:** `index.html`'s meta description, canonical,
Open Graph, Twitter, and JSON-LD tags — verified identical to the
stranded PR #17 commit's diff (`git show 191069d -- index.html`), since
`index.html` hadn't changed since. **What this run did not recover:**
PR #17 also touched `articles/index.html` and 3 article pages — those
were **not** reapplied, because the Articles stream has grown from 4 to
14 pages since PR #17 was written and a second open PR (#11, base=`main`,
unmerged) already targets an overlapping but different 7-file slice of
the same pages. Reapplying either stale PR's exact diff today would
either miss the 10 newer articles or produce duplicate/conflicting tags
once a human merges #11 or #17. **This run instead did fresh, net-new
work for `manual/*.html`** (7 files, never touched by any prior PR),
closing that slice of backlog #1 cleanly with no merge-conflict risk.

**Still open, and now the top Immediate item:** a human needs to decide
the fate of PR #11 and PR #17 (close, rebase, or manually reconcile) before
`articles/*.html`'s meta tags can be added without producing duplicate or
conflicting work a third time. See backlog #1 and #14, and roadmap
Immediate.

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
