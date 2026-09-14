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

EXTRACT="$ROOT/scripts/extract-changelog-section.sh"
[[ -x "$EXTRACT" ]] || { echo "FAIL: extract-changelog-section.sh not executable" >&2; exit 1; }
echo "PASS: extract-changelog-section.sh is executable"
extract_out="$("$EXTRACT" "0.3.4" "$ROOT/CHANGELOG.md")"
assert_contains "extract 0.3.4 mentions persist-credentials" "persist-credentials" "$extract_out"
set +e
missing_out="$("$EXTRACT" "9.9.9" "$ROOT/CHANGELOG.md")"
missing_rc=$?
set -e
assert_eq "extract missing version exits 0" "0" "$missing_rc"
assert_eq "extract missing version empty" "" "$missing_out"

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
assert_contains "blank issues disabled" "OK: blank_issues_enabled false" "$out"
assert_contains "issue contact_links" "OK: issue contact_links present" "$out"
assert_contains "issue security advisory link" "OK: issue config links security advisories" "$out"
assert_contains "scripts README required" "OK: scripts/README.md" "$out"
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
assert_contains "scheduled workflow_dispatch" "OK: validate-scheduled workflow_dispatch" "$out"
assert_contains "ADR-003 Status check" "OK Status: docs/decisions/ADR-003-weekly-scheduled-validation.md" "$out"
assert_contains "ADR-004 Status check" "OK Status: docs/decisions/ADR-004-shell-only-template-validation.md" "$out"
assert_contains "ADR-005 required" "OK: docs/decisions/ADR-005-pin-github-actions-to-shas.md" "$out"
assert_contains "ADR-005 Status check" "OK Status: docs/decisions/ADR-005-pin-github-actions-to-shas.md" "$out"
assert_contains "SHA-pinned actions" "OK: all third-party actions pinned to 40-char SHAs with version comments" "$out"
assert_contains "CI permissions check" "OK permissions: .github/workflows/ci.yml" "$out"
assert_contains "CI concurrency check" "OK concurrency: .github/workflows/ci.yml" "$out"
assert_contains "CI timeout check" "OK timeout: .github/workflows/ci.yml" "$out"
assert_contains "CodeQL timeout check" "OK timeout: .github/workflows/codeql.yml" "$out"
assert_contains "Scorecard timeout check" "OK timeout: .github/workflows/scorecard.yml" "$out"
assert_contains "Release timeout check" "OK timeout: .github/workflows/release.yml" "$out"
assert_contains "Scheduled timeout check" "OK timeout: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "Dependency-review timeout check" "OK timeout: .github/workflows/dependency-review.yml" "$out"
assert_contains "no write-all ci" "OK no write-all: .github/workflows/ci.yml" "$out"
assert_contains "no write-all scorecard" "OK no write-all: .github/workflows/scorecard.yml" "$out"
assert_contains "scorecard upload-sarif" "OK: scorecard upload-sarif" "$out"
assert_contains "scorecard sarif_file" "OK: scorecard sarif_file" "$out"
assert_contains "scorecard results_format" "OK: scorecard results_format sarif" "$out"
assert_contains "release tags check" "OK tags: release.yml" "$out"
assert_contains "release contents write" "OK contents write: release.yml" "$out"
assert_contains "release verify-tag" "OK verify-tag: release.yml" "$out"
assert_contains "release CHANGELOG reference" "OK: release notes reference CHANGELOG.md" "$out"
assert_contains "release CHANGELOG section" "OK: release notes include CHANGELOG section header" "$out"
assert_contains "release extract helper" "OK: release uses extract-changelog-section.sh" "$out"
assert_contains "extract helper executable" "OK: extract-changelog-section.sh is executable" "$out"
assert_contains "extract helper required" "OK: scripts/extract-changelog-section.sh" "$out"
assert_contains "dependency-review pull_request" "OK: dependency-review pull_request" "$out"
assert_contains "dependency-review-action" "OK: dependency-review-action" "$out"
assert_contains "Scorecard permissions check" "OK permissions: .github/workflows/scorecard.yml" "$out"
assert_contains "Scorecard concurrency check" "OK concurrency: .github/workflows/scorecard.yml" "$out"
assert_contains "Scheduled permissions check" "OK permissions: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "Scheduled concurrency check" "OK concurrency: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "Release permissions check" "OK permissions: .github/workflows/release.yml" "$out"
assert_contains "Release concurrency check" "OK concurrency: .github/workflows/release.yml" "$out"
assert_contains "Dependabot github-actions check" "OK: dependabot github-actions ecosystem" "$out"
assert_contains "Dependabot no npm ecosystem" "OK: dependabot has no npm/yarn/pnpm ecosystem" "$out"
assert_contains "Dependabot weekly interval" "OK: dependabot interval weekly" "$out"
assert_contains "Dependabot no daily/monthly" "OK: dependabot has no daily/monthly interval" "$out"
assert_contains "Dependabot groups" "OK: dependabot groups present" "$out"
assert_contains "CI persist-credentials" "OK persist-credentials: .github/workflows/ci.yml" "$out"
assert_contains "CodeQL persist-credentials" "OK persist-credentials: .github/workflows/codeql.yml" "$out"
assert_contains "Dependency-review persist-credentials" "OK persist-credentials: .github/workflows/dependency-review.yml" "$out"
assert_contains "Scorecard persist-credentials" "OK persist-credentials: .github/workflows/scorecard.yml" "$out"
assert_contains "Release persist-credentials" "OK persist-credentials: .github/workflows/release.yml" "$out"
assert_contains "Scheduled persist-credentials" "OK persist-credentials: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "CodeQL languages actions" "OK: codeql languages actions" "$out"
assert_contains "CodeQL security-events write" "OK: codeql security-events write" "$out"
assert_contains "CodeQL schedule" "OK: codeql schedule" "$out"
assert_contains "CodeQL cron" "OK: codeql cron" "$out"
assert_contains "Scorecard publish_results" "OK: scorecard publish_results true" "$out"
assert_contains "Scorecard schedule" "OK: scorecard schedule" "$out"
assert_contains "Scorecard cron" "OK: scorecard cron" "$out"
assert_contains "CI workflow_dispatch" "OK: ci workflow_dispatch" "$out"
assert_contains "CI shellcheck" "OK shellcheck: .github/workflows/ci.yml" "$out"
assert_contains "Scheduled shellcheck" "OK shellcheck: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "CI bash -n" "OK bash -n: .github/workflows/ci.yml" "$out"
assert_contains "Scheduled bash -n" "OK bash -n: .github/workflows/validate-scheduled.yml" "$out"
assert_contains "gitignore .env" "OK: gitignore covers .env" "$out"
assert_contains "gitignore node_modules" "OK: gitignore covers node_modules" "$out"
assert_contains "gitignore *.pem" "OK: gitignore covers *.pem" "$out"
assert_contains "gitignore id_rsa" "OK: gitignore covers id_rsa" "$out"
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

