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
      Dec["decisions/<br/>ADRs"]
      Dev["development/"]
      Sec["security/"]
    end

    subgraph github[".github/"]
      WF["workflows/<br/>ci.yml, codeql.yml"]
      Dep["dependabot.yml"]
      Hygiene["CODEOWNERS, ISSUE_TEMPLATE,<br/>PULL_REQUEST_TEMPLATE"]
    end

    subgraph tooling["Validation"]
      Script["scripts/validate-template.sh"]
      Tests["tests/test_validate_template.sh"]
    end

    subgraph config["Repo config surfaces"]
      Editor[".editorconfig"]
      GitAttr[".gitattributes"]
      License["LICENSE"]
    end
  end

  Human --> README
  Agents --> AGENTS
  Human --> AGENTS
  README --> docs
  AGENTS --> docs
  WF --> Script
  Script --> Tests
  Derived -.->|"inherits copy of"| template
```

## How to read it

- **Consumers** (people and agents) enter through `README.md` and `AGENTS.md`.
- **`docs/`** holds the lasting description of architecture, decisions, development practice, and security posture.
- **`.github/`** runs template validation and CodeQL on Actions YAML, plus Dependabot and community templates.
- **`scripts/` / `tests/`** are the only “runtime” in this repo: shell checks invoked by CI and locally.
- A **derived repository** gets a snapshot of these files; it does not stay coupled to upstream template updates unless the consumer chooses to merge them later.
