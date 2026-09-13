# Enterprise GitHub Template

A GitHub-native starting point for public and private repositories that need the same baseline: human-first engineering standards, architecture and decision docs, security defaults, and CI that runs on GitHub Actions.

This repository is the **template**, not an application. Use it to bootstrap a new repo, then replace placeholders with the product you are actually building.

## Why this exists

Most new repos accumulate process after the fact: a README that goes stale, CI copied from the last project, and no written architecture. This template inverts that. The first files you get are the ones that keep humans and coding agents aligned:

- what “done” means
- where architecture and decisions live
- how to change the repo without leaving orphans or fake implementations
- a small Actions pipeline that validates the template itself (not a fake app build)

## How to use it as a GitHub template

The **template repository** flag is enabled on this repo today. **Use this template** works now — you do not need to wait for a later publish step.

1. On GitHub, open this repository and choose **Use this template** → **Create a new repository**.
2. Clone your new repo.
3. Rewrite this README for the product. Keep the `docs/` layout unless you have a reason to change it.
4. Fill in `docs/architecture/architecture.md` for the real system. Add ADRs when you make significant decisions.
5. Add application code and language-specific workflows in later commits — do not invent a sample app here just to look complete.

You can still clone or fork this repo and treat it the same way. Prefer **Use this template** when you want a clean history without this template’s commit log.

## Technology stance

**GitHub-native and GitHub Free-first.** Prefer features that work on a free personal or organization account:

| Use | Avoid as a default |
| --- | --- |
| GitHub Actions, Issues, Projects, Discussions as needed | Third-party CI as the primary pipeline |
| Markdown docs in the repo | Wiki-only or undocumented Slack process |
| Dependabot / CodeQL | Paid scanners required to merge |
| Shell-based template validation | Adding Node/npm only to run docs or lint Markdown |

Do not introduce Node, npm, or other runtimes in this template unless a later application slice actually needs them.

## Repository structure

```text
.
├── AGENTS.md                 # Read before changing code or docs
├── CONTRIBUTING.md           # How to propose changes
├── SECURITY.md               # Vulnerability reporting for this template
├── CHANGELOG.md              # Template release history
├── LICENSE
├── README.md                 # You are here
├── scripts/                  # Template validation (used by CI)
├── tests/                    # Checks for the validator
├── .github/                  # Actions, Dependabot, community templates
└── docs/
    ├── architecture/         # Current system + diagrams
    ├── decisions/            # Architecture Decision Records
    ├── development/          # Contributor workflow
    ├── operations/           # Maintainer ops + release process
    └── security/             # Security posture for template consumers
```

## Local checks and CI

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
```

GitHub Actions runs those same checks on pull requests and pushes to `main`. CodeQL analyzes Actions workflow YAML. Details: [docs/development/development.md](docs/development/development.md).

## Documentation

| Doc | Purpose |
| --- | --- |
| [AGENTS.md](AGENTS.md) | Guardrails for humans and coding agents |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to open a change |
| [SECURITY.md](SECURITY.md) | How to report vulnerabilities |
| [Development](docs/development/development.md) | Local validation and what CI does |
| [Architecture overview](docs/architecture/README.md) | How architecture docs are organized |
| [Current architecture](docs/architecture/architecture.md) | What this repo is today |
| [Architecture diagram](docs/architecture/architecture-diagram.md) | Mermaid view of template surfaces |
| [Network diagram note](docs/architecture/network-diagram.md) | No runtime network; consumer stub |
| [Decisions](docs/decisions/README.md) | When and how to write an ADR |
| [ADR-001](docs/decisions/ADR-001-github-native-template.md) | Why GitHub-native free-first |
| [Security](docs/security/security.md) | Baseline security expectations |
| [Operations](docs/operations/README.md) | Maintainer ops for this template |
| [Release process](docs/operations/release-process.md) | Tagging and template releases |
| [Changelog](CHANGELOG.md) | Notable template changes |

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md) before you edit. Changes should be the smallest complete slice that leaves docs, structure, and tests consistent.

## License

[MIT](LICENSE)
