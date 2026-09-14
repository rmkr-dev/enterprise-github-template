# Architecture diagram

Mermaid diagram-as-code for the **current** template. Boxes are files and process surfaces that exist in the tree, not a fictional application.

```mermaid
flowchart TB
  subgraph consumers["Template consumers"]
    Human["Humans / maintainers"]
    Agents["Coding agents"]
    Derived["Derived repository<br/>(Use this template / clone)"]
  end

  subgraph template["enterprise-github-template"]
    README["README.md"]
    AGENTS["AGENTS.md"]
    Contrib["CONTRIBUTING.md"]
    SecRoot["SECURITY.md"]

    subgraph docs["docs/"]
      Arch["architecture/<br/>architecture.md + diagrams"]
      Dec["decisions/<br/>ADRs (ADR-001, ADR-002)"]
      Dev["development/"]
      Sec["security/"]
      Ops["operations/<br/>(IR + troubleshooting / secrets-and-oidc)"]
      Refs["references/<br/>consumer examples"]
    end

    subgraph github[".github/"]
      WF["workflows/<br/>ci, validate-scheduled,<br/>codeql, dependency-review,<br/>scorecard, release"]
      Dep["dependabot.yml"]
      Hygiene["CODEOWNERS, ISSUE_TEMPLATE<br/>(incl. good first issue),<br/>PULL_REQUEST_TEMPLATE"]
    end

    subgraph tooling["Validation in CI"]
      Script["scripts/validate-template.sh"]
      Tests["tests/test_validate_template.sh"]
      Actions["GitHub Actions CI<br/>runs validator + tests"]
    end

    subgraph config["Repo config surfaces"]
      Editor[".editorconfig"]
      GitAttr[".gitattributes"]
      License["LICENSE"]
      Changelog["CHANGELOG.md"]
    end
  end

  Human --> README
  Agents --> AGENTS
  Human --> AGENTS
  README --> docs
  AGENTS --> docs
  WF --> Actions
  Actions --> Script
  Script --> Tests
  Derived -.->|"inherits copy of"| template
```

## How to read it

- **Consumers** (people and agents) enter through `README.md` and `AGENTS.md`.
- **`docs/`** holds the lasting description of architecture, decisions (including why validation runs in CI), development practice, and security posture.
- **`.github/workflows/ci.yml`** and **`validate-scheduled.yml`** invoke the validate script and its tests on every PR, every push to `main`, and weekly (see ADR-002).
- **`scripts/` / `tests/`** are the only “runtime” in this repo: shell checks invoked by Actions and locally.
- A **derived repository** gets a snapshot of these files; it does not stay coupled to upstream template updates unless the consumer chooses to merge them later.
