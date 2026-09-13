# Security

## Posture for this template

This repository ships documentation, process defaults, and GitHub Actions hygiene—not an application runtime. Security expectations for **the template itself**:

- No secrets, tokens, or credentials in the tree, examples, or commit messages
- Workflow permissions are least-privilege (`contents: read` for CI; CodeQL adds `security-events: write`)
- Dependabot keeps GitHub Actions dependencies on a weekly cadence
- CodeQL analyzes Actions workflow YAML on PR, push to `main`, and a weekly schedule
- Vulnerability reports for this template go through [SECURITY.md](../../SECURITY.md) (GitHub Security Advisories / `@rmkr-dev`)

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

## Related community docs

- Vulnerability reporting: [SECURITY.md](../../SECURITY.md)
- Support routing (non-security): [SUPPORT.md](../../SUPPORT.md)
- Conduct: [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md)
