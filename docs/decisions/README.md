# Architecture Decision Records

One ADR per significant decision, filed as `ADR-NNNN-<slug>.md`
(zero-padded, sequential). No ADRs have been written yet — this repository
is on its bootstrap knowledge-base run (2026-07-17) and had no prior
`docs/` tree to draw decisions from.

Format for future ADRs:

```
# ADR-NNNN: <title>

Status: Proposed | Accepted | Superseded by ADR-MMMM
Date: YYYY-MM-DD

## Context
What forces are at play; what problem this decision resolves.

## Decision
What was decided.

## Consequences
What becomes easier or harder as a result.
```

Never delete an ADR. To reverse one, write a new ADR that supersedes it,
mark the old one's Status line as `Superseded by ADR-MMMM`, and document
the migration path in the new ADR.

The first ADR candidate identified by the initial audit
(`docs/technical-debt/backlog.md` #6) is a decision on whether/how to
introduce any build or CI tooling without violating this repo's
"fully self-contained, dependency-free page" design principle.
