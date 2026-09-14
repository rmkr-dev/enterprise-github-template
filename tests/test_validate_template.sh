#!/usr/bin/env bash
# Expectations for scripts/validate-template.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/validate-template.sh"

fail=0

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [[ "$expected" != "$actual" ]]; then
    echo "FAIL: $label (expected=$expected actual=$actual)" >&2
    fail=1
  else
    echo "PASS: $label"
  fi
}

assert_contains() {
  local label="$1" needle="$2" haystack="$3"
  if ! grep -qF "$needle" <<<"$haystack"; then
    echo "FAIL: $label (missing '$needle')" >&2
    fail=1
  else
    echo "PASS: $label"
  fi
}

[[ -x "$SCRIPT" ]] || { echo "FAIL: validator not executable" >&2; exit 1; }
echo "PASS: validator is executable"

# Happy path against this repo
set +e
out="$("$SCRIPT" 2>&1)"
rc=$?
set -e
assert_eq "validator exit 0 on repo" "0" "$rc"
assert_contains "PASSED line" "validate-template: PASSED" "$out"
assert_contains "editorconfig required" "OK: .editorconfig" "$out"
assert_contains "secrets-and-oidc required" "OK: docs/operations/secrets-and-oidc.md" "$out"
assert_contains "gitattributes required" "OK: .gitattributes" "$out"
assert_contains "CODEOWNERS check ran" "OK: CODEOWNERS has owner" "$out"
assert_contains "CODEOWNERS catch-all" "OK: CODEOWNERS has catch-all * rule" "$out"
assert_contains "SECURITY check ran" "OK: SECURITY.md reporting path" "$out"
assert_contains "SECURITY supported versions" "OK: SECURITY.md supported versions" "$out"
assert_contains "SECURITY private reporting" "OK: SECURITY.md private reporting" "$out"
assert_contains "SECURITY no public disclosure" "OK: SECURITY.md no-public-disclosure" "$out"
assert_contains "ADR check ran" "OK: ADR count=" "$out"
assert_contains "CHANGELOG Unreleased check" "OK: CHANGELOG has [Unreleased]" "$out"
assert_contains "CHANGELOG version check" "OK: CHANGELOG has a versioned section" "$out"
assert_contains "workflow on: check" "OK on: .github/workflows/ci.yml" "$out"
assert_contains "workflow jobs check" "OK jobs: .github/workflows/ci.yml" "$out"
assert_contains "ADR Status check" "OK Status: docs/decisions/ADR-001-github-native-template.md" "$out"
assert_contains "scheduled workflow schedule" "OK schedule: validate-scheduled.yml" "$out"
assert_contains "scheduled workflow cron" "OK cron: validate-scheduled.yml" "$out"
assert_contains "ADR-003 Status check" "OK Status: docs/decisions/ADR-003-weekly-scheduled-validation.md" "$out"
assert_contains "ADR-004 Status check" "OK Status: docs/decisions/ADR-004-shell-only-template-validation.md" "$out"
assert_contains "CI permissions check" "OK permissions: .github/workflows/ci.yml" "$out"
assert_contains "CI concurrency check" "OK concurrency: .github/workflows/ci.yml" "$out"
assert_contains "CI timeout check" "OK timeout: .github/workflows/ci.yml" "$out"
assert_contains "CodeQL timeout check" "OK timeout: .github/workflows/codeql.yml" "$out"
assert_contains "Scorecard timeout check" "OK timeout: .github/workflows/scorecard.yml" "$out"
assert_contains "Release timeout check" "OK timeout: .github/workflows/release.yml" "$out"
assert_contains "Scheduled timeout check" "OK timeout: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "Dependency-review timeout check" "OK timeout: .github/workflows/dependency-review.yml" "$out"
assert_contains "release tags check" "OK tags: release.yml" "$out"
assert_contains "release contents write" "OK contents write: release.yml" "$out"
assert_contains "release verify-tag" "OK verify-tag: release.yml" "$out"
assert_contains "Scorecard permissions check" "OK permissions: .github/workflows/scorecard.yml" "$out"
assert_contains "Scorecard concurrency check" "OK concurrency: .github/workflows/scorecard.yml" "$out"
assert_contains "Scheduled permissions check" "OK permissions: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "Scheduled concurrency check" "OK concurrency: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "Release permissions check" "OK permissions: .github/workflows/release.yml" "$out"
assert_contains "Release concurrency check" "OK concurrency: .github/workflows/release.yml" "$out"
assert_contains "Dependabot github-actions check" "OK: dependabot github-actions ecosystem" "$out"
assert_contains "Scorecard persist-credentials" "OK: scorecard persist-credentials false" "$out"
assert_contains "CodeQL languages actions" "OK: codeql languages actions" "$out"
assert_contains "CodeQL security-events write" "OK: codeql security-events write" "$out"
assert_contains "Scorecard publish_results" "OK: scorecard publish_results true" "$out"
assert_contains "CI workflow_dispatch" "OK: ci workflow_dispatch" "$out"
assert_contains "gitignore .env" "OK: gitignore covers .env" "$out"
assert_contains "gitignore node_modules" "OK: gitignore covers node_modules" "$out"
assert_contains "no Node/npm manifests" "OK: no Node/npm package manifests" "$out"

