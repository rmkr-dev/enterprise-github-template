#!/usr/bin/env bash
# Extract a Keep-a-Changelog version body from CHANGELOG.md.
# Usage: extract-changelog-section.sh <version> [changelog-path]
# Prints the section under "## [version]" until the next "## [" heading (exclusive).
# Exit 0 always when the file is readable; empty stdout means no matching section.
set -euo pipefail

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: $0 <version> [changelog-path]" >&2
  exit 2
fi

version="$1"
changelog="${2:-CHANGELOG.md}"

if [[ ! -f "$changelog" ]]; then
  echo "MISSING changelog: $changelog" >&2
  exit 1
fi

awk -v ver="$version" '
  $0 ~ ("^## \\[" ver "\\]") {grab=1; next}
  grab && $0 ~ /^## \[/ {exit}
  grab {print}
' "$changelog"
