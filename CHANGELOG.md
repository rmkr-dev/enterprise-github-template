# Changelog

All notable changes to this **template repository** are listed here. Versions refer to tagged snapshots of the template, not an application API.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for template releases.

## [Unreleased]

### Added

### Changed

## [0.2.5] — 2026-09-14

### Added

- Go consumer evolution sketch in `docs/references/examples.md` (docs only)
- `workflow_dispatch` on CI for on-demand validation without a noop PR
- Consumer FAQ (`docs/references/faq.md`)

### Changed


## [0.2.4] — 2026-09-14

### Added

- Job `timeout-minutes` on CI, scheduled validate, and release workflows
- Concurrency group on OpenSSF Scorecard workflow
- Operations troubleshooting guide (`docs/operations/troubleshooting.md`)
- `.editorconfig` / `.gitattributes` required by the template validator

### Changed

- EditorConfig adds an explicit shell section; architecture diagram notes troubleshooting docs


## [0.2.3] — 2026-09-14

### Added

- Concurrency groups on CI, CodeQL, and dependency-review workflows (cancel superseded runs)
- Validator checks that those workflows declare `permissions:` and `concurrency:`
- First-week checklist for template consumers (`docs/development/first-week.md`)
- Workflow permissions table in `docs/security/security.md`

### Changed

- `.gitattributes` marks `*.sh` as LF text; CODEOWNERS documents default owner intent
- AGENTS and operations docs point at the workflow permissions table

## [0.2.2] — 2026-09-14

### Added

- ADR-003 documenting weekly scheduled template validation
- OpenSSF Scorecard badge on the README

### Changed

- Validator asserts `validate-scheduled.yml` declares `schedule` / `cron`
- PR template, security posture, and operations day-to-day notes mention weekly validate and Scorecard badge

## [0.2.1] — 2026-09-14

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

[Unreleased]: https://github.com/rmkr-dev/enterprise-github-template/compare/v0.2.5...HEAD
[0.2.5]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.5
[0.2.4]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.4
[0.2.3]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.3
[0.2.2]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.2
[0.2.1]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.1
[0.2.0]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.2.0
[0.1.0]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.1.0
