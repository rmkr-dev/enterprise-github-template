# Examples: evolving a derived repository

This template is **not** a sample application. After **Use this template**, the derived repo should grow into a real product in small, honest slices. The sketches below show a reasonable order for **Java** and **Python** consumers. They are guidance, not files that ship in this template.

## Shared first steps (any language)

1. Rewrite `README.md` for the product; keep the `docs/` layout unless an ADR records a change.
2. Replace `docs/architecture/architecture.md` and the Mermaid diagrams with the real system.
3. Keep `AGENTS.md`, `SECURITY.md`, CODEOWNERS, and the shell validator until you deliberately replace them.
4. Add application code **before** inventing language-specific CI that pretends to build something that is not there.
5. Note consumer-visible changes in `CHANGELOG.md` (Unreleased) while the product is young; later, follow your own release cadence.

## Java sketch

Typical order after the shared steps:

| Slice | What lands | What stays honest |
| --- | --- | --- |
| 1. Module skeleton | `pom.xml` or Gradle build, package layout, no fake endpoints | Docs say “library/service skeleton,” not “production API” |
| 2. Tests | JUnit (or equivalent) for real behavior | CI job runs those tests only after they exist |
| 3. App CI | Workflow job: checkout → JDK setup → `mvn test` / Gradle test | Keep template `validate-template` until you drop or adapt it |
| 4. Supply chain | Dependabot `maven`/`gradle` ecosystem; extend CodeQL with `java` | Do not claim Scorecard/CodeQL coverage you have not enabled |
| 5. Architecture | Update ADRs for build tool, packaging, and deploy target | Network diagram only when networked components exist |

Do **not** add Node/npm to run docs or Markdown lint in a Java-derived repo unless the product itself needs Node.

## Python sketch

Typical order after the shared steps:

| Slice | What lands | What stays honest |
| --- | --- | --- |
| 1. Package layout | `pyproject.toml` (or equivalent), `src/` package, no stub CLI that claims features | README describes what the package actually does |
| 2. Tests | `pytest` (or equivalent) for real behavior | CI runs pytest only after tests exist |
| 3. App CI | Workflow job: checkout → Python setup → install → pytest | Retain or retire template validation deliberately |
| 4. Supply chain | Dependabot `pip` ecosystem; extend CodeQL with `python` | Pin or lock deps per your risk tolerance; document it |
| 5. Architecture | ADRs for packaging, typing, and runtime (service vs library) | No containers/K8s diagrams until those artifacts exist |

Prefer the language’s native tooling. Do not introduce Node/npm solely for documentation.

## What not to copy from these sketches into the template

- Sample `pom.xml`, `pyproject.toml`, or application source
- Language package managers or lockfiles in **this** template repository
- Fake “hello world” services added only to make CI look busy

Application files belong in the **derived** repository, in PRs that also update that repo’s docs and CI.

## Related

- [README](../../README.md) — how to use this template
- [Architecture](../architecture/architecture.md) — what this template is today
- [Development](../development/development.md) — local validation and CI on the template
- [ADR-001](../decisions/ADR-001-github-native-template.md) — why there is no sample app here
