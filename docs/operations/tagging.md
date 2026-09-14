# Tagging and releases

Short companion to [release-process.md](release-process.md).

## Tag naming

- Use annotated tags: `vMAJOR.MINOR.PATCH` (example: `v0.1.0`).
- Only tag commits that are already on `main` with green CI.
- Do not move or delete published `v*` tags; cut a new patch instead.

## What happens on push

Pushing a `v*` tag triggers [`.github/workflows/release.yml`](../../.github/workflows/release.yml), which creates a GitHub Release for that tag using `gh release create`. The release notes point maintainers and consumers at `CHANGELOG.md`.

## Example

```bash
git checkout main && git pull
# ensure CHANGELOG Unreleased notes are accurate
git tag -a v0.1.0 -m "v0.1.0: baseline enterprise GitHub template"
git push origin v0.1.0
```

Then confirm the Release appears under the repository’s Releases tab.

## First release

`v0.1.0` marks the first public snapshot with CI validation, ADRs, community files, and the release workflow in place.

## After the tag

1. Confirm Actions ran `.github/workflows/release.yml` for the tag.
2. Open the GitHub Release page and skim notes against `CHANGELOG.md`.
3. Bump any consumer docs that pin a minimum template version only when they intentionally upgrade.
