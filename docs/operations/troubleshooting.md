# Troubleshooting (template CI and docs)

Quick fixes for common problems on **this template** or a fresh derived repo. Not an application runbook.

## Validator / CI

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `MISSING: path` in validate | Required file renamed/removed without updating the validator | Restore the file or update `scripts/validate-template.sh` in the same PR |
| `BROKEN LINK in …` | Relative Markdown target moved | Fix the link or restore the target |
| `MISSING concurrency:` / `permissions:` | Workflow edited incompletely | Add least-privilege `permissions:` and a `concurrency:` group (see `ci.yml`, `scorecard.yml`, `validate-scheduled.yml`, `release.yml`) |
| `MISSING persist-credentials: false` on Scorecard | Checkout may keep credentials longer than needed | Restore `persist-credentials: false` on the Scorecard checkout step |
| `MISSING package-ecosystem: github-actions` | Dependabot config lost Actions updates | Restore `package-ecosystem: github-actions` in `.github/dependabot.yml` |
| `MISSING timeout-minutes:` | Workflow job can hang indefinitely | Add `timeout-minutes` on jobs in CI, CodeQL, Scorecard, release, scheduled validate, and dependency-review workflows |
| `MISSING schedule:` on validate-scheduled | Weekly workflow lost its cron | Restore `on.schedule` + `cron` (see ADR-003) |
| Dependency review fails: not supported | Dependency graph / alerts off | Enable Dependency graph (and Dependabot alerts if prompted) under Security settings |
| CodeQL / Scorecard noisy on private fork | Public defaults | Revisit `publish_results` and permissions for private consumers |

Local reproduction:

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
```

## Releases

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| No GitHub Release after tagging | Tag did not match `v*` or Actions disabled | Use `vMAJOR.MINOR.PATCH`; confirm `.github/workflows/release.yml` ran |
| Release notes empty of product binaries | Expected | This template ships docs/CI only—see CHANGELOG |

## Community / security

| Symptom | Fix |
| --- | --- |
| Want to file a vuln publicly | Don’t—use [SECURITY.md](../../SECURITY.md) private advisory |
| Looking for starter work | `good first issue` label / form — [CONTRIBUTING.md](../../CONTRIBUTING.md) |
| CI red on `main` | Treat as an incident — [incident-response.md](incident-response.md) |

## Related

- [operations.md](operations.md)
- [branch-protection.md](branch-protection.md)
- [development.md](../development/development.md)
