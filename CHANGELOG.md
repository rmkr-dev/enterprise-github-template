# Changelog

All notable changes to this **template repository** are listed here. Versions refer to tagged snapshots of the template, not an application API.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for template releases.

## [Unreleased]

### Added

- Release workflow (`.github/workflows/release.yml`) for `v*` tags
- Contributor Covenant (`CODE_OF_CONDUCT.md`), `SUPPORT.md`, and improved issue forms
- Operations guide (`docs/operations/`) and release process documentation
- Changelog for template consumers and maintainers
- Stronger template validation (workflows, CODEOWNERS, SECURITY, ADR presence) and a CI shell-syntax job

### Changed

- Development and architecture docs record that the GitHub template flag is enabled

## [0.1.0] — TBD

Baseline public template: GitHub-native docs layout, `AGENTS.md` guardrails, Actions CI for template validation, CodeQL for Actions YAML, Dependabot, and community issue/PR templates.

[Unreleased]: https://github.com/rmkr-dev/enterprise-github-template/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/rmkr-dev/enterprise-github-template/releases/tag/v0.1.0
