# Architecture docs

This folder is the system description for repositories created from this template.

| File | Role |
| --- | --- |
| [architecture.md](architecture.md) | Current-state architecture: what the system is, trust boundaries, and major components |

## What belongs here

- A short current-state narrative that matches the repo **as it exists**
- Diagrams that explain that narrative (application structure, request flow). Add them when there is a real system to draw.
- Links to ADRs in [`docs/decisions/`](../decisions/README.md) for the choices that shaped the design

## What does not belong here

- Roadmaps disguised as current state
- Network diagrams unless the product has a network worth documenting (VPCs, private links, multi-region). Consumers add those in their own repo when networking applies.
- Vendor or company names that are not part of the software

This template repository has no application runtime yet. Start from [architecture.md](architecture.md) and replace it when you introduce real components.
