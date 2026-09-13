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
| `docs/development/` | Contributor workflow on the template |
| `docs/security/` | Security expectations for template consumers |
| `docs/operations/` | Maintainer operations and release process |
| `CHANGELOG.md` | Notable changes for template consumers |
| `.github/workflows/` | CI (template validation) and CodeQL (`actions`) |
| `.github/dependabot.yml` | Weekly GitHub Actions dependency updates |
| `.github/CODEOWNERS` | Default review owner `@rmkr-dev` |
| `.github/ISSUE_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md` | Community issue/PR hygiene |
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

CI does **not** build an application. It validates that the template’s required files and docs stay coherent (`scripts/validate-template.sh` plus tests, including a shell-syntax job). CodeQL analyzes Actions workflow YAML. See [ADR-002](../decisions/ADR-002-validation-in-ci.md) and [development.md](../development/development.md).

## Network posture

This template has **no networked runtime**. There is nothing to put on a VPC, CDN, or service mesh diagram. Consumers **must** add a network diagram when they introduce networked or cloud systems. See [network-diagram.md](network-diagram.md) for the explicit note and a consumer-owned Mermaid stub.

## Related decisions

- [ADR-001: GitHub-native free-first repository template](../decisions/ADR-001-github-native-template.md)
- [ADR-002: Validate the template in GitHub Actions CI](../decisions/ADR-002-validation-in-ci.md)

## What is intentionally out of scope here

- Application source, sample services, or fake “hello world” stacks
- Language package managers (no Node/npm in this template)
- Network or deployment diagrams for infrastructure that is not in this repo
