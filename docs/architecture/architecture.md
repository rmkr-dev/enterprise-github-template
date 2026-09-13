# Architecture

## Current state

This repository is a **GitHub repository template**, not a deployed application. There is no runtime, datastore, or service boundary to diagram yet.

What exists today is the documentation and process skeleton:

- Entry point and usage: `README.md`
- Human and agent guardrails: `AGENTS.md`
- Contributor path: `CONTRIBUTING.md`, `docs/development/development.md`
- Decision log location: `docs/decisions/`
- Consumer security expectations: `docs/security/security.md`

Consumers copy this layout into a new repo and then describe **their** system in this file.

## Diagram (next)

An architecture diagram will be added in a later slice, once there is a concrete system (or a documented reference layout) to draw. Until then, do not invent boxes for services that are not in the tree.

When you add a diagram, keep it next to this document and link it from [README.md](README.md) in this folder. Prefer a checked-in image or a simple Markdown/Mermaid figure that stays in sync with the narrative above.
