# Architecture

## Current state

This repository is a **GitHub repository template**, not a deployed application. There is no application runtime, datastore, API, or service boundary in this tree.

What exists today is the documentation and process skeleton that consumers inherit when they create a repo from this template:

| Surface | Role |
| --- | --- |
| `README.md` | Entry point and how to use the template |
| `AGENTS.md` | Human and coding-agent guardrails; Definition of Done |
| `CONTRIBUTING.md` | How to propose changes |
| `docs/architecture/` | Current-state narrative and diagrams for *this* template |
| `docs/decisions/` | Architecture Decision Records |
| `docs/development/` | Contributor workflow on the template |
| `docs/security/` | Security expectations for template consumers |
| `.github/` (planned) | Actions, Dependabot, CodeQL, issue/PR templates — not in this slice yet |

Consumers copy this layout into a new repo, then replace the architecture narrative with **their** system and add application code, tests, and CI in later commits.

## Template inheritance

A derived repository starts with the same docs and guardrails. Inheritance is copy-based (GitHub “Use this template” or clone/fork), not a live link. After creation, the consumer owns every file and should:

1. Rewrite `README.md` for the product.
2. Replace this document with the real system architecture.
3. Keep or adapt `AGENTS.md` and the `docs/` layout unless an ADR records a change.
4. Add `.github/workflows` and other automation when they introduce code that needs it.

See [architecture-diagram.md](architecture-diagram.md) for a Mermaid view of these surfaces and how a derived repo relates to them.

## Network posture

This template has **no networked runtime**. There is nothing to put on a VPC, CDN, or service mesh diagram. Consumers **must** add a network diagram when they introduce networked or cloud systems. See [network-diagram.md](network-diagram.md) for the explicit note and a consumer-owned Mermaid stub.

## Related decisions

- [ADR-001: GitHub-native free-first repository template](../decisions/ADR-001-github-native-template.md)

## What is intentionally out of scope here

- Application source, sample services, or fake “hello world” stacks
- Live CI badges or workflow claims before workflows exist
- Network or deployment diagrams for infrastructure that is not in this repo
