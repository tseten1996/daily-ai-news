# Testing Strategy

Last reviewed: 2026-07-17 (bootstrap run).

## Current state

No automated tests exist in this repository — no unit tests, no component
tests, no Playwright E2E suite, no CI workflow to run any of it. See
`docs/technical-debt/backlog.md` #8.

The daily content-authoring run (`SCHEDULED_TASK_PROMPT.md`, "Finish every
run") does perform a manual verification pass: it opens changed pages in a
headless browser (Playwright is preinstalled in the run environment),
confirms no console errors, checks navigation (board → article, graph
node → module, tabs switch), and takes a screenshot. This is real
verification, but it is agent-driven and ad hoc per run, not a
repeatable, version-controlled, CI-enforced test suite.

## What there is to test

Since this is a static, no-backend site, "testing" here means:

- **Critical user journeys** (per domain standards): reading an article
  end to end, navigating between the Trends Board / Articles / Manual
  sections, module dependency-graph navigation, tag/search filtering on
  the Trends Board, code-tab switching on module pages.
- **Structural checks once they exist**: sitemap/robots.txt reachability
  and validity, RSS feed validity (once built — see roadmap).
- **Accessibility checks**: automatable via axe integrated into an E2E
  run (see `docs/accessibility/audit.md`).

There is no business logic, API layer, or data transformation code to
unit-test today — the entire "logic" surface is the small amount of
inline client-side JS (Trends Board card rendering, code-tab switching).

## Update (2026-07-17): the Astro pilot changes this for new content

`docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md` introduced
`site/`, which has `astro check` (type-checking of components and content
front matter) run and verified clean. That's real, but it's not a
behavioral test — it doesn't verify a page renders correctly or that a
user journey works. It's also not run in CI yet (see roadmap: "Wire
`site/` into CI/deploy").

For the **legacy pages** (still everything actually live today), the
original blocker stands: introducing Playwright/axe CI checks requires
deciding how to run them without contradicting the no-build-step,
fully-self-contained-page design those pages follow. That's the same open
question as backlog #6, now partially informed by ADR-0001's approach
(isolate new tooling under `site/` rather than retrofitting it onto the
legacy pages) — but not yet decided for the legacy pages themselves.

## Plan once unblocked

1. Start small: one Playwright E2E test per critical journey listed
   above, run in CI on every PR — for `site/` once it's wired into
   deploy, this is a natural next addition (the build already exists;
   CI just needs to run it and a smoke test against the output).
2. Add an automated accessibility scan (axe) as part of the same E2E run
   rather than a separate tool.
3. Do not chase coverage numbers — this repo has no framework code to
   cover; keep the suite to meaningful, journey-level checks per the
   domain testing standards.
