# ADR-002: Validate the template in GitHub Actions CI

- Status: Accepted
- Date: 2026-09-13

## Context / Problem

This repository is a documentation and process template. Drift is the main failure mode: a required file disappears, a relative Markdown link breaks, CODEOWNERS loses an owner, or SECURITY.md loses a reporting path. Humans and coding agents both edit the tree; without an automated gate, `main` can look “complete” while the template is no longer safe to copy.

We already prefer GitHub Actions and GitHub Free. The question is how strictly CI should enforce template hygiene.

## Options

1. **Docs-only, no CI gate** — Trust reviewers to catch missing files and broken links. Lowest setup cost; highest drift risk.
2. **Local scripts only** — Ship `scripts/validate-template.sh` but do not run it in Actions. Helps careful contributors; does nothing for drive-by PRs.
3. **Validate required files and links in Actions on every PR and push to `main`** — Shell-based checks, no extra language runtime, Free-plan runners.
4. **Heavyweight doc toolchain** — Introduce Node/npm (or similar) for Markdown lint, link checkers, and site builds. Stronger tooling, but violates the template’s no-Node default and adds supply-chain surface.

## Decision

Choose **option 3**: run `scripts/validate-template.sh` (and its tests) in GitHub Actions CI on pull requests and pushes to `main`. Expand checks over time (workflows present, CODEOWNERS owner, SECURITY reporting path, at least one ADR, Mermaid fences) without introducing Node/npm.

## Rationale

- Matches ADR-001 (GitHub-native, free-first, honest template).
- Shell + `ubuntu-latest` stays within GitHub Free and avoids a package manager for docs.
- Failures are actionable: missing path, broken link, or empty policy file.
- Tests around the validator catch regressions in the check script itself.

## Consequences

- Every PR that removes or renames a required file must update the validator in the same change.
- CI stays green only if docs and structure stay coherent—intentional friction.
- We still do not build or test an application in this repository; application CI belongs in derived repos.
- CodeQL remains separate and focused on Actions workflow YAML.

## Related

- [ADR-001: GitHub-native free-first repository template](ADR-001-github-native-template.md)
- [Development](../development/development.md)
- [Architecture](../architecture/architecture.md)
- [ADR-003: Weekly scheduled template validation](ADR-003-weekly-scheduled-validation.md)
