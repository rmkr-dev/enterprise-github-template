#!/usr/bin/env bash
# Minimal expectations for scripts/validate-template.sh
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

[[ -x "$SCRIPT" ]] || { echo "FAIL: validator not executable" >&2; exit 1; }
echo "PASS: validator is executable"

# Happy path against this repo
set +e
out="$("$SCRIPT" 2>&1)"
rc=$?
set -e
assert_eq "validator exit 0 on repo" "0" "$rc"
echo "$out" | grep -q "validate-template: PASSED" || { echo "FAIL: missing PASSED line" >&2; fail=1; }

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

if [[ "$fail" -ne 0 ]]; then
  echo "tests: FAILED" >&2
  exit 1
fi
echo "tests: PASSED"
