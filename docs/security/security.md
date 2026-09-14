# Security

## Posture for this template

This repository ships documentation, process defaults, and GitHub Actions hygiene—not an application runtime. Security expectations for **the template itself**:

- No secrets, tokens, or credentials in the tree, examples, or commit messages
- Workflow permissions are least-privilege (`contents: read` for CI; CodeQL adds `security-events: write`)
- Dependabot keeps GitHub Actions dependencies on a weekly cadence
- CodeQL analyzes Actions workflow YAML on PR, push to `main`, and a weekly schedule
- Dependency review runs on pull requests (GitHub-native; free for public repositories). Requires Dependency graph / vulnerability alerts enabled under the repository Security settings (enable Dependabot alerts if the workflow reports that Dependency review is not supported).
- OpenSSF Scorecard runs on pushes to `main` and weekly, publishing results to the public Scorecard API and code scanning (free for public repositories; private consumers should revisit `publish_results` and permissions). The README Scorecard badge reflects the public API result.
- Template validation also runs on a **weekly schedule** (`.github/workflows/validate-scheduled.yml`) in addition to pull requests and pushes to `main`
- Vulnerability reports for this template go through [SECURITY.md](../../SECURITY.md) (GitHub Security Advisories / `@rmkr-dev`)

## Workflow permissions (template defaults)

| Workflow | Top-level `permissions` | Why |
| --- | --- | --- |
| `ci.yml` | `contents: read` | Validate docs/scripts only |
| `validate-scheduled.yml` | `contents: read` | Same checks on a weekly cron |
| `dependency-review.yml` | `contents: read` | PR dependency graph review |
| `codeql.yml` | `contents: read`, `security-events: write`, `actions: read` | Upload CodeQL results |
| `scorecard.yml` | `read-all` at workflow; job grants `security-events` / `id-token` write | Public Scorecard + SARIF |
| `release.yml` | `contents: write` | Create GitHub Release for `v*` tags |

Derived repos should re-review these when adding deploy jobs. Prefer OIDC over long-lived cloud secrets. Do not widen `GITHUB_TOKEN` permissions “just in case.”

## Expectations for derived repositories

When you create a product repo from this template:

1. Keep the “no secrets in git” rule.
2. Extend CodeQL languages and CI jobs when you add application code.
3. Replace architecture and network docs when you introduce real systems; document trust boundaries there.
4. Do not publish personal contact details; prefer GitHub handles and private advisories.
5. Review workflow permissions whenever you add third-party actions.

## Out of scope here

- Production hardening for a specific cloud or runtime (owned by the consumer)
- Paid scanners as a merge gate
- Company names or private support emails in the template

## Related

- [Secrets and OIDC hygiene](../operations/secrets-and-oidc.md)
 community docs

- Vulnerability reporting: [SECURITY.md](../../SECURITY.md)
- Incident response (template-scoped): [docs/operations/incident-response.md](../operations/incident-response.md)
- Support routing (non-security): [SUPPORT.md](../../SUPPORT.md)
- Conduct: [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md)
