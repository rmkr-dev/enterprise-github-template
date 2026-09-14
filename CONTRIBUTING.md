# Contributing

Thanks for improving this template. Keep changes small, complete, and honest about what the repo actually contains.

## Read first

1. [AGENTS.md](AGENTS.md) — guardrails, definition of done, and self-review.
2. [docs/development/development.md](docs/development/development.md) — how work is sequenced on this repo.
3. The docs that your change touches under `docs/`.
4. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — expected behavior.
5. [SUPPORT.md](SUPPORT.md) — where questions and non-security reports go.

## Good first issues

Issues labeled **`good first issue`** are intentionally small and well-scoped for new contributors. Prefer those when you are learning the layout.

Maintainers: when filing starter work, apply:

| Label | Use when |
| --- | --- |
| `good first issue` | Clear steps, limited files, no design debate required |
| `documentation` | Docs-only or comment clarity |
| `help wanted` | Valuable but not on the critical path for a release |

Keep the issue body concrete: files to touch, acceptance checks (`bash scripts/validate-template.sh`), and what is out of scope. Do not use `good first issue` for CI redesigns, license changes, or security-default changes.

## How to propose a change

1. Branch from `main`.
2. Implement **one slice**. Update every layer that slice needs (docs, structure, and later tests/CI). Do not leave a half-described feature.
3. Use a conventional commit message (`docs:`, `feat:`, `chore:`, `fix:`, `ci:`). Write it as if a colleague will read it in `git log` a year from now.
4. Open a pull request against `main`. Say what slice this is, what is in scope, and what is explicitly out of scope.
5. If the slice changes user-visible template behavior, add a bullet under `CHANGELOG.md` `[Unreleased]`.

### Local checks before you open the PR

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
```

CI runs the same checks on pull requests, pushes to `main`, and on a weekly schedule.

## What we will not merge

- Speculative extras (sample apps, extra tooling, Node/npm) that the slice did not ask for
- Docs that describe CI, scanners, or product behavior that is not in the tree
- Secrets, personal contact details, or company-specific branding
- Drive-by reformatting of files you did not otherwise change
- Security-sensitive changes without a clear human review note in the PR

Questions about process belong in the pull request. Architecture-level choices belong in an ADR — see [docs/decisions/README.md](docs/decisions/README.md).

## Community

- Be excellent: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- Questions and support routing: [SUPPORT.md](SUPPORT.md)
- Vulnerabilities: [SECURITY.md](SECURITY.md) (private advisory — not public issues)