# Negative: ci.yml with checkout but no persist-credentials: false should fail
cp -a "$ROOT/." "$tmpdir/repo15b"
sed -i '/persist-credentials:/d' "$tmpdir/repo15b/.github/workflows/ci.yml"
set +e
"$tmpdir/repo15b/scripts/validate-template.sh" >/dev/null 2>&1
ci_pc_rc=$?
set -e
assert_eq "validator fails when ci.yml lacks persist-credentials false" "1" "$ci_pc_rc"


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


# Negative: dependabot with github-actions plus npm should fail (ADR-004)
cp -a "$ROOT/." "$tmpdir/repo24"
printf 'version: 2\nupdates:\n  - package-ecosystem: github-actions\n    directory: /\n    schedule:\n      interval: weekly\n  - package-ecosystem: npm\n    directory: /\n    schedule:\n      interval: weekly\n' > "$tmpdir/repo24/.github/dependabot.yml"
set +e
"$tmpdir/repo24/scripts/validate-template.sh" >/dev/null 2>&1
dep_npm_rc=$?
set -e
assert_eq "validator fails when dependabot includes npm ecosystem" "1" "$dep_npm_rc"


# Negative: dependency-review.yml without pull_request should fail
cp -a "$ROOT/." "$tmpdir/repo25"
printf 'name: Dependency review\non:\n  workflow_dispatch:\npermissions:\n  contents: read\nconcurrency:\n  group: dr\njobs:\n  dependency-review:\n    timeout-minutes: 10\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n      - uses: actions/dependency-review-action@v4\n' > "$tmpdir/repo25/.github/workflows/dependency-review.yml"
set +e
"$tmpdir/repo25/scripts/validate-template.sh" >/dev/null 2>&1
dr_pr_rc=$?
set -e
assert_eq "validator fails when dependency-review lacks pull_request" "1" "$dr_pr_rc"


