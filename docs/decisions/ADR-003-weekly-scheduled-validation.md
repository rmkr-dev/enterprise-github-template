# ADR-003: Weekly scheduled template validation

- Status: Accepted
- Date: 2026-09-14

## Context / Problem

ADR-002 put template hygiene checks on every pull request and every push to `main`. That covers active change, but a quiet repository can still drift relative to GitHub Actions runner images, action major versions after Dependabot merges, or forgotten local-only edits that somehow land. Scorecard and CodeQL already use weekly schedules; validation did not.

## Options

1. **PR/push CI only** — Rely on human activity to keep checks warm. Simple; gaps grow when the repo is idle.
2. **Add `schedule` to `ci.yml`** — Same workflow file gains a cron. Works, but mixes PR-required jobs with a hygiene timer and can confuse required-check naming.
3. **Dedicated weekly workflow** — Separate `validate-scheduled.yml` with cron + `workflow_dispatch`, same jobs as CI, not a PR required check.
4. **External cron / third-party** — Outside GitHub. Extra secrets and accounts; conflicts with free-first GitHub-native stance.

## Decision

Choose **option 3**: ship `.github/workflows/validate-scheduled.yml` that runs the same validator, validator tests, and shell-syntax checks every week (and on demand). Keep it out of branch-protection required checks for pull requests.

## Rationale

- Reuses the ADR-002 shell checks without a new language runtime.
- Matches how CodeQL and Scorecard already schedule hygiene work.
- `workflow_dispatch` lets maintainers run the same path without opening a noop PR.
- Separating the workflow avoids teaching GitHub that a schedule-only job is a PR gate.

## Consequences

- The template validator must treat `validate-scheduled.yml` as a required file (same completeness bar as other workflows).
- Quiet weeks still produce Actions runs; failures need the same fix-forward discipline as CI on `main`.
- Consumers who disable Actions schedules should document that choice; default remains on.

## Related

- [ADR-002: Validate the template in GitHub Actions CI](ADR-002-validation-in-ci.md)
- [Development](../development/development.md)
- [Branch protection](../operations/branch-protection.md)
