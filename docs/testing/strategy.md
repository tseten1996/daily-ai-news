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

## Blocked on

Introducing any of the above requires deciding how to run tests without
contradicting the site's no-build-step, fully-self-contained-page design
principle. This is the same open question as backlog #6 (tooling ADR) —
Playwright tests could plausibly run in CI against the static files
without changing anything about how the pages themselves ship, but that
decision should be made deliberately via ADR, not assumed here.

## Plan once unblocked

1. Start small: one Playwright E2E test per critical journey listed
   above, run in CI on every PR.
2. Add an automated accessibility scan (axe) as part of the same E2E run
   rather than a separate tool.
3. Do not chase coverage numbers — this repo has no framework code to
   cover; keep the suite to meaningful, journey-level checks per the
   domain testing standards.
