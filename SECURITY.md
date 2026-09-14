# Security policy

## Supported versions

This repository is a **GitHub repository template** (docs, process, and CI skeleton). Security fixes apply to the default branch (`main`). Consumers who copied the template should review upstream changes and apply them intentionally.

| Version / branch | Supported |
| --- | --- |
| `main` (latest template) | Yes |
| Tagged releases (`v*`) | Best-effort; prefer rebasing onto current `main` |
| Forks / derived product repos | Owned by those maintainers (see Scope) |

## Reporting a vulnerability

Report security issues **privately**. Do **not** open a public GitHub Issue, Discussion, or pull request that discloses an exploitable problem.

**Preferred path (GitHub Security Advisories):**

1. Open a [new draft security advisory](https://github.com/rmkr-dev/enterprise-github-template/security/advisories/new) on this repository, or
2. Use **Report a vulnerability** on the repository **Security** tab if that button is enabled.

Contact is GitHub-only via `@rmkr-dev` / this repository’s advisory flow. No email addresses are published here.

### What to include

- A short description of the issue and realistic impact on **this template** or on consumers who copy unsafe defaults
- Steps to reproduce against this template repository (or a minimal derived copy)
- Affected paths (workflows, docs, scripts) when known
- Any suggested fix or mitigation

### What not to include

- Production secrets, tokens, session cookies, or personal data
- Full exploit kits aimed at third-party systems unrelated to this template

### Response expectations

- Maintainers aim to **acknowledge** private reports within **7 days**
- Valid issues are fixed on `main` (and noted in `CHANGELOG.md`) with coordinated disclosure preferred
- Credit is given in the advisory or changelog when the reporter wants it

## Scope

**In scope for this template**

- Unsafe default workflow permissions or overly broad `GITHUB_TOKEN` usage shipped here
- Secret or credential patterns accidentally present in docs, examples, or scripts
- Misleading security documentation that would cause consumers to weaken their posture
- Validator or CI gaps that allow clearly unsafe template defaults to merge unnoticed

**Out of scope**

- Application, cloud, or runtime vulnerabilities in **derived** product repositories (report those to the product’s own `SECURITY.md`)
- Social engineering against individual accounts
- Denial-of-service against GitHub.com itself
- Issues that require paid GitHub features or third-party scanners as a merge gate

## Related

- Consumer security posture: [docs/security/security.md](docs/security/security.md)
- Template-scoped incident checklist: [docs/operations/incident-response.md](docs/operations/incident-response.md)
- Day-to-day operations: [docs/operations/operations.md](docs/operations/operations.md)
