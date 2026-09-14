# Changelog

All notable changes to this **template repository** are listed here. Versions refer to tagged snapshots of the template, not an application API.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for template releases.

## [Unreleased]

### Added

- Light incident-response checklist for template consumers (`docs/operations/incident-response.md`)
- Stronger `SECURITY.md` policy checks in the template validator (supported versions, private reporting, no public disclosure)
- Azure/AKS consumer evolution sketch in `docs/references/examples.md` (docs only)
- Weekly scheduled template validation workflow (`.github/workflows/validate-scheduled.yml`)
- Good-first-issue guidance in CONTRIBUTING and `.github/ISSUE_TEMPLATE/good_first_issue.yml`

### Changed

- Polished `SECURITY.md` with supported-versions table, advisory URL, response expectations, and clearer scope
- Expanded CONTRIBUTING with read-first links, label guidance, local checks, and security reporting pointer
- Architecture, operations, SUPPORT, and branch-protection docs synced for IR, weekly validate, and good-first-issue surfaces

## [0.2.0] — 2026-09-14

### Added

- Dependency review workflow on pull requests and OpenSSF Scorecard workflow (public, GitHub Free-friendly)
- `docs/references/examples.md` showing how derived Java/Python repos can evolve from this template
- Deeper template validation: CHANGELOG `[Unreleased]` + versioned sections, ADR `Status:` lines, workflow `on:` triggers; expanded negative tests
- `.gitignore` for editor/env/accidental build artifacts
- Branch protection checklist (`docs/operations/branch-protection.md`)
- CI and release badges on the README
- Dependabot grouping for GitHub Actions updates

### Changed

- PR template checklist covers CHANGELOG and community docs
- `AGENTS.md` and security docs point at operations, SUPPORT, and release-on-tag behavior

## [0.1.0] — 2026-09-13

### Added

- GitHub-native docs layout (`docs/architecture`, `docs/decisions`, `docs/development`, `docs/security`, `docs/operations`)
- `AGENTS.md` guardrails and CONTRIBUTING / SECURITY policies
- Actions CI for template validation (required files, links, CODEOWNERS, SECURITY, ADRs) plus shell-syntax job
- CodeQL for Actions workflow YAML and Dependabot for Actions
- Community files: issue forms, PR template, Contributor Covenant, SUPPORT.md
- Release workflow (`.github/workflows/release.yml`) for `v*` tags
- ADR-001 (GitHub-native free-first) and ADR-002 (validation in CI)
- Changelog and release/tagging documentation

### Changed

- Documented that the GitHub **template repository** flag is enabled and **Use this template** works now

[Unreleased]: https://github.com/rmkr-dev/enterprise-github-template/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.0
[0.1.0]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.1.0
