# Operations

How maintainers operate **this template repository**. Derived products should replace or extend this document for their own runtime; do not invent application ops here.

## What we operate

| Surface | Owner action |
| --- | --- |
| GitHub template flag | Keep enabled so **Use this template** works |
| Default branch `main` | Merge complete slices only; keep CI green |
| Actions (CI, weekly validate, CodeQL, dependency review, Scorecard) | Free-plan workflows; least-privilege permissions |
| Dependabot | Review weekly Actions update PRs |
| Dependency graph / alerts | Keep enabled so dependency-review CI can run |
| OpenSSF Scorecard | Review code-scanning / Scorecard results after `main` pushes |
| Security advisories | Triage via [SECURITY.md](../../SECURITY.md) |

There is no application runtime, hosting, or on-call rotation for this template.

## Day-to-day

1. Prefer small PRs that leave docs, scripts, and workflows consistent.
2. Run `bash scripts/validate-template.sh` and `bash tests/test_validate_template.sh` before merge when changing required files or links.
3. Merge Dependabot PRs after CI is green; major action bumps deserve a quick look at release notes.
4. When adding a required file, update `scripts/validate-template.sh` in the same PR.

## Incidents (template-scoped)

| Symptom | First response |
| --- | --- |
| CI red on `main` | Revert or fix-forward the last merge; do not leave `main` broken |
| Broken relative Markdown links | Fix links or restore the target file; validator must pass |
| Suspected unsafe default in a workflow | Draft a private advisory per SECURITY.md; tighten permissions |
| Secret in git or compromised Action | Follow [incident-response.md](incident-response.md); rotate credentials first |

For a fuller light checklist (containment, disclosure, follow-through), see [incident-response.md](incident-response.md).

## Related docs

- [Incident response](incident-response.md) — light IR checklist for template consumers
- [Development](../development/development.md) — local checks and CI shape
- [Release process](release-process.md) — tagging and GitHub Releases
- [Branch protection](branch-protection.md) — recommended required checks on `main`
- [CHANGELOG.md](../../CHANGELOG.md) — user-facing history
- [Security](../security/security.md) — consumer posture
