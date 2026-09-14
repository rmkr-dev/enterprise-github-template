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
| `FORBIDDEN Node package-ecosystem` in Dependabot | npm/yarn/pnpm update stream added to this template | Remove Node ecosystems; keep `github-actions` only (ADR-004) |
| `FORBIDDEN Node/npm artifacts` | `package.json` / lockfile / `node_modules` landed in template | Remove them; ADR-004 keeps validation shell-only |
| `MISSING languages: actions` / `security-events: write` | CodeQL no longer analyzes Actions YAML or cannot upload SARIF | Restore `languages: actions` and `security-events: write` in `codeql.yml` |
| `MISSING publish_results: true` | Scorecard no longer publishes to the public API / badge | Restore `publish_results: true` (or document private-repo exception) |
| `MISSING workflow_dispatch:` on CI | Cannot re-run template validation without a noop PR | Restore `workflow_dispatch:` under `on:` in `ci.yml` |
| `MISSING .env` / `node_modules` ignore | Local env files or accidental Node trees can be committed | Restore `.env` / `node_modules/` entries in `.gitignore` |
| `MISSING --verify-tag` | Release job may create a release for a mismatched tag object | Restore `gh release create … --verify-tag` in `release.yml` |
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
