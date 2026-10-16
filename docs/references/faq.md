# FAQ (template consumers)

Short answers for people who just used **Use this template**. Deeper checklists live in [first-week.md](../development/first-week.md) and [troubleshooting.md](../operations/troubleshooting.md).

## Is this an application?

No. This repository is documentation, process defaults, and GitHub Actions hygiene. Application code belongs in the **derived** repository after you create it.

## Do I need Node/npm?

Not for this template. Prefer language-native tooling in derived repos. See the technology stance in the root README.

## Why is CI only validating Markdown and scripts?

Because there is no application to build. ADR-002 explains why validation runs in Actions. When you add product code, add real build/test jobs in the derived repo.

## Can I delete AGENTS.md or the validator?

You can, but then update docs and CI so they stay honest. Prefer adapting them until you deliberately replace the process.

## How do I get security updates from upstream?

There is no automatic sync. Periodically review this template’s releases (`v*`) and cherry-pick or re-apply changes you want. See [upgrading-from-upstream.md](../operations/upgrading-from-upstream.md) for a safe file-level upgrade order.

## Where do I report a vulnerability?

Privately via [SECURITY.md](../../SECURITY.md) (GitHub Security Advisories). Do not open a public issue for exploitable template defects.

## Dependency review failed on my new repo

Enable Dependency graph (and Dependabot alerts if prompted) under the repository Security settings. See [troubleshooting.md](../operations/troubleshooting.md).

## Should I require the weekly scheduled validate check on PRs?

No. It does not run on pull requests. Keep PR required checks aligned with `ci.yml` jobs — see [branch-protection.md](../operations/branch-protection.md).

## Which language sketches exist?

Docs-only evolution guidance for Java, Python, Go, Rust, .NET/C#, PHP, Ruby, Kotlin, Terraform/IaC, and Azure/AKS lives in [examples.md](examples.md). None of those sketches add application code to **this** template.

## How do I cut a template-style release?

On this template (or a derived repo that kept the workflow), push an annotated `vMAJOR.MINOR.PATCH` tag after the matching `## [X.Y.Z]` CHANGELOG section exists. `.github/workflows/release.yml` creates the GitHub Release and embeds that section ([ADR-006](../decisions/ADR-006-changelog-backed-github-releases.md)). See [tagging.md](../operations/tagging.md) and [release-process.md](../operations/release-process.md).

## Where should cloud credentials live?

Not in git. Prefer OIDC / federated credentials from GitHub Actions. See [secrets-and-oidc.md](../operations/secrets-and-oidc.md).

## Why are Actions pinned to long SHAs?

Mutable tags (`@v4`) can move. This template pins the commit SHA of the intended release and keeps a `# vX.Y.Z` comment so Dependabot and humans can still see the version. See [ADR-005](../decisions/ADR-005-pin-github-actions-to-shas.md).

## Can I add Prettier or markdownlint via npm?

Not in **this** template — ADR-004 keeps validation shell-only. A derived product repo may add Node if the **product** needs it; do not add it only to lint Markdown here.

## Related

- [examples.md](examples.md) — Java / Python / Go / Rust / .NET / PHP / Ruby / Kotlin / Terraform / Azure-AKS evolution sketches
- [upgrading-from-upstream.md](../operations/upgrading-from-upstream.md) — adopt later template releases
- [SUPPORT.md](../../SUPPORT.md) — where questions go
