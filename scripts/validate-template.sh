#!/usr/bin/env bash
# Validate that required template files exist and basic Markdown links resolve.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

REQUIRED=(
  "AGENTS.md"
  "README.md"
  "LICENSE"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "docs/architecture/architecture.md"
  "docs/architecture/architecture-diagram.md"
  "docs/architecture/network-diagram.md"
  "docs/architecture/README.md"
  "docs/decisions/README.md"
  "docs/decisions/ADR-001-github-native-template.md"
  "docs/decisions/ADR-002-validation-in-ci.md"
  "docs/development/development.md"
  "docs/security/security.md"
  "docs/operations/README.md"
  "docs/operations/operations.md"
  "docs/operations/release-process.md"
  "docs/operations/tagging.md"
  "docs/operations/branch-protection.md"
  "docs/operations/incident-response.md"
  "docs/references/README.md"
  "docs/references/examples.md"
  ".gitignore"
  "CHANGELOG.md"
  ".github/workflows/ci.yml"
  ".github/workflows/codeql.yml"
  ".github/workflows/release.yml"
  ".github/workflows/dependency-review.yml"
  ".github/workflows/scorecard.yml"
  ".github/dependabot.yml"
  ".github/CODEOWNERS"
  ".github/PULL_REQUEST_TEMPLATE.md"
  ".github/ISSUE_TEMPLATE/bug_report.yml"
  ".github/ISSUE_TEMPLATE/feature_request.yml"
  ".github/ISSUE_TEMPLATE/config.yml"
  "CODE_OF_CONDUCT.md"
  "SUPPORT.md"
  "scripts/validate-template.sh"
  "tests/test_validate_template.sh"
)

fail=0

echo "==> Checking required files"
for path in "${REQUIRED[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "MISSING: $path" >&2
    fail=1
  else
    echo "OK: $path"
  fi
done

echo "==> Checking workflow triggers and jobs"
for wf in .github/workflows/ci.yml .github/workflows/codeql.yml .github/workflows/release.yml .github/workflows/dependency-review.yml .github/workflows/scorecard.yml; do
  if ! grep -qE '^[[:space:]]*on:' "$wf"; then
    echo "MISSING on: trigger in $wf" >&2
    fail=1
  else
    echo "OK on: $wf"
  fi
  if ! grep -qE '^[[:space:]]*jobs:' "$wf"; then
    echo "MISSING jobs: key in $wf" >&2
    fail=1
  else
    echo "OK jobs: $wf"
  fi
  if ! grep -qE 'uses:[[:space:]]*actions/checkout@' "$wf"; then
    echo "MISSING actions/checkout in $wf" >&2
    fail=1
  else
    echo "OK checkout: $wf"
  fi
done

echo "==> Checking CODEOWNERS has an owner"
if ! grep -qE '@[A-Za-z0-9_-]+' .github/CODEOWNERS; then
  echo "MISSING owner handle in .github/CODEOWNERS" >&2
  fail=1
else
  echo "OK: CODEOWNERS has owner"
fi

echo "==> Checking SECURITY.md policy completeness"
if ! grep -qiE 'advisory|report' SECURITY.md; then
  echo "MISSING reporting guidance in SECURITY.md" >&2
  fail=1
else
  echo "OK: SECURITY.md reporting path"
fi
if ! grep -qiE 'supported versions' SECURITY.md; then
  echo "MISSING Supported versions section in SECURITY.md" >&2
  fail=1
else
  echo "OK: SECURITY.md supported versions"
fi
if ! grep -qiE 'private' SECURITY.md; then
  echo "MISSING private reporting guidance in SECURITY.md" >&2
  fail=1
else
  echo "OK: SECURITY.md private reporting"
fi
if ! grep -qiE 'do \*\*not\*\* open a public|do not open a public' SECURITY.md; then
  echo "MISSING do-not-disclose-publicly guidance in SECURITY.md" >&2
  fail=1
else
  echo "OK: SECURITY.md no-public-disclosure"
fi

echo "==> Checking CHANGELOG structure"
if ! grep -qE '^## \[Unreleased\]' CHANGELOG.md; then
  echo "MISSING ## [Unreleased] section in CHANGELOG.md" >&2
  fail=1
else
  echo "OK: CHANGELOG has [Unreleased]"
fi
if ! grep -qE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md; then
  echo "MISSING versioned ## [X.Y.Z] section in CHANGELOG.md" >&2
  fail=1
else
  echo "OK: CHANGELOG has a versioned section"
fi

echo "==> Checking ADRs exist and declare Status"
adr_count="$(find docs/decisions -maxdepth 1 -type f \( -name 'ADR-*.md' -o -name '[0-9][0-9][0-9][0-9]-*.md' \) | wc -l | tr -d ' ')"
if [[ "$adr_count" -lt 1 ]]; then
  echo "MISSING: no ADR files under docs/decisions/" >&2
  fail=1
else
  echo "OK: ADR count=$adr_count"
fi
mapfile -t adr_files < <(find docs/decisions -maxdepth 1 -type f \( -name 'ADR-*.md' -o -name '[0-9][0-9][0-9][0-9]-*.md' \) | sort)
for adr in "${adr_files[@]}"; do
  if ! grep -qE '^(- )?Status:' "$adr"; then
    echo "MISSING Status: in $adr" >&2
    fail=1
  else
    echo "OK Status: $adr"
  fi
done

echo "==> Checking Mermaid diagram sources exist"
for path in docs/architecture/architecture-diagram.md docs/architecture/network-diagram.md; do
  if ! grep -q '```mermaid' "$path"; then
    echo "MISSING mermaid fence in: $path" >&2
    fail=1
  else
    echo "OK mermaid: $path"
  fi
done

echo "==> Markdown link sanity (relative file links)"
mapfile -t md_files < <(find . -name '*.md' -not -path './.git/*' | sort)
for file in "${md_files[@]}"; do
  while IFS= read -r link; do
    case "$link" in
      http://*|https://*|mailto:*|\#*) continue ;;
    esac
    target="${link%%#*}"
    [[ -z "$target" ]] && continue
    base="$(dirname "$file")"
    if [[ -e "$base/$target" || -e "$target" ]]; then
      continue
    fi
    echo "BROKEN LINK in $file -> $link" >&2
    fail=1
  done < <(grep -oE '\[[^]]+\]\([^)]+\)' "$file" | sed -E 's/^[^]]*\]\(([^)]+)\)$/\1/' || true)
done

if [[ "$fail" -ne 0 ]]; then
  echo "validate-template: FAILED" >&2
  exit 1
fi

echo "validate-template: PASSED"
