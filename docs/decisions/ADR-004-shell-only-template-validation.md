# ADR-004: Shell-only template validation (no Node/npm)

- Status: Accepted
- Date: 2026-09-14

## Context / Problem

Template maintenance often drifts toward adding a Node/npm toolchain “just for” Markdown lint, link checks, or diagram generation. That introduces a second runtime into a repository that intentionally ships **no** application stack, raises the bar for GitHub Free contributors, and contradicts the technology stance in the root README and `AGENTS.md`.

We already validate the template with Bash (`scripts/validate-template.sh` and `tests/test_validate_template.sh`) on GitHub Actions. ADR-001 and ADR-002 established GitHub-native, free-first, no-sample-app defaults. This ADR records the **tooling** decision so later PRs do not re-litigate Node as a default.

## Options

1. **Add Node/npm for docs tooling** — prettier/markdownlint/mermaid-cli as CI jobs. Familiar to many teams; adds `package.json`, lockfiles, and a runtime consumers did not ask for.
2. **Shell + GitHub-native checks only** — keep Bash validator/tests, Actions workflows, and Mermaid-in-Markdown. No package manager in this template tree.
3. **Containerized docs lint image** — run lint via a public image without committing Node manifests. Still a hidden Node dependency and slower CI for little gain on this template’s surface area.

## Decision

Choose **option 2**: keep template validation and docs hygiene **shell-only** in this repository. Do not add Node, npm, yarn, pnpm, or equivalent package manifests to maintain the template.

## Rationale

- Matches ADR-001’s free-first, no-sample-app stance and the README “Avoid as a default” table.
- Contributors and agents can run the same checks locally with Bash alone.
- Derived repos remain free to introduce language toolchains when **their** product needs them; evolution sketches already say not to copy Node into this template for docs.

## Trade-offs

| Benefit | Cost |
| --- | --- |
| Zero package-manager surface in the template | No Prettier/markdownlint defaults |
| Fast, portable CI on GitHub Free runners | Richer docs lint must stay out of scope or live in derived repos |
| Clear rule for agents (`AGENTS.md`) | Occasional desire for JS-based link checkers must be declined or replaced with shell |

## Consequences

- PRs that add `package.json` / lockfiles solely for template docs or lint should be rejected unless a new ADR supersedes this one.
- Validator and tests remain Bash; CI continues to run them without language setup steps.
- Consumer sketches may mention language-native tooling; they must not imply Node is required for this template.
