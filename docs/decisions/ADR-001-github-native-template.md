# ADR-001: GitHub-native free-first repository template

- Status: Accepted
- Date: 2026-09-13

## Context / Problem

New repositories often start with an empty tree or a one-off copy of the last project’s README. Process, security expectations, and architecture docs arrive late—if at all. Coding agents and humans then invent different conventions in the same repo.

We need a reusable starting point that:

- Works on **GitHub Free** (personal or organization) without paid features as a hard requirement
- Prefers **GitHub-native** tools (Actions, Issues, Dependabot, CodeQL when added) over third-party CI as the default pipeline
- Is honest about what exists: a template and docs first, not a fake sample application
- Gives humans and agents the same Definition of Done and doc layout from day one

## Options

1. **Empty repo + tribal knowledge** — Clone nothing; document standards in a wiki or chat. Fast to “start,” slow to align, easy for docs to drift.
2. **Full sample application template** — Ship a working app (web API, frontend, containers) plus CI. Looks complete, but locks language/stack choices and encourages fake or unused code in every derived repo.
3. **GitHub-native free-first docs/process template** — Ship README, `AGENTS.md`, `docs/` layout, and ADRs first; add Actions and hygiene files in small follow-up slices; leave application code to the consumer.
4. **Third-party platform template** — Standardize on an external CI/CD or portal as the source of truth. Stronger vendor lock-in; weaker default for public GitHub Free users.

## Decision

Choose **option 3**: maintain `enterprise-github-template` as a GitHub-native, free-first **repository template** focused on engineering standards, architecture/decision docs, and (in later slices) Actions-based automation—without embedding a sample application or requiring Node/npm for template maintenance.

## Rationale

- Matches how GitHub Free users actually work: Markdown in-repo, Actions for CI, Dependabot/CodeQL when those slices land.
- Keeps each PR reviewable: docs and process before CI, CI before application code.
- Avoids speculative stack choices that every consumer would delete.
- `AGENTS.md` and Definition of Done reduce orphan files and “docs that lie.”

## Trade-offs

| Benefit | Cost |
| --- | --- |
| Honest empty-of-app tree | Consumers must add their own stack |
| Free-plan viable defaults | Advanced GitHub Enterprise-only features are out of scope as defaults |
| Small incremental slices | Template looks “incomplete” until CI and app slices land |
| No Node/npm in the template | Doc lint/diagram tooling must stay shell/Markdown/Mermaid-based |

## Consequences

- Architecture docs describe the **template** until a consumer replaces them.
- CI, Dependabot, CodeQL, issue/PR templates, and `SECURITY.md` are expected follow-up slices—not claimed before they exist.
- Significant tooling or CI policy changes get a new ADR; this ADR stays as the founding choice.
- Derived repos may diverge; upstream template updates are opt-in merges, not automatic.
