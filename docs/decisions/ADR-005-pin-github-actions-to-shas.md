# ADR-005: Pin GitHub Actions to commit SHAs

- Status: Accepted
- Date: 2026-09-14

## Context / Problem

Template workflows referenced third-party actions by mutable tags (`@v7`, `@v4`, `@v2.4.4`). Tags can move. A compromised or retagged action would run on this repository and on every derived repo that copied the workflow. OpenSSF Scorecard’s Pinned-Dependencies check flags unpinned Actions. Dependabot already updates GitHub Actions weekly, including SHA-pinned `uses:` lines when a version comment is present.

This template’s only executable surface is GitHub Actions YAML plus Bash. Pinning is the highest-leverage remaining supply-chain control that stays GitHub-native and GitHub Free.

## Options

1. **Keep floating tags** — shortest YAML; Dependabot still bumps majors/minors; tags can be moved without a PR.
2. **Pin to commit SHA, comment the intended tag** — `uses: owner/action@<40-hex>  # vX.Y.Z`. Immutable at merge time; humans and Dependabot still see the version.
3. **Vendor action source into this repo** — strongest isolation; high maintenance and out of scope for a docs/CI template.

## Decision

Choose **option 2**: every third-party `uses:` line in `.github/workflows/` must pin a 40-character lowercase commit SHA and include a `#` comment with the intended version tag. Local actions (`uses: ./...`) are allowed without a SHA.

## Rationale

- Matches Scorecard Pinned-Dependencies and GitHub’s own hardening guidance for Actions.
- Keeps ADR-001 (GitHub-native, free-first) and ADR-004 (no Node/npm toolchain).
- Dependabot’s `github-actions` ecosystem can open PRs that bump both SHA and comment together.
- Derived repos inherit a safer default than `@vN` copies.

## Trade-offs

| Benefit | Cost |
| --- | --- |
| Immutable action bits at merge | YAML is noisier; first-time readers need the comment |
| Scorecard / supply-chain signal | Manual edits must copy SHAs, not just `v7` |
| Dependabot still works | Grouped Actions PRs may touch every workflow at once |

## Consequences

- Template validator fails if a third-party `uses:` line is not SHA-pinned or lacks a version comment.
- Do not revert to `@v`, `@main`, or `@master` to “make Dependabot simpler.”
- When adding an action, record the resolved commit SHA of the release tag (peel annotated tags) and the tag in the comment.
- Private/derived repos should keep the pin when they copy workflows.