# Negative: missing required file should fail
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cp -a "$ROOT/." "$tmpdir/repo"
rm -f "$tmpdir/repo/AGENTS.md"
set +e
"$tmpdir/repo/scripts/validate-template.sh" >/dev/null 2>&1
neg_rc=$?
set -e
assert_eq "validator fails when AGENTS.md missing" "1" "$neg_rc"

# Negative: empty CODEOWNERS should fail
cp -a "$ROOT/." "$tmpdir/repo2"
printf '# no owners\n' > "$tmpdir/repo2/.github/CODEOWNERS"
set +e
"$tmpdir/repo2/scripts/validate-template.sh" >/dev/null 2>&1
co_rc=$?
set -e
assert_eq "validator fails when CODEOWNERS has no owner" "1" "$co_rc"

# Negative: SECURITY.md without reporting path should fail
cp -a "$ROOT/." "$tmpdir/repo3"
printf '# Security\n\nNo guidance here.\n' > "$tmpdir/repo3/SECURITY.md"
set +e
"$tmpdir/repo3/scripts/validate-template.sh" >/dev/null 2>&1
sec_rc=$?
set -e
assert_eq "validator fails when SECURITY.md lacks reporting path" "1" "$sec_rc"

# Negative: SECURITY.md with report keyword but no private / supported versions / no-public guidance
cp -a "$ROOT/." "$tmpdir/repo3b"
printf '# Security\n\n## Reporting\n\nPlease report issues somehow.\n' > "$tmpdir/repo3b/SECURITY.md"
set +e
"$tmpdir/repo3b/scripts/validate-template.sh" >/dev/null 2>&1
sec_partial_rc=$?
set -e
assert_eq "validator fails when SECURITY.md lacks private/supported/no-public policy" "1" "$sec_partial_rc"

# Negative: CHANGELOG without [Unreleased] should fail
cp -a "$ROOT/." "$tmpdir/repo4"
printf '# Changelog\n\n## [0.1.0] — 2026-09-13\n\n- initial\n' > "$tmpdir/repo4/CHANGELOG.md"
set +e
"$tmpdir/repo4/scripts/validate-template.sh" >/dev/null 2>&1
cl_rc=$?
set -e
assert_eq "validator fails when CHANGELOG lacks [Unreleased]" "1" "$cl_rc"

# Negative: ADR without Status should fail
cp -a "$ROOT/." "$tmpdir/repo5"
printf '# ADR-001 stub\n\nNo status line.\n' > "$tmpdir/repo5/docs/decisions/ADR-001-github-native-template.md"
set +e
"$tmpdir/repo5/scripts/validate-template.sh" >/dev/null 2>&1
adr_rc=$?
set -e
assert_eq "validator fails when ADR lacks Status" "1" "$adr_rc"

# Negative: remove all ADRs should fail
cp -a "$ROOT/." "$tmpdir/repo6"
rm -f "$tmpdir/repo6"/docs/decisions/ADR-*.md
set +e
"$tmpdir/repo6/scripts/validate-template.sh" >/dev/null 2>&1
noadr_rc=$?
set -e
assert_eq "validator fails when no ADR files exist" "1" "$noadr_rc"

