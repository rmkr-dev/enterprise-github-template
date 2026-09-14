# Development

This document is how people (and agents) work **on this template**. After you create a repo from the template, replace the product-specific parts; keep the working agreements unless you record a new ADR.

## Prerequisites

- Git and a GitHub account
- `bash` (for the local template validator)
- No Node/npm. Do not add other runtimes unless a later application slice needs them.
- Editor defaults: `.editorconfig` (LF, UTF-8, 2-space indent). `.gitattributes` normalizes text to LF.

## Support routing

See [SUPPORT.md](../../SUPPORT.md) for where bugs, features, security, and conduct reports should go. Prefer issue forms over blank issues.

## Branching and review

- Branch from `main`. One concern per branch and pull request.
- Conventional commits (`docs:`, `feat:`, `ci:`, `chore:`, `fix:`). Messages should read as if a person typed them; no tool or agent footers.
- PRs say what slice landed and what is still out of scope. Use the pull request template checklist.
- Starter tasks: see **good first issue** guidance in [CONTRIBUTING.md](../../CONTRIBUTING.md) and the matching issue form.
- High-impact changes wait for a human approval. See [AGENTS.md](../../AGENTS.md).

## Local validation

From the repository root:

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
# optional: preview release notes body for a version
bash scripts/extract-changelog-section.sh 0.3.5
```

The validator checks that required template files exist (including CODEOWNERS, SECURITY.md, CHANGELOG.md, ADRs, and workflow YAML), workflow `on:` / `jobs:` / checkout are present, CODEOWNERS names an owner, SECURITY.md has private reporting / supported-versions / no-public-disclosure guidance, CHANGELOG has `[Unreleased]` and a versioned section, each ADR declares `Status:`, Mermaid fences exist in the architecture diagram docs, and relative Markdown links resolve. The test script asserts the happy path plus negative cases (missing file, empty CODEOWNERS, weak SECURITY.md, broken CHANGELOG/ADR/workflow shape).

## CI (GitHub Actions)

On every pull request and every push to `main`:

| Workflow | What it does |
| --- | --- |
| [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) | Runs `scripts/validate-template.sh` and `tests/test_validate_template.sh` (plus `bash -n` + ShellCheck); also `workflow_dispatch` |
| [`.github/workflows/codeql.yml`](../../.github/workflows/codeql.yml) | CodeQL analysis for GitHub Actions workflow YAML (`actions` language), also on a weekly schedule |
| [`.github/workflows/release.yml`](../../.github/workflows/release.yml) | Creates a GitHub Release when a `v*` tag is pushed; embeds matching CHANGELOG section |
| [`.github/workflows/dependency-review.yml`](../../.github/workflows/dependency-review.yml) | Dependency review on pull requests |
| [`.github/workflows/scorecard.yml`](../../.github/workflows/scorecard.yml) | OpenSSF Scorecard on `main` pushes and weekly schedule |

Also on a **weekly schedule** (and `workflow_dispatch`):

| Workflow | What it does |
| --- | --- |
| [`.github/workflows/validate-scheduled.yml`](../../.github/workflows/validate-scheduled.yml) | Same template validator + tests + `bash -n`/ShellCheck as CI, without waiting for a PR |

Dependabot opens **weekly** PRs for GitHub Actions updates (`.github/dependabot.yml`; validator forbids daily/monthly and requires `groups:`), grouped into a single Actions PR when possible. `CODEOWNERS` routes reviews to `@rmkr-dev`. CI, CodeQL, and dependency-review workflows use `concurrency` groups so superseded runs on the same ref cancel in progress. Every workflow checkout sets `persist-credentials: false`. Third-party Actions are pinned to commit SHAs (ADR-005).

There is **no application build** in this repository. CI is intentionally limited to template hygiene checks.

Recommended branch protection and required check names: [branch-protection.md](../operations/branch-protection.md).

## Working on a slice

1. Read [AGENTS.md](../../AGENTS.md) and the docs you will touch.
2. Change the smallest set of files that leaves the repo consistent.
3. Update indexes (`README.md`, folder READMEs) when you add or remove docs.
4. If you add a required file, also add it to `scripts/validate-template.sh`.
5. Note consumer-visible template changes in [CHANGELOG.md](../../CHANGELOG.md) (Unreleased).
6. If the decision is significant, add an ADR under `docs/decisions/`.
7. Run the local validation commands before opening the PR.

## First week after copying

Consumers who just used **Use this template** can follow [first-week.md](first-week.md) for a Day-0 / honesty-pass / first-slice checklist (docs only). Later, adopt upstream template releases with [upgrading-from-upstream.md](../operations/upgrading-from-upstream.md).

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

## Related

- [First-week checklist](first-week.md)
- [Upgrading from upstream](../operations/upgrading-from-upstream.md)
- [AGENTS.md](../../AGENTS.md)
