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
  "docs/development/development.md"
  "docs/security/security.md"
  ".github/workflows/ci.yml"
  ".github/workflows/codeql.yml"
  ".github/dependabot.yml"
  ".github/CODEOWNERS"
  ".github/PULL_REQUEST_TEMPLATE.md"
  "scripts/validate-template.sh"
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
  # Extract ](target) destinations
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
