# Security

This is the security posture **for people who consume the template**, and for anyone changing the template itself. It is not a vulnerability-reporting policy file; a root `SECURITY.md` can be added in a later slice if you want GitHub’s reporting UI.

## Defaults

- **No secrets in git.** Tokens, keys, and `.env` files stay out of the tree and out of examples. Use GitHub Actions secrets or the host’s secret store when automation exists.
- **Least privilege.** When workflows appear, grant `permissions` explicitly and keep `GITHUB_TOKEN` write access off unless the job must push or comment.
- **Public-safe content.** This template is meant for public portfolio use: no personal contact details, no company names, no certifications or awards in repo content.
- **Dependencies.** Do not add packages to “look complete.” Every dependency is an attack surface. Language lockfiles and Dependabot belong with the application slice, not this docs slice.

## What consumers should do after copying

1. Set branch protection on `main` (reviews, and required checks once CI exists).
2. Restrict who can approve workflows and who can create tokens.
3. Add a real `SECURITY.md` with a reporting path that you actually monitor.
4. Turn on Dependabot and CodeQL (or equivalent) when those files exist in a later slice — do not paste badges before the scans run.
5. Review `AGENTS.md` and drop only the rules that do not apply, via an ADR.

## Reporting a problem in this template

Open a GitHub issue on the template repository describing the doc or default that is unsafe. Do not file secrets in the issue; rotate first, then describe the class of leak.
