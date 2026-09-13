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
assert_contains "CODEOWNERS check ran" "OK: CODEOWNERS has owner" "$out"
assert_contains "SECURITY check ran" "OK: SECURITY.md reporting path" "$out"
assert_contains "ADR check ran" "OK: ADR count=" "$out"
assert_contains "workflow jobs check" "OK jobs: .github/workflows/ci.yml" "$out"

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

if [[ "$fail" -ne 0 ]]; then
  echo "tests: FAILED" >&2
  exit 1
fi
echo "tests: PASSED"
