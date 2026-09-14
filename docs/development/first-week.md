# First-week checklist (after Use this template)

A short checklist for maintainers of a **new repository created from this template**. It is docs-only guidance—nothing here invents an application.

## Day 0 (create)

1. Create the repo with GitHub **Use this template** (prefer a clean history).
2. Confirm Actions are enabled for the new repository.
3. Replace `README.md` title/purpose for the product; keep the `docs/` layout unless an ADR says otherwise.
4. Update `.github/CODEOWNERS` to your maintainers (remove `@rmkr-dev` if it does not apply).
5. Skim [SECURITY.md](../../SECURITY.md) and keep a private reporting path (GitHub Security Advisories).

## Day 1–2 (honesty pass)

1. Rewrite [docs/architecture/architecture.md](../architecture/architecture.md) for the real system (or state “skeleton only” until code exists).
2. Update Mermaid diagrams only when components are real; leave [network-diagram.md](../architecture/network-diagram.md) as the stub until you have a network.
3. Run locally:

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
```

4. Turn on recommended [branch protection](../operations/branch-protection.md) for `main` when you are ready for required checks.
5. Enable Dependency graph / Dependabot alerts if you want dependency-review CI to succeed on PRs.

## First application slice

1. Add real product code **before** inventing language-specific CI that pretends to build something missing.
2. Extend CodeQL languages and Dependabot ecosystems when those languages land.
3. Note consumer-visible changes in `CHANGELOG.md` `[Unreleased]`.
4. Follow language sketches in [examples.md](../references/examples.md) (Java, Python, Azure/AKS) without copying sample apps into the template upstream.

## Security and incidents

- Secrets never go in git; prefer OIDC / short-lived credentials for cloud deploy later.
- Template-scoped incidents (leaked token, unsafe workflow): [incident-response.md](../operations/incident-response.md).
- Product outages belong in **your** runtime IR plan, not this checklist.

## Related

- [README](../../README.md) — how to use the template
- [CONTRIBUTING](../../CONTRIBUTING.md) — how to change the template itself
- [Development](development.md) — local validation and CI shape on the template
