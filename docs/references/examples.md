# Examples: evolving a derived repository

This template is **not** a sample application. After **Use this template**, the derived repo should grow into a real product in small, honest slices. The sketches below show a reasonable order for **Java**, **Python**, **Go**, **Rust**, **.NET/C#**, and **Azure/AKS** consumers. They are guidance, not files that ship in this template.

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

## Go sketch

Typical order after the shared steps:

| Slice | What lands | What stays honest |
| --- | --- | --- |
| 1. Module skeleton | `go.mod`, package layout, no fake HTTP handlers claiming production APIs | README describes the real module purpose |
| 2. Tests | `go test` for real behavior | CI runs tests only after they exist |
| 3. App CI | Workflow: checkout → Go setup → `go test ./...` | Keep or retire template validation deliberately |
| 4. Supply chain | Dependabot `gomod` ecosystem; extend CodeQL with `go` | Document module proxy / private module needs if any |
| 5. Architecture | ADRs for module boundaries and deploy target | No containers/K8s diagrams until those artifacts exist |

Prefer Go’s native tooling. Do not introduce Node/npm solely for documentation.

## Rust sketch

Typical order after the shared steps:

| Slice | What lands | What stays honest |
| --- | --- | --- |
| 1. Crate skeleton | `Cargo.toml`, `src/` library or binary, no fake HTTP server claiming production APIs | README describes the real crate purpose |
| 2. Tests | `cargo test` for real behavior | CI runs tests only after they exist |
| 3. App CI | Workflow: checkout → Rust toolchain → `cargo test` | Keep or retire template validation deliberately |
| 4. Supply chain | Dependabot `cargo` ecosystem; extend CodeQL with `rust` when available for your plan | Document lockfile and MSRV policy |
| 5. Architecture | ADRs for crate boundaries and deploy target | No containers/K8s diagrams until those artifacts exist |

Prefer Cargo and rustup. Do not introduce Node/npm solely for documentation.


## .NET / C# sketch

Typical order after the shared steps:

| Slice | What lands | What stays honest |
| --- | --- | --- |
| 1. Project skeleton | `.sln` / `.csproj` (or equivalent), package layout, no fake ASP.NET endpoints claiming production APIs | README describes the real library or service purpose |
| 2. Tests | `dotnet test` for real behavior | CI runs tests only after they exist |
| 3. App CI | Workflow: checkout → .NET setup → `dotnet test` | Keep or retire template validation deliberately |
| 4. Supply chain | Dependabot `nuget` ecosystem; extend CodeQL with `csharp` | Document TFM / LTS policy |
| 5. Architecture | ADRs for hosting model (library vs worker vs web) and deploy target | No containers/K8s diagrams until those artifacts exist |

Prefer the .NET SDK CLI. Do not introduce Node/npm solely for documentation.

## Azure / AKS sketch

Typical order after the shared steps, when the derived product will run on **Azure Kubernetes Service**. Docs-only guidance for consumers — this template still ships **no** manifests, Helm charts, or Terraform.

| Slice | What lands | What stays honest |
| --- | --- | --- |
| 1. Container boundary | Dockerfile (or equivalent) that builds the real app image; `.dockerignore` | README says “image build,” not “cluster deployed” until deploy exists |
| 2. App CI image job | Workflow: build (and optionally push to ACR) only after Dockerfile + tests exist | No fake `kubectl apply` against empty clusters |
| 3. Kubernetes manifests | Deployment/Service (plain YAML, Kustomize, or Helm) matching the image | Architecture/network diagrams updated only when components are real |
| 4. AKS deploy path | Documented target (manual `kubectl`, GitOps, or OIDC to Azure) with least-privilege identity | Do not commit Azure secrets; use OIDC / federated credentials when possible |
| 5. Supply chain + ops | Dependabot for the app ecosystem; extend CodeQL languages; note how rollbacks work | Scorecard/CodeQL claims match what is enabled; IR points at your runtime runbook |

### Honest constraints for AKS consumers

- Prefer **workload identity / OIDC** from GitHub Actions to Azure over long-lived client secrets in repository secrets.
- Keep environment-specific values (subscription, resource group, cluster name) out of the template defaults; document them in the derived repo.
- Network and trust-boundary diagrams belong under `docs/architecture/` only when ingress, private networking, or shared services actually exist.
- Do **not** copy sample AKS YAML into **this** template repository — it would be a fake app surface.

## What not to copy from these sketches into the template

- Sample `pom.xml`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `.csproj`/`.sln`, or application source
- Language package managers or lockfiles in **this** template repository
- Fake “hello world” services added only to make CI look busy
- Sample Dockerfile, Helm chart, Terraform, or AKS manifests in **this** template repository

Application files belong in the **derived** repository, in PRs that also update that repo’s docs and CI.

## Related

- [README](../../README.md) — how to use this template
- [Architecture](../architecture/architecture.md) — what this template is today
- [Development](../development/development.md) — local validation and CI on the template
- [ADR-001](../decisions/ADR-001-github-native-template.md) — why there is no sample app here
