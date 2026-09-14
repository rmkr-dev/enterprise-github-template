# Upgrading from upstream template releases

This guide is for maintainers of a **derived** repository created with **Use this template** (or a clone/fork) who want to pick up later improvements from [`rmkr-dev/enterprise-github-template`](https://github.com/rmkr-dev/enterprise-github-template).

Inheritance is **copy-based**, not a live submodule. There is no automatic sync.

## When to upgrade

- After a tagged template release (`v*`) that adds validator gates, workflow hygiene, or docs you want.
- When your derived repo’s CI still runs `scripts/validate-template.sh` and starts failing on new required files or checks.
- When you intentionally want secrets/OIDC, Scorecard, or release-on-tag behavior that landed upstream after you created the repo.

Skip upgrades that only add language sketches you do not need.

## Safe upgrade pattern

1. **Read the release notes** for the target tag and skim `CHANGELOG.md` between your last adopted version and the new one.
2. **Prefer cherry-picks or file-level copies** over merging the entire upstream history into a product repo (histories diverge quickly once application code exists).
3. **Bring over slices in this order** (stop when the slice does not apply):
   - `scripts/validate-template.sh` and `tests/test_validate_template.sh`
   - `.github/workflows/*` you still rely on (CI, CodeQL, dependency-review, Scorecard, release, scheduled validate)
   - `.github/dependabot.yml`, `.github/CODEOWNERS` patterns (keep your owners)
   - Policy/docs you still want: `SECURITY.md`, `AGENTS.md`, `docs/operations/*`, ADRs
4. **Run local validation** before opening the PR:

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
```

5. **Update required checks** on `main` if job names changed — see [branch-protection.md](branch-protection.md).
6. **Note the adopted template version** in your product changelog or an ADR so the next upgrade has a baseline.

## What not to copy blindly

- Language / Terraform / Azure-AKS sketches under `docs/references/examples.md` unless they match your stack
- Upstream `CODEOWNERS` handles (`@rmkr-dev`) — replace with your team
- Release tags or GitHub Releases from the template repo
- Anything that reintroduces Node/npm only to lint Markdown (ADR-004)

## Conflict tips

| Conflict | Guidance |
| --- | --- |
| Your app CI vs template validate | Keep both until app tests replace template validation; then retire validate deliberately |
| Custom workflow permissions | Keep least privilege; do not widen tokens to make a cherry-pick “easier” |
| Renamed docs paths | Fix Markdown links; the upstream validator fails on broken relative links |
| Secrets in derived workflows | Prefer OIDC — see [secrets-and-oidc.md](secrets-and-oidc.md) |

## Related

- [release-process.md](release-process.md) — how upstream tags releases
- [tagging.md](tagging.md) — `v*` tag behavior
- [troubleshooting.md](troubleshooting.md) — validator failure modes
- [faq.md](../references/faq.md) — “How do I get security updates from upstream?”