# Negative: workflow without on: should fail
cp -a "$ROOT/." "$tmpdir/repo7"
printf 'name: CI\njobs:\n  validate:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo7/.github/workflows/ci.yml"
set +e
"$tmpdir/repo7/scripts/validate-template.sh" >/dev/null 2>&1
wf_rc=$?
set -e
assert_eq "validator fails when workflow lacks on:" "1" "$wf_rc"

# Negative: validate-scheduled without schedule/cron should fail
cp -a "$ROOT/." "$tmpdir/repo8"
printf 'name: Scheduled validate\non:\n  workflow_dispatch:\njobs:\n  validate:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo8/.github/workflows/validate-scheduled.yml"
set +e
"$tmpdir/repo8/scripts/validate-template.sh" >/dev/null 2>&1
sched_rc=$?
set -e
assert_eq "validator fails when validate-scheduled lacks schedule/cron" "1" "$sched_rc"


# Negative: ci.yml without concurrency should fail
cp -a "$ROOT/." "$tmpdir/repo9"
printf 'name: CI\non:\n  pull_request:\npermissions:\n  contents: read\njobs:\n  validate:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo9/.github/workflows/ci.yml"
set +e
"$tmpdir/repo9/scripts/validate-template.sh" >/dev/null 2>&1
conc_rc=$?
set -e
assert_eq "validator fails when ci.yml lacks concurrency" "1" "$conc_rc"


# Negative: release.yml without tags: should fail
cp -a "$ROOT/." "$tmpdir/repo10"
printf 'name: Release\non:\n  push:\n    branches: [main]\npermissions:\n  contents: write\njobs:\n  release:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo10/.github/workflows/release.yml"
set +e
"$tmpdir/repo10/scripts/validate-template.sh" >/dev/null 2>&1
rel_rc=$?
set -e
assert_eq "validator fails when release.yml lacks tags:" "1" "$rel_rc"


# Negative: scorecard.yml without concurrency should fail
cp -a "$ROOT/." "$tmpdir/repo11"
printf 'name: OpenSSF Scorecard\non:\n  push:\n    branches: [main]\npermissions: read-all\njobs:\n  analysis:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo11/.github/workflows/scorecard.yml"
set +e
"$tmpdir/repo11/scripts/validate-template.sh" >/dev/null 2>&1
sc_rc=$?
set -e
assert_eq "validator fails when scorecard.yml lacks concurrency" "1" "$sc_rc"

# Negative: dependabot without github-actions ecosystem should fail
cp -a "$ROOT/." "$tmpdir/repo12"
printf 'version: 2\nupdates:\n  - package-ecosystem: npm\n    directory: /\n    schedule:\n      interval: weekly\n' > "$tmpdir/repo12/.github/dependabot.yml"
set +e
"$tmpdir/repo12/scripts/validate-template.sh" >/dev/null 2>&1
dep_rc=$?
set -e
assert_eq "validator fails when dependabot lacks github-actions" "1" "$dep_rc"


# Negative: codeql.yml without timeout-minutes should fail
cp -a "$ROOT/." "$tmpdir/repo13"
printf 'name: CodeQL\non:\n  pull_request:\npermissions:\n  contents: read\nconcurrency:\n  group: codeql\njobs:\n  analyze:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo13/.github/workflows/codeql.yml"
set +e
"$tmpdir/repo13/scripts/validate-template.sh" >/dev/null 2>&1
cq_to_rc=$?
set -e
assert_eq "validator fails when codeql.yml lacks timeout-minutes" "1" "$cq_to_rc"


# Negative: dependency-review.yml without timeout-minutes should fail
cp -a "$ROOT/." "$tmpdir/repo14"
printf 'name: Dependency review\non:\n  pull_request:\npermissions:\n  contents: read\nconcurrency:\n  group: dr\njobs:\n  dependency-review:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo14/.github/workflows/dependency-review.yml"
set +e
"$tmpdir/repo14/scripts/validate-template.sh" >/dev/null 2>&1
dr_to_rc=$?
set -e
assert_eq "validator fails when dependency-review.yml lacks timeout-minutes" "1" "$dr_to_rc"


