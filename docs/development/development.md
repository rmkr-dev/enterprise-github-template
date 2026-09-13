# Development

This document is how people (and agents) work **on this template**. After you create a repo from the template, replace the product-specific parts; keep the working agreements unless you record a new ADR.

## Prerequisites

- Git and a GitHub account
- No language runtime is required for this slice. Do not add Node/npm (or any other toolchain) unless a later slice introduces application code that needs it.

## Branching and review

- Branch from `main`. One concern per branch and pull request.
- Conventional commits (`docs:`, `feat:`, `chore:`, `fix:`). Messages should read as if a person typed them; no tool or agent footers.
- PRs say what slice landed and what is still out of scope.
- High-impact changes wait for a human approval. See [AGENTS.md](../../AGENTS.md).

## Working on a slice

1. Read [AGENTS.md](../../AGENTS.md) and the docs you will touch.
2. Change the smallest set of files that leaves the repo consistent.
3. Update indexes (`README.md`, folder READMEs) when you add or remove docs.
4. If the decision is significant, add an ADR under `docs/decisions/`.

## What this template does not have yet

Do not document or depend on these until a later PR adds them:

- GitHub Actions workflows, Dependabot, CodeQL
- Issue and pull request templates, `CODEOWNERS`, a root `SECURITY.md`
- Application source, tests, or a sample service
- The GitHub “template repository” flag

Local verification for this slice is reading the docs against the tree: links resolve, and no doc claims a file that is missing.

## After you copy the template

1. Rewrite `README.md` for the product.
2. Fill `docs/architecture/architecture.md` and add a diagram when you have components.
3. Add ADRs as you choose stack and hosting.
4. Introduce language toolchain, tests, and Actions in that order — tests before you require CI to stay green.
