# Enterprise GitHub Template

A GitHub-native starting point for public and private repositories that need the same baseline: human-first engineering standards, architecture and decision docs, security defaults, and (in later slices) CI that runs on GitHub Actions.

This repository is the **template**, not an application. Use it to bootstrap a new repo, then replace placeholders with the product you are actually building.

## Why this exists

Most new repos accumulate process after the fact: a README that goes stale, CI copied from the last project, and no written architecture. This template inverts that. The first files you get are the ones that keep humans and coding agents aligned:

- what “done” means
- where architecture and decisions live
- how to change the repo without leaving orphans or fake implementations

Automation (workflows, dependency updates, security scanning) is intentionally **not** in this slice. Those land in follow-up PRs so each piece can be reviewed on its own.

## How to use it as a GitHub template

The repo is not marked as a GitHub template yet. When it is:

1. On GitHub, choose **Use this template** → **Create a new repository**.
2. Clone your new repo.
3. Rewrite this README for the product. Keep the `docs/` layout unless you have a reason to change it.
4. Fill in `docs/architecture/architecture.md` for the real system. Add ADRs when you make significant decisions.
5. Add application code, tests, and workflows in later commits — do not invent a sample app here just to look complete.

Until the template flag is on, you can still clone or fork this repo and treat it the same way.

## Technology stance

**GitHub-native and GitHub Free-first.** Prefer features that work on a free personal or organization account:

| Use | Avoid as a default |
| --- | --- |
| GitHub Actions, Issues, Projects, Discussions as needed | Third-party CI as the primary pipeline |
| Markdown docs in the repo | Wiki-only or undocumented Slack process |
| Dependabot / CodeQL when those slices land | Paid scanners required to merge |
| Language-native tooling | Adding Node/npm only to run docs or lint Markdown |

Do not introduce Node, npm, or other runtimes in this template unless a later application slice actually needs them.

## Repository structure

```text
.
├── AGENTS.md                 # Read before changing code or docs
├── CONTRIBUTING.md           # How to propose changes
├── LICENSE
├── README.md                 # You are here
└── docs/
    ├── architecture/         # Current system + diagrams
    ├── decisions/            # Architecture Decision Records
    ├── development/          # Contributor workflow
    └── security/             # Security posture for template consumers
```

Later slices are expected to add `.github/` (workflows, issue/PR templates, Dependabot), then application code and tests. Do not assume those directories exist today.

## Documentation

| Doc | Purpose |
| --- | --- |
| [AGENTS.md](AGENTS.md) | Guardrails for humans and coding agents |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to open a change |
| [Development](docs/development/development.md) | Day-to-day contributor workflow |
| [Architecture overview](docs/architecture/README.md) | How architecture docs are organized |
| [Current architecture](docs/architecture/architecture.md) | What this repo is today |
| [Architecture diagram](docs/architecture/architecture-diagram.md) | Mermaid view of template surfaces |
| [Network diagram note](docs/architecture/network-diagram.md) | No runtime network; consumer stub |
| [Decisions](docs/decisions/README.md) | When and how to write an ADR |
| [ADR-001](docs/decisions/ADR-001-github-native-template.md) | Why GitHub-native free-first |
| [Security](docs/security/security.md) | Baseline security expectations |

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md) before you edit. Changes should be the smallest complete slice that leaves docs, structure, and (when they exist) tests consistent.

## License

[MIT](LICENSE)