# Negative: codeql.yml without schedule/cron should fail
cp -a "$ROOT/." "$tmpdir/repo26"
sed -i '/schedule:/,/cron:/d' "$tmpdir/repo26/.github/workflows/codeql.yml"
set +e
"$tmpdir/repo26/scripts/validate-template.sh" >/dev/null 2>&1
cq_sched_rc=$?
set -e
assert_eq "validator fails when codeql lacks schedule/cron" "1" "$cq_sched_rc"


# Negative: scorecard.yml without schedule/cron should fail
cp -a "$ROOT/." "$tmpdir/repo27"
sed -i '/schedule:/,/cron:/d' "$tmpdir/repo27/.github/workflows/scorecard.yml"
set +e
"$tmpdir/repo27/scripts/validate-template.sh" >/dev/null 2>&1
sc_sched_rc=$?
set -e
assert_eq "validator fails when scorecard lacks schedule/cron" "1" "$sc_sched_rc"


# Negative: validate-scheduled without workflow_dispatch should fail
cp -a "$ROOT/." "$tmpdir/repo28"
printf 'name: Scheduled validate\non:\n  schedule:\n    - cron: "0 6 * * 1"\npermissions:\n  contents: read\nconcurrency:\n  group: sched\njobs:\n  validate:\n    timeout-minutes: 10\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v7\n' > "$tmpdir/repo28/.github/workflows/validate-scheduled.yml"
set +e
"$tmpdir/repo28/scripts/validate-template.sh" >/dev/null 2>&1
sched_wd_rc=$?
set -e
assert_eq "validator fails when validate-scheduled lacks workflow_dispatch" "1" "$sched_wd_rc"


# Negative: .gitignore without *.pem should fail
cp -a "$ROOT/." "$tmpdir/repo29"
sed -i '/\*\.pem/d' "$tmpdir/repo29/.gitignore"
set +e
"$tmpdir/repo29/scripts/validate-template.sh" >/dev/null 2>&1
pem_rc=$?
set -e
assert_eq "validator fails when .gitignore lacks *.pem" "1" "$pem_rc"

# Negative: issue config with blank_issues_enabled true should fail
cp -a "$ROOT/." "$tmpdir/repo39"
sed -i 's/blank_issues_enabled: false/blank_issues_enabled: true/' "$tmpdir/repo39/.github/ISSUE_TEMPLATE/config.yml"
set +e
"$tmpdir/repo39/scripts/validate-template.sh" >/dev/null 2>&1
blank_rc=$?
set -e
assert_eq "validator fails when blank issues enabled" "1" "$blank_rc"

# Negative: dependabot without groups should fail
cp -a "$ROOT/." "$tmpdir/repo37"
sed -i '/groups:/,/patterns:/d' "$tmpdir/repo37/.github/dependabot.yml"
set +e
"$tmpdir/repo37/scripts/validate-template.sh" >/dev/null 2>&1
grp_rc=$?
set -e
assert_eq "validator fails when dependabot lacks groups" "1" "$grp_rc"

