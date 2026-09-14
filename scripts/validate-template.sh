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
  "docs/decisions/ADR-003-weekly-scheduled-validation.md"
  "docs/decisions/ADR-004-shell-only-template-validation.md"
  "docs/development/development.md"
  "docs/development/first-week.md"
  "docs/security/security.md"
  "docs/operations/README.md"
  "docs/operations/operations.md"
  "docs/operations/release-process.md"
  "docs/operations/tagging.md"
  "docs/operations/branch-protection.md"
  "docs/operations/incident-response.md"
  "docs/operations/troubleshooting.md"
  "docs/operations/secrets-and-oidc.md"
  "docs/operations/upgrading-from-upstream.md"
  "docs/references/README.md"
  "docs/references/examples.md"
  "docs/references/faq.md"
  ".gitignore"
  ".editorconfig"
  ".gitattributes"
  "CHANGELOG.md"
  ".github/workflows/ci.yml"
  ".github/workflows/codeql.yml"
  ".github/workflows/release.yml"
  ".github/workflows/dependency-review.yml"
  ".github/workflows/scorecard.yml"
  ".github/workflows/validate-scheduled.yml"
  ".github/dependabot.yml"
  ".github/CODEOWNERS"
  ".github/PULL_REQUEST_TEMPLATE.md"
  ".github/ISSUE_TEMPLATE/bug_report.yml"
  ".github/ISSUE_TEMPLATE/feature_request.yml"
  ".github/ISSUE_TEMPLATE/good_first_issue.yml"
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
for wf in .github/workflows/ci.yml .github/workflows/codeql.yml .github/workflows/release.yml .github/workflows/dependency-review.yml .github/workflows/scorecard.yml .github/workflows/validate-scheduled.yml; do
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

echo "==> Checking validate-scheduled has a cron schedule"
if ! grep -qE '^[[:space:]]*schedule:' .github/workflows/validate-scheduled.yml; then
  echo "MISSING schedule: in validate-scheduled.yml" >&2
  fail=1
else
  echo "OK schedule: validate-scheduled.yml"
fi
if ! grep -qE 'cron:' .github/workflows/validate-scheduled.yml; then
  echo "MISSING cron: in validate-scheduled.yml" >&2
  fail=1
else
  echo "OK cron: validate-scheduled.yml"
fi
if ! grep -qE 'workflow_dispatch:' .github/workflows/validate-scheduled.yml; then
  echo "MISSING workflow_dispatch: in validate-scheduled.yml" >&2
  fail=1
else
  echo "OK: validate-scheduled workflow_dispatch"
fi

echo "==> Checking key workflows declare job timeouts"
for wf in .github/workflows/ci.yml .github/workflows/codeql.yml .github/workflows/scorecard.yml .github/workflows/release.yml .github/workflows/validate-scheduled.yml .github/workflows/dependency-review.yml; do
  if ! grep -qE 'timeout-minutes:' "$wf"; then
    echo "MISSING timeout-minutes: in $wf" >&2
    fail=1
  else
    echo "OK timeout: $wf"
  fi
done

echo "==> Checking CI workflows declare permissions and concurrency"
for wf in .github/workflows/ci.yml .github/workflows/codeql.yml .github/workflows/dependency-review.yml .github/workflows/scorecard.yml .github/workflows/validate-scheduled.yml .github/workflows/release.yml; do
  if ! grep -qE '^[[:space:]]*permissions:' "$wf"; then
    echo "MISSING permissions: in $wf" >&2
    fail=1
  else
    echo "OK permissions: $wf"
  fi
  if ! grep -qE '^[[:space:]]*concurrency:' "$wf"; then
    echo "MISSING concurrency: in $wf" >&2
    fail=1
  else
    echo "OK concurrency: $wf"
  fi
done

echo "==> Checking release workflow tag trigger and permissions"
if ! grep -qE 'tags:' .github/workflows/release.yml; then
  echo "MISSING tags: trigger in release.yml" >&2
  fail=1
else
  echo "OK tags: release.yml"
fi
if ! grep -qE 'contents:[[:space:]]*write' .github/workflows/release.yml; then
  echo "MISSING contents: write in release.yml" >&2
  fail=1
else
  echo "OK contents write: release.yml"
fi
if ! grep -qE -- '--verify-tag' .github/workflows/release.yml; then
  echo "MISSING --verify-tag in release.yml" >&2
  fail=1
else
  echo "OK verify-tag: release.yml"
fi

echo "==> Checking dependency-review runs on pull_request"
if ! grep -qE 'pull_request:' .github/workflows/dependency-review.yml; then
  echo "MISSING pull_request: in dependency-review.yml" >&2
  fail=1
else
  echo "OK: dependency-review pull_request"
fi
if ! grep -qE 'uses:[[:space:]]*actions/dependency-review-action@' .github/workflows/dependency-review.yml; then
  echo "MISSING actions/dependency-review-action in dependency-review.yml" >&2
  fail=1
else
  echo "OK: dependency-review-action"
fi

echo "==> Checking CODEOWNERS has an owner"
if ! grep -qE '@[A-Za-z0-9_-]+' .github/CODEOWNERS; then
  echo "MISSING owner handle in .github/CODEOWNERS" >&2
  fail=1
else
  echo "OK: CODEOWNERS has owner"
