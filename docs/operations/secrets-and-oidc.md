# Secrets and OIDC hygiene (template consumers)

Guidance for **derived** repositories. This template ships no cloud credentials and no long-lived deploy keys by default.

## Defaults in this template

| Surface | What exists | What does **not** |
| --- | --- | --- |
| Actions `permissions:` | Least privilege per workflow (see [security.md](../security/security.md)) | Broad `write-all` defaults |
| Secrets in repo | None committed | Example `.env` files with real values |
| Deploy identity | Documented preference for OIDC in consumer sketches | Checked-in service principal passwords |

## Prefer OIDC / federated credentials

When a derived repo deploys to a cloud provider from GitHub Actions:

1. Use the provider’s **OIDC / workload identity** federation from GitHub’s token audience.
2. Scope the cloud role to the minimum resources and environments needed.
3. Keep environment names and subscription/project IDs in GitHub Environments or documented config — not in template defaults.

Long-lived `AZURE_CLIENT_SECRET`, static AWS access keys, or GCP JSON keys in repository secrets are a last resort and should be rotated on a documented schedule.

## What never belongs in git

- Cloud access keys, tokens, private keys, or `.pem` / `.p12` material
- `.env` files with production values (keep `.env.example` placeholder-only if you add one in the derived repo)
- Personal access tokens in workflow YAML or docs examples

If a secret is committed, treat it as compromised: rotate, purge history if required by your policy, and update [incident-response.md](incident-response.md).

## Checklist after Use this template

- [ ] No secrets in the first product PRs
- [ ] Actions workflows keep explicit `permissions:`
- [ ] Any deploy job uses OIDC or a short-lived credential path
- [ ] Branch protection and environment protection match your risk (see [branch-protection.md](branch-protection.md))

## Related

`.gitignore` in this template also ignores common key material (`*.pem`, `id_rsa`, keystores). Do not weaken those ignores to “make a demo work.”


- [security.md](../security/security.md) — consumer security posture
- [SECURITY.md](../../SECURITY.md) — reporting template vulnerabilities
- [examples.md](../references/examples.md) — Azure/AKS and Terraform sketches mention OIDC
- [troubleshooting.md](troubleshooting.md) — common CI failures
