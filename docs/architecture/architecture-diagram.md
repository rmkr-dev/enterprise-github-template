# Architecture diagram

Mermaid diagram-as-code for the **current** template. Boxes are files and process surfaces that exist (or are planned and labeled as such), not a fictional application.

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

    subgraph docs["docs/"]
      Arch["architecture/<br/>architecture.md + diagrams"]
      Dec["decisions/<br/>ADRs"]
      Dev["development/"]
      Sec["security/"]
    end

    subgraph future[".github/ (future slice)"]
      WF["workflows/<br/>CI, CodeQL"]
      Dep["dependabot.yml"]
      Hygiene["CODEOWNERS, ISSUE_TEMPLATE,<br/>PULL_REQUEST_TEMPLATE"]
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
  Derived -.->|"inherits copy of"| template
  future -.->|"planned; not present yet"| template
```

## How to read it

- **Consumers** (people and agents) enter through `README.md` and `AGENTS.md`.
- **`docs/`** holds the lasting description of architecture, decisions, development practice, and security posture.
- **`.github/`** is drawn as a future surface so the diagram does not pretend CI already exists. When that slice lands, update this figure and [architecture.md](architecture.md) in the same PR.
- A **derived repository** gets a snapshot of these files; it does not stay coupled to upstream template updates unless the consumer chooses to merge them later.
