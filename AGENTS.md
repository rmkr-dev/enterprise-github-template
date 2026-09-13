# Agent and human guardrails

Read this file before you change this repository. These rules apply to people and to coding agents. The template exists so new repos start with the same bar; do not weaken it in a generated project without an explicit decision.

## Before you write code

1. Read `README.md`, this file, and the docs that touch your change (`docs/architecture/`, `docs/decisions/`, `docs/development/`, `docs/security/`).
2. State the slice you are completing. If the work is larger than one reviewable PR, split it.
3. Prefer the smallest change that is **correct and complete** for that slice. Do not “while you’re here” refactor.

## Human-first

- Write for a reviewer who was not in the session: commit messages, PR body, and docs must stand alone.
- Do not leave the human to reverse-engineer intent from a dump of files.
- High-impact changes (license, security defaults, CI required checks, public API, data handling) need **human approval** before merge. An agent may draft; a person decides.

## Complete across layers

A slice is not done if you updated only one layer. When the change needs them, update together:

- behavior (code)
- tests
- CI / repo automation
- docs that describe the behavior
- architecture or an ADR, if the shape of the system changed

Do not add a file that nothing references, or a doc that describes a file that does not exist.

## No orphans, no speculation, no fakes

- **No orphans:** every new doc, script, or workflow has a reader and a reason. Remove or update callers when you delete something.
- **No speculative engineering:** do not add frameworks, sample apps, extra tools, or “future-proof” abstractions for slices that are not in scope.
- **No fake implementations:** no stub functions that pretend to work, no badges for CI that is not running, no architecture diagrams of systems that are not in this repo.
- **Docs match reality.** If a feature is planned, say it is planned. This repo is a template; do not describe a production application that is not here.

## Tests and CI are first-class

CI runs on GitHub Actions for this template: required-file validation and a small test around that validator. There is no application build.

- **GitHub Actions first.** Do not introduce another CI system unless an ADR explains why Actions cannot do the job.
- **GitHub Free-first.** Workflows and required checks must be viable on a free GitHub plan. Do not depend on paid GitHub features or third-party secrets to get a green default pipeline.
- When you add or rename required files, update `scripts/validate-template.sh` in the same PR.
- When application code exists later, tests ship in the same PR as the behavior and CI stays the default way those tests run.

## Security by default

- No secrets in the repo, in examples, or in commit messages.
- Least privilege for tokens and workflow permissions.
- Dependabot (Actions) and CodeQL (Actions language) are part of this template’s defaults; extend them when application languages appear.
- Report template vulnerabilities per [SECURITY.md](SECURITY.md). Treat `docs/security/security.md` as the consumer-facing posture and update it when defaults change.

## Docs and architecture

- User-facing or contributor-facing behavior needs a doc update in the same PR.
- System shape lives in `docs/architecture/`. Significant choices (tooling, auth, data stores, CI policy) get an ADR under `docs/decisions/`. See [docs/decisions/README.md](docs/decisions/README.md).
- Network diagrams are out of scope unless the consumer’s system has a network to document. See [docs/architecture/network-diagram.md](docs/architecture/network-diagram.md).

## Definition of done

A change is done when all of the following are true:

- [ ] Scope matches the agreed slice; nothing extra landed “for later convenience”
- [ ] Behavior, tests, automation, and docs that this slice requires are present and consistent
- [ ] No secrets, personal contact details, or leftover placeholders that claim to be finished
- [ ] `README.md` and any linked docs still describe the repo as it is
- [ ] Significant decisions have an ADR
- [ ] High-impact items are called out for a human reviewer
- [ ] Local validation passes when scripts apply (`bash scripts/validate-template.sh`)
- [ ] You could merge this PR and leave the repo coherent if no further PR ever shipped

## Final self-review

Before you ask for review:

1. Diff the PR as a stranger. Is anything unexplained?
2. Grep for names of files you added. Are they linked from `README.md` or the right `docs/` index?
3. Confirm you did **not** add Node/npm or sample app code unless that was the slice.
4. Confirm commit messages are conventional (`feat:`, `docs:`, `ci:`, `chore:`, …) and read like a person wrote them.
5. Re-read this file and `docs/development/development.md`. Fix anything that now contradicts them.