# Negative: scorecard without results_format sarif should fail
cp -a "$ROOT/." "$tmpdir/repo38"
sed -i 's/results_format: sarif/results_format: json/' "$tmpdir/repo38/.github/workflows/scorecard.yml"
set +e
"$tmpdir/repo38/scripts/validate-template.sh" >/dev/null 2>&1
fmt_rc=$?
set -e
assert_eq "validator fails when scorecard lacks results_format sarif" "1" "$fmt_rc"

# Negative: ci.yml with permissions write-all should fail
cp -a "$ROOT/." "$tmpdir/repo35"
sed -i 's/permissions:\n  contents: read/permissions: write-all/' "$tmpdir/repo35/.github/workflows/ci.yml" || true
printf 'name: CI\non:\n  pull_request:\n  workflow_dispatch:\npermissions: write-all\nconcurrency:\n  group: ci\njobs:\n  validate:\n    timeout-minutes: 10\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1  # v7.0.1\n        with:\n          persist-credentials: false\n' > "$tmpdir/repo35/.github/workflows/ci.yml"
set +e
"$tmpdir/repo35/scripts/validate-template.sh" >/dev/null 2>&1
wa_rc=$?
set -e
assert_eq "validator fails when ci.yml has write-all" "1" "$wa_rc"

# Negative: scorecard without upload-sarif should fail
cp -a "$ROOT/." "$tmpdir/repo36"
sed -i '/upload-sarif/,+3d' "$tmpdir/repo36/.github/workflows/scorecard.yml"
set +e
"$tmpdir/repo36/scripts/validate-template.sh" >/dev/null 2>&1
sarif_rc=$?
set -e
assert_eq "validator fails when scorecard lacks upload-sarif" "1" "$sarif_rc"

# Negative: dependabot with daily interval should fail
cp -a "$ROOT/." "$tmpdir/repo34"
sed -i 's/interval: weekly/interval: daily/' "$tmpdir/repo34/.github/dependabot.yml"
set +e
"$tmpdir/repo34/scripts/validate-template.sh" >/dev/null 2>&1
dep_daily_rc=$?
set -e
assert_eq "validator fails when dependabot uses daily interval" "1" "$dep_daily_rc"

# Negative: ci.yml without shellcheck should fail
cp -a "$ROOT/." "$tmpdir/repo33"
sed -i '/shellcheck/d' "$tmpdir/repo33/.github/workflows/ci.yml"
set +e
"$tmpdir/repo33/scripts/validate-template.sh" >/dev/null 2>&1
sc_ci_rc=$?
set -e
assert_eq "validator fails when ci.yml lacks shellcheck" "1" "$sc_ci_rc"

# Negative: release.yml without CHANGELOG.md reference should fail
cp -a "$ROOT/." "$tmpdir/repo32"
sed -i '/CHANGELOG.md/d' "$tmpdir/repo32/.github/workflows/release.yml"
set +e
"$tmpdir/repo32/scripts/validate-template.sh" >/dev/null 2>&1
rel_cl_rc=$?
set -e
assert_eq "validator fails when release.yml lacks CHANGELOG.md reference" "1" "$rel_cl_rc"

# Negative: floating action tag should fail SHA pin
cp -a "$ROOT/." "$tmpdir/repo30"
sed -i 's#actions/checkout@[0-9a-f]\{40\}#actions/checkout@v7#' "$tmpdir/repo30/.github/workflows/ci.yml"
set +e
"$tmpdir/repo30/scripts/validate-template.sh" >/dev/null 2>&1
pin_rc=$?
set -e
assert_eq "validator fails when checkout is not SHA-pinned" "1" "$pin_rc"

# Negative: SHA pin without version comment should fail
cp -a "$ROOT/." "$tmpdir/repo31"
sed -i 's/  # v7.0.1//' "$tmpdir/repo31/.github/workflows/ci.yml"
set +e
"$tmpdir/repo31/scripts/validate-template.sh" >/dev/null 2>&1
pin_cmt_rc=$?
set -e
assert_eq "validator fails when SHA-pinned action lacks version comment" "1" "$pin_cmt_rc"

if [[ "$fail" -ne 0 ]]; then
  echo "tests: FAILED" >&2
  exit 1
fi
echo "tests: PASSED"
