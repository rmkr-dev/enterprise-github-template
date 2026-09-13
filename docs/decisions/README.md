# Architecture Decision Records

Significant choices are recorded here so a later reader can see *what* we decided, *why*, and *what we rejected*.

## When to write an ADR

Write one when the decision is expensive to reverse or will constrain later work, for example:

- Adding or replacing a language, package manager, or CI system
- Changing license, default branch protection, or required checks
- Choosing a data store, auth model, or public API shape
- Dropping a guardrail from `AGENTS.md`

Skip an ADR for typo fixes, doc wording, and other local edits that do not change the system’s shape.

## How to record one

1. Add `NNNN-short-title.md` in this directory. Numbers are zero-padded and monotonic (`0001`, `0002`, …).
2. Use a short, stable structure:

   ```markdown
   # NNNN: Title

   - Status: Proposed | Accepted | Superseded by NNNN
   - Date: YYYY-MM-DD

   ## Context
   ## Decision
   ## Consequences
   ## Alternatives considered
   ```

3. Link the ADR from the PR and from `docs/architecture/architecture.md` if the current-state design changed.
4. Do not rewrite history. Supersede the old ADR and leave it in place.

There are no ADRs in this slice. The first accepted decision in a consumer repo should be `0001`.
