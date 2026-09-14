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

There is no automatic sync. Periodically review this template’s releases (`v*`) and cherry-pick or re-apply changes you want.

## Where do I report a vulnerability?

Privately via [SECURITY.md](../../SECURITY.md) (GitHub Security Advisories). Do not open a public issue for exploitable template defects.

## Dependency review failed on my new repo

Enable Dependency graph (and Dependabot alerts if prompted) under the repository Security settings. See [troubleshooting.md](../operations/troubleshooting.md).

## Should I require the weekly scheduled validate check on PRs?

No. It does not run on pull requests. Keep PR required checks aligned with `ci.yml` jobs — see [branch-protection.md](../operations/branch-protection.md).

## Which language sketches exist?

Docs-only evolution guidance for Java, Python, Go, Rust, .NET/C#, and Azure/AKS lives in [examples.md](examples.md). None of those sketches add application code to **this** template.

## Related

- [examples.md](examples.md) — Java / Python / Go / Rust / .NET / Azure-AKS evolution sketches
- [SUPPORT.md](../../SUPPORT.md) — where questions go
