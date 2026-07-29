# Technical Debt Backlog

Prioritized using the task priority order from the agent's operating
instructions (failing build → security → broken functionality →
performance → SEO → accessibility → architecture → testing → DX →
documentation → refactoring). Each item is a candidate task for a future
run, not yet acted on unless marked otherwise.

Status legend: `OPEN` (not started) · `IN PROGRESS` · `DONE` (date + PR).

## Priority 1 — Failing build / broken CI

14. **CRITICAL, OPEN (found 2026-07-29) — `Deploy to GitHub Pages` has
    failed on every single run since the workflow was created.** Checked
    the GitHub Actions API directly (not just local build state, which is
    all every prior run's STEP 2 health check actually verified): of the
    18 completed runs of `.github/workflows/deploy-pages.yml` on `main`
    since 2026-07-17, **18/18 ended in `failure`**, including the run
    triggered by today's push (`ff310bb`, run
    [30470223754](https://github.com/tseten1996/daily-ai-news/actions/runs/30470223754)).
    Every failing run completes in ~2 seconds with `runner_id: 0` and no
    runner ever assigned — the job is rejected before any step
    (`checkout`, `configure-pages`, `generate-sitemap.sh`,
    `upload-pages-artifact`, `deploy-pages`) executes, and no job log is
    ever produced (`GET .../logs` returns `404` even for today's run).
    That signature — instant rejection, zero runner, zero log — is not
    consistent with a bug in the workflow YAML (which matches GitHub's
    own standard Pages-deploy template: correct `permissions`,
    `environment: github-pages`, `configure-pages@v5` with
    `enablement: enabled`). It is consistent with the repository's
    **GitHub Pages source not being enabled/set to "GitHub Actions" in
    Settings → Pages** (or Pages being unavailable for this repository's
    current visibility/plan) — something only a human with repo admin
    access can fix; no tool available to this agent can read or change
    repository Settings. **Practical impact: as far as this evidence
    shows, the site has likely never been successfully published via this
    workflow, for its entire 12-day existence.** Every prior run's
    changelog entry describing the site as "live" was going on the
    presence of the workflow file and local build success, not on
    confirmed deploy status — that assumption should be treated as
    unverified until a human confirms Pages is actually configured and a
    manual `workflow_dispatch` run (or the next push) succeeds.
    **Recommended fix (for the repo owner, not automatable from here):**
    GitHub repo → Settings → Pages → Build and deployment → Source, set
    to "GitHub Actions" if it isn't already; then re-run the workflow
    (Actions tab → "Deploy to GitHub Pages" → "Re-run all jobs", or push
    any commit) and confirm it goes green. **Process fix applied this
    run:** none to the workflow itself (no code-level bug was found to
    fix, and speculatively editing the YAML without being able to observe
    a real run's logs risks masking the actual cause). Flagging this as
    the reason future runs' STEP 2 health check should include checking
    actual GitHub Actions run status via the API, not just local
    build/lint — this failure was invisible to 18 consecutive local-only
    health checks.
15. **OPEN (found 2026-07-29) — Five open, unmerged, overlapping PRs from
    prior architecture-review runs, none merged since at least PR #15
    (merged 2026-07-22 per `main`'s log).** `list_pull_requests` shows 5
    open PRs against this repo, all authored by prior runs of this same
    agent: #11 (2026-07-20, SEO tags for `articles/*.html`), #16
    (2026-07-23, robots.txt/sitemap.xml — **targets the stale branch
    `claude/daily-ai-trends-tutorial-txft7z`, not `main`, and duplicates
    work already shipped on `main` since 2026-07-18**), #20 (2026-07-26,
    sitemap CI fix), #22 (2026-07-27, SEO tags for `index.html` +
    `manual/*.html`), #23 (2026-07-28, SEO tags for `index.html` + the
    Field Manual — **overlaps #22 almost exactly, one day apart**). None
    have been merged or closed. Because nothing merges these PRs, each
    day's fresh run re-orients against `main` (which never received the
    previous day's proposed fix), re-discovers the same open backlog item
    (#1, SEO meta tags), and opens yet another overlapping PR proposing
    a slightly different slice of the same work — at least 3 separate
    unmerged attempts now exist at "add SEO tags to `index.html` +
    `manual/*.html`" alone (the stranded commit `191069d`/PR #17, PR #22,
    PR #23). This is pure wasted work and a process gap, not a code
    problem: **someone with merge access needs to review and merge (or
    close, for #16) these 5 PRs**, ideally oldest-first so later ones can
    be diffed against what actually landed rather than reopening the same
    diff. Not something this agent can safely resolve unilaterally —
    merging another run's unreviewed PR without human sign-off, or
    closing PRs it didn't open, is outside this agent's authority. Recommend the repo owner triage these 5 PRs before the next scheduled
    run, or the pileup will keep growing by one PR/day.

## Priority 5 — SEO

1. **PARTIALLY ADDRESSED (2026-07-17) for new content only** — No SEO
   metadata anywhere in the *legacy* site. Audited all HTML files
   (`index.html`, `articles/*.html`, `manual/*.html`): zero real
   `<meta name="description">` tags, zero Open Graph tags, zero Twitter
   Card tags, zero `rel="canonical"` links, zero JSON-LD structured data.
   Some pages carry a "meta description" value only inside an HTML
   *comment* (front-matter for future authoring runs) — it is never
   emitted as an actual `<meta>` tag, so it has no SEO effect today. This
   directly contradicts the platform's stated SEO goals (discoverability,
   social sharing, Article/BlogPosting JSON-LD). **Fixed architecturally
   for the Astro pilot** (`site/` — see ADR-0001): its shared
   `BaseLayout` emits real meta description, canonical, OG, Twitter, and
   JSON-LD tags automatically for every page built through it. **Still
   open** for `index.html`, `manual/*.html`, and all 7 already-published
   `articles/*.html` pages, none of which are covered by the Astro pilot
   yet. High value, low risk — likely needs splitting: (a) add real
   `<meta description>` + canonical + OG/Twitter tags per page first
   (small, mechanical, ~10 files/run), (b) add JSON-LD Article schema per
   article/module page as a follow-up slice. **Note (2026-07-29): do not
   pick this item up again until item 15's PR pileup is resolved.** Three
   separate unmerged attempts already exist (PR #11 for `articles/*.html`;
   PR #22 and PR #23, one day apart, both for `index.html` +
   `manual/*.html`) — a fourth attempt this run would only add a fourth
   overlapping diff nobody has merged. **Note (2026-07-25):** PR #11
   ("Add real SEO meta tags to Articles pages", open since 2026-07-20,
   targets `main`) already proposes this for `articles/*.html`. A future
   run picking up slice (a) should check whether #11 has merged first and
   scope to `index.html` + `manual/*.html` if so, to avoid duplicating
   in-flight work.
2. **DONE (2026-07-18); hardened 2026-07-22; root-caused 2026-07-25** —
   `robots.txt` and `sitemap.xml` at the repo root. **Went stale three
   times.** 2026-07-19: a new article shipped without a sitemap entry
   (fixed same-day; added a prose reminder to
   `SCHEDULED_TASK_PROMPT.md`). 2026-07-22: recurred anyway
   (`articles/tool-descriptions-are-prompts.html` missing) — added
   `scripts/check-sitemap.sh` + `.github/workflows/check-sitemap.yml`, a
   verify-only CI check for missing entries. 2026-07-25: recurred a
   *third* time (`articles/mcp-anatomy-hosts-clients-servers-primitives.html`
   missing) — the CI check exists but is non-blocking, and nothing was
   watching its status before the next commit landed. That same audit
   found a **second, previously-undetected class of drift**: an existing
   entry (`context-compaction-for-long-running-agents.html`) carried a
   `<lastmod>` one day off from its real last commit — the missing-entry
   check never covered stale dates at all. **Fix applied 2026-07-25:**
   replaced the hand-maintained file with `scripts/generate-sitemap.sh`,
   which derives every entry (URL, priority, changefreq, and `<lastmod>`
   from each page's own `git log`) mechanically from the published pages
   on disk. `check-sitemap.sh` now diffs the committed file against the
   generator's output (catches staleness of any kind, not just missing
   URLs) and `deploy-pages.yml` runs the generator itself right before
   uploading the Pages artifact — so the *live* sitemap is always correct
   even if a future commit forgets to regenerate the checked-in copy, and
   the generator step cannot fail the deploy (it only ever regenerates,
   never errors on drift). This removes the human-memory dependency
   entirely rather than adding a fourth reminder.
3. **OPEN — No RSS/Atom feed.** Domain standards call for an RSS feed for
   a blog platform; none exists. Would need a decision on whether it's
   hand-maintained XML (consistent with the no-build-step philosophy) or
   generated by tooling (would require introducing a build step — see
   architecture item below first).

## Priority 6 — Accessibility

4. **OPEN — Heading hierarchy skips levels on the Trends Board.**
   `index.html` goes from `<h1>`/`<h2>` straight to `<h4>` (60 occurrences)
   with no `<h3>` in between. Skipping heading levels fails WCAG 2.4.6 /
   is flagged by every automated a11y checker (axe, Lighthouse). Needs
   confirmation of the intended document outline before renumbering
   (cosmetic-looking but is a real semantic/AT-navigation issue, not a
   cosmetic-only change — do not defer indefinitely).
5. **OPEN — No automated accessibility testing.** No axe-core/Lighthouse
   CI check exists; the only current verification is a human/agent
   eyeballing a headless-browser screenshot. See testing gap below — this
   is really one root cause with two symptoms.

## Priority 7 — Architecture health

6. **OPEN — No build, lint, type-check, or test CI pipeline for the
   legacy pages.** A deploy workflow exists
   (`.github/workflows/deploy-pages.yml`, added between the 2026-07-17
   and 2026-07-18 runs) that publishes the repo to GitHub Pages on push
   to `main` — but it only uploads and deploys static files verbatim; it
   runs no lint, no HTML validation, no link-checking, no accessibility
   check, and no test of any kind for `index.html`/`manual/*.html`/
   `articles/*.html`. This repo has *nothing* for the "verify before PR"
   step in the agent's non-negotiable safety rules to run for those pages
   beyond manual inspection. **ADR-0001 answers this for new
   Articles-stream content only**: `site/` has a real build
   (`npm run build`) and type-check (`astro check`), both verified clean,
   deliberately kept isolated from the legacy pages so it can't break
   them — but that pipeline is not wired into CI either (see item 8).
   Every other legacy-page quality gate (accessibility CI, SEO
   validation, broken-link checking) is blocked on deciding whether to
   introduce *any* verification tooling for those pages, and if so, how
   to do it without violating the "no build step, fully self-contained
   pages" design principle the content-authoring spec
   (`SCHEDULED_TASK_PROMPT.md`) explicitly relies on — note that a
   verify-only CI step (e.g. an HTML validator or link checker that runs
   in CI but changes nothing about what ships) would *not* violate that
   principle, since the served artifact is untouched; that distinction
   should be central to the ADR. Needs an ADR before any tooling is
   introduced for the legacy pages — see roadmap. **Update (2026-07-22):**
   item 2's sitemap-freshness check (`scripts/check-sitemap.sh` +
   `.github/workflows/check-sitemap.yml`) is a first concrete instance of
   the verify-only pattern described above — added narrowly to fix a
   recurring live regression, not as a general decision on legacy-page
   tooling. The broader ADR (lint/HTML-validation/link-checking/a11y CI)
   is still open; this one check does not preempt or substitute for it.
7. **OPEN for legacy pages; RESOLVED for the Astro pilot** — Significant
   CSS/JS duplication across every legacy page. Each of the 12 legacy
   HTML files independently redefines the same category of design tokens
   (paper/ink/accent/border custom properties, similar dark-mode media
   query, similar mono/serif font stacks) with page-family-specific
   variants (Trends Board vs. Articles vs. Manual each have their own
   palette). `site/`'s `BaseLayout`/`ArticleLayout` resolve this for
   anything built through the Astro pipeline — tokens are defined once
   and shared, while the *built output* is still a self-contained HTML
   file per page (no client-side CSS request), so the self-containment
   property is preserved even though the *source* is now componentized.
   Still open for the legacy pages, which ADR-0001 explicitly does not
   touch.
8. **OPEN — Astro pilot (`site/`) is not wired into CI/deploy.** Verified
   locally only (`npm run build`, `astro check`, manual Playwright
   screenshot pass — see ADR-0001). A push to `main` today does not build
   or publish anything from `site/`. This was previously invisible on
   `main` because the pilot's branch history had landed on a stale branch
   instead of `main` (see item 13, now resolved) — now that it's
   reconciled, this is a live, actionable item. See roadmap "Immediate".
9. **OPEN — Fate of the 7 already-published legacy articles is
   undecided.** Running both a legacy `articles/*.html` version and a
   future Astro-migrated version of the same article live at the same
   time would be duplicate content for SEO purposes. Needs a short ADR
   before any legacy article is migrated into `site/`. See roadmap
   "Immediate".

## Priority 8 — Testing gaps

10. **OPEN — Zero automated tests for the legacy pages.** No unit tests
    (no logic to unit-test — it's static content), no component tests, no
    Playwright E2E for the critical journeys the domain standards call out
    (reading an article, navigation, RSS/sitemap availability once they
    exist). The daily content-authoring run does do a manual Playwright
    smoke pass (open changed pages, check console errors, screenshot) per
    `SCHEDULED_TASK_PROMPT.md`, but nothing is codified as a repeatable,
    CI-enforceable test. `site/` has `astro check` (type-check) but no
    E2E/component tests yet either. Blocked on item 8 (CI wiring) to
    become enforceable rather than just runnable locally. **Update
    (2026-07-22):** one narrow, CI-enforceable structural check now
    exists — `scripts/check-sitemap.sh`, run by
    `.github/workflows/check-sitemap.yml` on every push/PR — verifying
    every published legacy HTML page has a `sitemap.xml` entry. This is
    the first automated, repeatable, CI-gated check in the repository for
    the legacy pages. It covers exactly one structural property, not
    behavior or user journeys — the Playwright E2E gap this item
    describes remains fully open.

## Priority 10 — Documentation

11. **DONE (2026-07-17)** — This knowledge base did not exist before that
    day's bootstrap run, which created it (`docs/architecture/overview.md`,
    `docs/roadmap/roadmap.md`, this backlog, and the empty-but-structured
    remaining KB files). No code changed in that run.
12. **DONE (2026-07-17)** — Wrote ADR-0001 and scaffolded the Astro pilot
    (`site/`) per the user's request to move toward a componentized,
    best-practices architecture. Updated this backlog, the roadmap, and
    `docs/architecture/overview.md` to reflect current vs. target state.
13. **RESOLVED (2026-07-21)** — Previously: an SPA-migration decision
    (ADR-0001, Astro pilot) landed on a PR but never reached `main`, and
    was undocumented on `main`. Discovered while orienting for the
    2026-07-19 run: PR #6 ("Add Astro pilot for the Articles stream
    (ADR-0001)") was merged, but its base branch was
    `claude/daily-ai-trends-tutorial-txft7z` — an old feature-line branch,
    not `main` — because several earlier PRs (#1-#6) were chained against
    that branch instead of the true default branch. **Fix applied this
    run:** the branch carrying the Astro pilot commit (`281cff4`) was
    merged into `main`'s current line of development (bringing in PRs
    #7-#12 that had landed on `main` in the meantime — new articles,
    `robots.txt`/`sitemap.xml`), with all five doc conflicts resolved by
    hand to reconcile both branches' independent updates. `site/`,
    `docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md`, and this
    knowledge base's Astro-pilot content are now present and documented
    on the branch that will become `main`. **What's still open, tracked
    separately:** the pilot still isn't wired into CI/deploy (item 8) and
    the fate of the 7 published legacy articles is still undecided
    (item 9) — reconciling the history didn't answer either question, it
    just made them visible and actionable again.

## Notes / non-issues found during audit

- No images anywhere in the site (text/SVG only), so image-format/lazy-
  loading optimization is not currently applicable — worth re-checking if
  the content model ever adds images.
- `lang="en"` is present and correct on every page.
- Every page is self-contained with no external requests — genuinely
  strong for privacy, offline-resilience, and load performance baseline.
