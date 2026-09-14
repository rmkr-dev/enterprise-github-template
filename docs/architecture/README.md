# Architecture docs

This folder is the system description for repositories created from this template.

| File | Role |
| --- | --- |
| [architecture.md](architecture.md) | Current-state architecture: template surfaces, CI, inheritance |
| [architecture-diagram.md](architecture-diagram.md) | Mermaid diagram of template surfaces and derived-repo inheritance |
| [network-diagram.md](network-diagram.md) | Explicit “no networked runtime” note plus consumer-owned stub |

## What belongs here

- A short current-state narrative that matches the repo **as it exists**
- Diagrams that explain that narrative (template layout, later application structure). Add or update them when the tree changes.
- Links to ADRs in [`docs/decisions/`](../decisions/README.md) for the choices that shaped the design

## What does not belong here

- Roadmaps disguised as current state
- Network diagrams of infrastructure that is not in this repo (see [network-diagram.md](network-diagram.md) for the consumer rule)
- Vendor or company names that are not part of the software

This template repository has no application runtime. CI validates docs and required files only. Start from [architecture.md](architecture.md) and replace it when you introduce real components.

Credential hygiene for consumers: [secrets-and-oidc.md](../operations/secrets-and-oidc.md).
