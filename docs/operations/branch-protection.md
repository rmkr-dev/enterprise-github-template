# Branch protection (recommended)

This template does **not** configure branch protection via API (org/plan settings vary). After you create a repo from the template—or on this template itself—consider these GitHub settings on `main`:

## Suggested rules

| Setting | Recommendation |
| --- | --- |
| Require a pull request before merging | On |
| Require approvals | At least 1 for shared repos; optional for solo |
| Require status checks to pass | On — include **Validate template** and **Shell syntax check**; include **CodeQL** / **Analyze Actions workflows** when available |
| Require branches to be up to date | On when practical |
| Restrict force pushes / deletions | On |
| Require conversation resolution | On |

## Status check names

Exact check names come from workflow `name:` / job `name:` fields:

- `Validate template (ubuntu-latest)` from `.github/workflows/ci.yml`
- `Shell syntax check` from `.github/workflows/ci.yml`
- `Analyze Actions workflows` from `.github/workflows/codeql.yml`

Re-check the Actions UI after renaming jobs.

## Template vs derived repo

- On **this** template: protection keeps docs and CI honest.
- On a **derived** product repo: keep these checks until you replace them with application build/test jobs; then update required checks to match.

Do not document paid-only rules as required defaults.