# Negative: scorecard.yml without persist-credentials: false should fail
cp -a "$ROOT/." "$tmpdir/repo15"
sed -i '/persist-credentials:/d' "$tmpdir/repo15/.github/workflows/scorecard.yml"
set +e
"$tmpdir/repo15/scripts/validate-template.sh" >/dev/null 2>&1
pc_rc=$?
set -e
assert_eq "validator fails when scorecard lacks persist-credentials false" "1" "$pc_rc"


# Negative: CODEOWNERS with owner but no catch-all * should fail
cp -a "$ROOT/." "$tmpdir/repo16"
printf 'docs/ @rmkr-dev\n' > "$tmpdir/repo16/.github/CODEOWNERS"
set +e
"$tmpdir/repo16/scripts/validate-template.sh" >/dev/null 2>&1
star_rc=$?
set -e
assert_eq "validator fails when CODEOWNERS lacks catch-all *" "1" "$star_rc"


# Negative: release.yml without concurrency should fail
cp -a "$ROOT/." "$tmpdir/repo17"
printf 'name: Release\non:\n  push:\n    tags: ["v*"]\npermissions:\n  contents: write\njobs:\n  release:\n    timeout-minutes: 10\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo17/.github/workflows/release.yml"
set +e
"$tmpdir/repo17/scripts/validate-template.sh" >/dev/null 2>&1
rel_conc_rc=$?
set -e
assert_eq "validator fails when release.yml lacks concurrency" "1" "$rel_conc_rc"


# Negative: package.json present should fail (ADR-004)
cp -a "$ROOT/." "$tmpdir/repo18"
printf '{ "name": "forbidden" }\n' > "$tmpdir/repo18/package.json"
set +e
"$tmpdir/repo18/scripts/validate-template.sh" >/dev/null 2>&1
npm_rc=$?
set -e
assert_eq "validator fails when package.json present" "1" "$npm_rc"


# Negative: codeql.yml without languages: actions should fail
cp -a "$ROOT/." "$tmpdir/repo19"
sed -i 's/languages: actions/languages: javascript/' "$tmpdir/repo19/.github/workflows/codeql.yml"
set +e
"$tmpdir/repo19/scripts/validate-template.sh" >/dev/null 2>&1
cq_lang_rc=$?
set -e
assert_eq "validator fails when codeql lacks languages: actions" "1" "$cq_lang_rc"


# Negative: scorecard.yml without publish_results: true should fail
cp -a "$ROOT/." "$tmpdir/repo20"
sed -i 's/publish_results: true/publish_results: false/' "$tmpdir/repo20/.github/workflows/scorecard.yml"
set +e
"$tmpdir/repo20/scripts/validate-template.sh" >/dev/null 2>&1
pr_rc=$?
set -e
assert_eq "validator fails when scorecard lacks publish_results true" "1" "$pr_rc"


# Negative: ci.yml without workflow_dispatch should fail
cp -a "$ROOT/." "$tmpdir/repo21"
sed -i '/workflow_dispatch:/d' "$tmpdir/repo21/.github/workflows/ci.yml"
set +e
"$tmpdir/repo21/scripts/validate-template.sh" >/dev/null 2>&1
wd_rc=$?
set -e
assert_eq "validator fails when ci.yml lacks workflow_dispatch" "1" "$wd_rc"


# Negative: .gitignore without .env / node_modules should fail
cp -a "$ROOT/." "$tmpdir/repo22"
printf '# empty ignore\n' > "$tmpdir/repo22/.gitignore"
set +e
"$tmpdir/repo22/scripts/validate-template.sh" >/dev/null 2>&1
gi_rc=$?
set -e
assert_eq "validator fails when .gitignore lacks .env/node_modules" "1" "$gi_rc"


# Negative: release.yml without --verify-tag should fail
cp -a "$ROOT/." "$tmpdir/repo23"
sed -i '/--verify-tag/d' "$tmpdir/repo23/.github/workflows/release.yml"
set +e
"$tmpdir/repo23/scripts/validate-template.sh" >/dev/null 2>&1
vt_rc=$?
set -e
assert_eq "validator fails when release.yml lacks --verify-tag" "1" "$vt_rc"

if [[ "$fail" -ne 0 ]]; then
  echo "tests: FAILED" >&2
  exit 1
fi
echo "tests: PASSED"
