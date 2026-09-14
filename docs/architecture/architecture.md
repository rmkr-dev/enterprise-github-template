# Architecture

## Current state

This repository is a **GitHub repository template**, not a deployed application. There is no application runtime, datastore, API, or service boundary in this tree.

What exists today is the documentation, process skeleton, and GitHub hygiene/CI surfaces that consumers inherit when they create a repo from this template:

| Surface | Role |
| --- | --- |
| `README.md` | Entry point and how to use the template |
| `AGENTS.md` | Human and coding-agent guardrails; Definition of Done |
| `CONTRIBUTING.md` | How to propose changes |
| `SECURITY.md` | How to report vulnerabilities in this template |
| `docs/architecture/` | Current-state narrative and diagrams for *this* template |
| `docs/decisions/` | Architecture Decision Records |
| `docs/development/` | Contributor workflow + first-week consumer checklist |
| `docs/security/` | Security expectations for template consumers |
| `docs/operations/` | Maintainer operations and release process |
| `docs/references/` | Consumer evolution examples (not a sample app) |
| `CHANGELOG.md` | Notable changes for template consumers |
| `.gitignore` | Ignores editor/env/accidental build artifacts |
| `docs/operations/branch-protection.md` | Recommended required checks on `main` |
| `.github/workflows/` | CI validation (with concurrency), weekly scheduled validate, CodeQL (`actions`), dependency review, OpenSSF Scorecard, release-on-tag |
| `.github/dependabot.yml` | Weekly GitHub Actions dependency updates |
| `.github/CODEOWNERS` | Default review owner `@rmkr-dev` |
| `.github/ISSUE_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md` | Community issue/PR hygiene (including good-first-issue form) |
| `docs/operations/incident-response.md` | Light IR checklist for template / derived-repo maintainers |
| `scripts/validate-template.sh` | Required-file and Markdown link checks used by CI |
| `tests/test_validate_template.sh` | Minimal expectations for the validator |

Consumers copy this layout into a new repo, then replace the architecture narrative with **their** system and add application code and language-specific CI in later commits.

## Template inheritance

The GitHub **template repository** flag is enabled on this repository, so **Use this template** is available in the GitHub UI. A derived repository starts with the same docs, guardrails, and `.github/` defaults. Inheritance is copy-based (GitHub “Use this template” or clone/fork), not a live link. After creation, the consumer owns every file and should:

1. Rewrite `README.md` for the product.
2. Replace this document with the real system architecture.
3. Keep or adapt `AGENTS.md` and the `docs/` layout unless an ADR records a change.
4. Extend `.github/workflows` when they introduce application code that needs build/test jobs.

See [architecture-diagram.md](architecture-diagram.md) for a Mermaid view of these surfaces and how a derived repo relates to them.

## CI shape

CI does **not** build an application. It validates that the template’s required files and docs stay coherent (`scripts/validate-template.sh` plus tests, including a shell-syntax job) on pull requests, pushes to `main`, and a weekly schedule (`validate-scheduled.yml`). CodeQL analyzes Actions workflow YAML. Dependency review runs on pull requests. OpenSSF Scorecard runs on `main` and on a weekly schedule for public supply-chain signals. See [ADR-002](../decisions/ADR-002-validation-in-ci.md) and [development.md](../development/development.md).

## Network posture

This template has **no networked runtime**. There is nothing to put on a VPC, CDN, or service mesh diagram. Consumers **must** add a network diagram when they introduce networked or cloud systems. See [network-diagram.md](network-diagram.md) for the explicit note and a consumer-owned Mermaid stub.

## Related decisions

- [ADR-001: GitHub-native free-first repository template](../decisions/ADR-001-github-native-template.md)
- [ADR-002: Validate the template in GitHub Actions CI](../decisions/ADR-002-validation-in-ci.md)
- [ADR-003: Weekly scheduled template validation](../decisions/ADR-003-weekly-scheduled-validation.md)

## What is intentionally out of scope here

- Application source, sample services, or fake “hello world” stacks
- Language package managers (no Node/npm in this template)
- Network or deployment diagrams for infrastructure that is not in this repo
