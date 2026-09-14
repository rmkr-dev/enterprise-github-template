# ADR-006: CHANGELOG-backed GitHub Releases

- Status: Accepted
- Date: 2026-09-14

## Context / Problem

Template releases used to create GitHub Releases with a short static preamble that only pointed at `CHANGELOG.md`. Consumers opening the Releases tab did not see the version body without clicking into the file. Maintainers could also tag before the matching `## [X.Y.Z]` section existed, producing empty or misleading notes.

We already require Keep-a-Changelog structure in CI (`[Unreleased]` + versioned sections). The release workflow should reuse that source of truth.

## Options

1. **Static release notes only** — short preamble; humans must open CHANGELOG. Simple; weak Releases UX.
2. **CHANGELOG section extract into release notes** — `scripts/extract-changelog-section.sh` copies the matching `## [X.Y.Z]` body into `gh release create` notes. One source of truth; tagging requires the section to exist first.
3. **Generated notes from git log** — `gh release create --generate-notes`. Noisy for this template’s multi-commit hygiene PRs; drifts from Keep-a-Changelog.

## Decision

Choose **option 2**: GitHub Release notes for `v*` tags include a short template preamble plus the matching Keep-a-Changelog section extracted by `scripts/extract-changelog-section.sh`.

## Rationale

- Matches how consumers already read history (`CHANGELOG.md`).
- Keeps shell-only tooling (ADR-004) and SHA-pinned Actions (ADR-005).
- Validator can require the helper and CHANGELOG references in `release.yml`.

## Trade-offs

| Benefit | Cost |
| --- | --- |
| Releases tab shows the same bullets as CHANGELOG | Maintainers must move Unreleased notes before tagging |
| Single source of truth | Extract helper must stay executable and ShellCheck-clean |
| Works on GitHub Free | No fancy changelog generators |

## Consequences

- Release prep PRs move Unreleased items into `## [X.Y.Z]` before the annotated tag.
- Do not replace the extract helper with `--generate-notes` without superseding this ADR.
- Missing sections yield an explicit placeholder note rather than a failed release (tag still verifies via `--verify-tag`).
