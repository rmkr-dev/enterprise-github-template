# Development

This document is how people (and agents) work **on this template**. After you create a repo from the template, replace the product-specific parts; keep the working agreements unless you record a new ADR.

## Prerequisites

- Git and a GitHub account
- `bash` (for the local template validator)
- No Node/npm. Do not add other runtimes unless a later application slice needs them.

## Support routing

See [SUPPORT.md](../../SUPPORT.md) for where bugs, features, security, and conduct reports should go. Prefer issue forms over blank issues.

## Branching and review

- Branch from `main`. One concern per branch and pull request.
- Conventional commits (`docs:`, `feat:`, `ci:`, `chore:`, `fix:`). Messages should read as if a person typed them; no tool or agent footers.
- PRs say what slice landed and what is still out of scope. Use the pull request template checklist.
- High-impact changes wait for a human approval. See [AGENTS.md](../../AGENTS.md).

## Local validation

From the repository root:

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
```

The validator checks that required template files exist, Mermaid fences are present in the architecture diagram docs, and relative Markdown links resolve. The test script asserts the happy path and a deliberate missing-file failure.

## CI (GitHub Actions)

On every pull request and every push to `main`:

| Workflow | What it does |
| --- | --- |
| [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) | Runs `scripts/validate-template.sh` and `tests/test_validate_template.sh` |
| [`.github/workflows/codeql.yml`](../../.github/workflows/codeql.yml) | CodeQL analysis for GitHub Actions workflow YAML (`actions` language), also on a weekly schedule |

Dependabot opens weekly PRs for GitHub Actions action updates (`.github/dependabot.yml`). `CODEOWNERS` routes reviews to `@rmkr-dev`.

There is **no application build** in this repository. CI is intentionally limited to template hygiene checks.

## Working on a slice

1. Read [AGENTS.md](../../AGENTS.md) and the docs you will touch.
2. Change the smallest set of files that leaves the repo consistent.
3. Update indexes (`README.md`, folder READMEs) when you add or remove docs.
4. If you add a required file, also add it to `scripts/validate-template.sh`.
5. Note consumer-visible template changes in [CHANGELOG.md](../../CHANGELOG.md) (Unreleased).
6. If the decision is significant, add an ADR under `docs/decisions/`.
7. Run the local validation commands before opening the PR.

## Template flag status

The GitHub **template repository** flag is **enabled** on `rmkr-dev/enterprise-github-template`. Consumers can create a new repository with **Use this template** from the GitHub UI. Maintainers should keep that flag on unless an ADR records turning it off.

## What this template does not have yet

- Application source or a sample service
- Language-specific build/test jobs (add those in the derived repo when application code lands)

## After you copy the template

1. Rewrite `README.md` for the product.
2. Fill `docs/architecture/architecture.md` and update diagrams for real components.
3. Add ADRs as you choose stack and hosting.
4. Extend Actions with language-specific test/build jobs when application code arrives — keep Free-plan defaults and least-privilege permissions.
