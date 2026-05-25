#!/usr/bin/env bash
# run-push-tests.sh
# Runs each push protection test case one at a time.
# Each test commits a single file and pushes — you observe whether
# push protection blocks it or allows it through.
#
# Usage: ./scripts/run-push-tests.sh [test-number]
#   ./scripts/run-push-tests.sh        # runs all tests interactively
#   ./scripts/run-push-tests.sh 3      # runs only test 03

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="$REPO_ROOT/tests/push-protection"
BRANCH_PREFIX="test/push-protection"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${CYAN}[TEST]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
pass() { echo -e "${GREEN}[PASS]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*"; }

run_test() {
  local file="$1"
  local filename
  filename="$(basename "$file")"
  local test_num="${filename:0:2}"
  local branch="${BRANCH_PREFIX}-${test_num}"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log "Test ${test_num}: ${filename}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Print the test description from the file header
  grep '^#' "$file" | head -5 | sed 's/^# /  /'

  echo ""
  read -rp "  Press ENTER to run this test (or 's' to skip): " choice
  if [[ "$choice" == "s" ]]; then
    warn "Skipped."
    return
  fi

  # Create a fresh branch for this test
  git -C "$REPO_ROOT" checkout main --quiet
  git -C "$REPO_ROOT" checkout -b "$branch" --quiet 2>/dev/null || \
    git -C "$REPO_ROOT" checkout "$branch" --quiet

  # Append a timestamp so git always sees a change (files are pre-committed to main)
  echo "# test-run: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$file"

  # Stage only this test file
  git -C "$REPO_ROOT" add "$file"
  git -C "$REPO_ROOT" commit -m "test(${test_num}): push protection test — ${filename}" --quiet

  echo ""
  log "Pushing branch '${branch}'..."
  echo ""

  # Attempt push — capture output to show result clearly
  if git -C "$REPO_ROOT" push origin "$branch" --force 2>&1; then
    echo ""
    fail "Push SUCCEEDED — push protection did NOT block this secret."
    fail "Check if secret scanning still raised an alert in the Security tab."
  else
    echo ""
    pass "Push BLOCKED — push protection worked as expected."
    pass "Visit the URL above to choose a bypass reason if needed."
  fi

  echo ""
  read -rp "  Record result (blocked/allowed/error): " result
  echo "  Test ${test_num} | ${filename} | Result: ${result}" >> "$REPO_ROOT/results/actuals.md"

  # Clean up: return to main and restore test file to its original state
  git -C "$REPO_ROOT" checkout main --quiet
  git -C "$REPO_ROOT" checkout -- "$file" 2>/dev/null || true
}

cd "$REPO_ROOT"

# Ensure we're on main and up to date
git checkout main --quiet
git pull origin main --quiet 2>/dev/null || true

# Initialise results file
mkdir -p "$REPO_ROOT/results"
if [[ ! -f "$REPO_ROOT/results/actuals.md" ]]; then
  echo "# Actual Test Results" > "$REPO_ROOT/results/actuals.md"
  echo "Generated: $(date)" >> "$REPO_ROOT/results/actuals.md"
  echo "" >> "$REPO_ROOT/results/actuals.md"
  echo "| Test | File | Result |" >> "$REPO_ROOT/results/actuals.md"
  echo "|------|------|--------|" >> "$REPO_ROOT/results/actuals.md"
fi

# Run specific test or all tests
if [[ -n "${1:-}" ]]; then
  num=$(printf "%02d" "$1")
  file=$(find "$TEST_DIR" -name "${num}-*" | head -1)
  if [[ -z "$file" ]]; then
    fail "No test file found matching number $1"
    exit 1
  fi
  run_test "$file"
else
  for file in "$TEST_DIR"/[0-9][0-9]-*; do
    run_test "$file"
  done
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "All tests complete. Results saved to results/actuals.md"
log "Run ./scripts/check-alerts.sh to view GHAS alerts."