fi
if ! grep -qE '^[[:space:]]*\*[[:space:]]+@' .github/CODEOWNERS; then
  echo "MISSING catch-all * owner rule in .github/CODEOWNERS" >&2
  fail=1
else
  echo "OK: CODEOWNERS has catch-all * rule"
fi



echo "==> Checking every workflow checkout disables credential persistence"
for wf in .github/workflows/ci.yml .github/workflows/codeql.yml .github/workflows/dependency-review.yml .github/workflows/scorecard.yml .github/workflows/release.yml .github/workflows/validate-scheduled.yml; do
  checkouts="$(grep -cE 'uses:[[:space:]]*actions/checkout@' "$wf" || true)"
  persists="$(grep -cE 'persist-credentials:[[:space:]]*false' "$wf" || true)"
  if [[ "$checkouts" -lt 1 ]]; then
    echo "MISSING actions/checkout in $wf" >&2
    fail=1
  elif [[ "$persists" -lt "$checkouts" ]]; then
    echo "MISSING persist-credentials: false for every checkout in $wf (checkouts=$checkouts persist-false=$persists)" >&2
    fail=1
  else
    echo "OK persist-credentials: $wf ($persists/$checkouts)"
  fi
done

echo "==> Checking CodeQL analyzes Actions workflows"
if ! grep -qE 'languages:[[:space:]]*actions' .github/workflows/codeql.yml; then
  echo "MISSING languages: actions in codeql.yml" >&2
  fail=1
else
  echo "OK: codeql languages actions"
fi
if ! grep -qE 'security-events:[[:space:]]*write' .github/workflows/codeql.yml; then
  echo "MISSING security-events: write in codeql.yml" >&2
  fail=1
else
  echo "OK: codeql security-events write"
fi
if ! grep -qE '^[[:space:]]*schedule:' .github/workflows/codeql.yml; then
  echo "MISSING schedule: in codeql.yml" >&2
  fail=1
else
  echo "OK: codeql schedule"
fi
if ! grep -qE 'cron:' .github/workflows/codeql.yml; then
  echo "MISSING cron: in codeql.yml" >&2
  fail=1
else
  echo "OK: codeql cron"
fi

echo "==> Checking Scorecard publishes results"
if ! grep -qE 'publish_results:[[:space:]]*true' .github/workflows/scorecard.yml; then
  echo "MISSING publish_results: true in scorecard.yml" >&2
  fail=1
else
  echo "OK: scorecard publish_results true"
fi
if ! grep -qE '^[[:space:]]*schedule:' .github/workflows/scorecard.yml; then
  echo "MISSING schedule: in scorecard.yml" >&2
  fail=1
else
  echo "OK: scorecard schedule"
fi
if ! grep -qE 'cron:' .github/workflows/scorecard.yml; then
  echo "MISSING cron: in scorecard.yml" >&2
  fail=1
else
  echo "OK: scorecard cron"
fi

echo "==> Checking CI allows on-demand workflow_dispatch"
if ! grep -qE 'workflow_dispatch:' .github/workflows/ci.yml; then
  echo "MISSING workflow_dispatch: in ci.yml" >&2
  fail=1
else
  echo "OK: ci workflow_dispatch"
fi

echo "==> Checking .gitignore covers .env and node_modules"
if ! grep -qE '(^|/)\.env(\.|\*|\b|$)' .gitignore && ! grep -qF '.env' .gitignore; then
  echo "MISSING .env ignore rule in .gitignore" >&2
  fail=1
else
  echo "OK: gitignore covers .env"
fi
if ! grep -qF 'node_modules' .gitignore; then
  echo "MISSING node_modules ignore rule in .gitignore" >&2
  fail=1
else
  echo "OK: gitignore covers node_modules"
fi
if ! grep -qF '*.pem' .gitignore; then
  echo "MISSING *.pem ignore rule in .gitignore" >&2
  fail=1
else
  echo "OK: gitignore covers *.pem"
fi
if ! grep -qE '(^|/)id_rsa$' .gitignore && ! grep -qF 'id_rsa' .gitignore; then
  echo "MISSING id_rsa ignore rule in .gitignore" >&2
  fail=1
else
  echo "OK: gitignore covers id_rsa"
fi

echo "==> Checking Dependabot covers github-actions"
if ! grep -qE 'package-ecosystem:[[:space:]]*github-actions' .github/dependabot.yml; then
  echo "MISSING package-ecosystem: github-actions in dependabot.yml" >&2
  fail=1
else
  echo "OK: dependabot github-actions ecosystem"
fi
if grep -qE 'package-ecosystem:[[:space:]]*(npm|yarn|pnpm)' .github/dependabot.yml; then
  echo "FORBIDDEN Node package-ecosystem in dependabot.yml (ADR-004)" >&2
  fail=1
else
  echo "OK: dependabot has no npm/yarn/pnpm ecosystem"
fi

echo "==> Checking no Node/npm package manifests (ADR-004)"
node_hits=()
for path in package.json package-lock.json yarn.lock pnpm-lock.yaml npm-shrinkwrap.json; do
  if [[ -e "$path" ]]; then
    node_hits+=("$path")
  fi
done
if [[ -d node_modules ]]; then
  node_hits+=("node_modules/")
fi
if [[ "${#node_hits[@]}" -gt 0 ]]; then
  echo "FORBIDDEN Node/npm artifacts (ADR-004): ${node_hits[*]}" >&2
  fail=1
else
  echo "OK: no Node/npm package manifests"
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
