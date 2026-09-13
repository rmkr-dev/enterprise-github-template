# Release process

This template versions **documentation and process defaults**, not an application binary. Releases are optional but useful when you want a named snapshot consumers can cite.

## When to cut a release

- After a coherent set of template improvements lands on `main` (CI, docs layout, guardrails, community files).
- When you want a stable reference for “use at least this template revision.”
- Not for every merged PR.

## How to tag

1. Ensure `main` is green (CI Validate + CodeQL).
2. Update [CHANGELOG.md](../../CHANGELOG.md) in a PR if the notes are not already current.
3. Create an annotated tag from the intended commit on `main`:

```bash
git checkout main
git pull
git tag -a v0.1.0 -m "v0.1.0: baseline template with CI and docs"
git push origin v0.1.0
```

4. Prefer semantic versions: `vMAJOR.MINOR.PATCH`. Start at `v0.x` while the template is still evolving quickly.

## GitHub Releases

If a release workflow is present (`.github/workflows/release.yml`), pushing a `v*` tag creates a GitHub Release from that tag. Otherwise create the release manually from the tag in the GitHub UI.

Release notes should summarize consumer-visible changes (new required files, CI behavior, policy docs)—not internal refactor chatter.

## What not to do

- Do not tag broken `main`.
- Do not attach application binaries or Node/npm artifacts to releases of this template.
- Do not rewrite published tags; cut a new patch instead.
