# Incident response (template consumers)

A **light checklist** for repositories created from this template. This is not an on-call runbook for a production application. Replace or extend it when your product has a runtime, SLO, or paging rotation.

## When this applies

Use this list for **repository / CI / supply-chain** incidents that affect the GitHub project itself, for example:

- Secrets or tokens committed (or suspected) in git history
- Workflow permissions that are broader than intended
- Compromised GitHub Actions or Dependabot updates
- Broken CI on the default branch that blocks all merges
- A vulnerability report received via your `SECURITY.md` path

Application outages, cloud account takeover, and customer-data incidents belong in **your** product IR plan—not here.

## Severity (template-scoped)

| Level | Examples | Urgency |
| --- | --- | --- |
| High | Live secret in default branch; workflow that can push with a leaked token | Act immediately; treat as private until mitigated |
| Medium | Overly broad `permissions:` on a workflow; CI red on `main` with no workaround | Fix same day when possible |
| Low | Stale docs, missing badge, Dependabot noise | Next maintenance slice |

## First 30 minutes

1. **Stop the bleeding** — revoke or rotate exposed credentials; disable or pin a bad workflow if it can still run.
2. **Contain disclosure** — if the issue is security-sensitive, use a private advisory (see [SECURITY.md](../../SECURITY.md)); do not discuss exploit details in public issues.
3. **Preserve evidence** — note commit SHAs, workflow run IDs, and who had access; avoid force-pushing away history you may need for forensics until the secret is rotated.
4. **Protect `main`** — prefer revert or fix-forward with CI green; do not leave the default branch broken.

## Follow-through

1. Land the fix on `main` with docs/CI updated in the same slice ([AGENTS.md](../../AGENTS.md) definition of done).
2. Note the change under `CHANGELOG.md` `[Unreleased]` (security fixes deserve an explicit bullet).
3. Close or publish the advisory when coordinated disclosure allows.
4. Add a short blameless note (issue or ADR) only if process should change—avoid speculative new tooling.

## Roles (defaults)

| Role | Default on a small repo |
| --- | --- |
| Decision maker | Repository admin / CODEOWNERS |
| Fix author | Whoever can open a PR with CI green |
| External contact | GitHub Security Advisories only unless your product defines another channel |

There is no dedicated incident commander for this **template**; derived products should name owners when they introduce production traffic.

## Related

- [SECURITY.md](../../SECURITY.md) — private vulnerability reporting
- [operations.md](operations.md) — day-to-day template operations
- [docs/security/security.md](../security/security.md) — security posture defaults
- [branch-protection.md](branch-protection.md) — required checks on `main`
