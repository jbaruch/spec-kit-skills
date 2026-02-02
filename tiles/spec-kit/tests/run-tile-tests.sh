#!/usr/bin/env bash
#
# Spec-Kit Tile Integration Tests
#
# Tests the Tessl-packaged tile to ensure it works after installation.
#
# Usage:
#   ./tiles/spec-kit/tests/run-tile-tests.sh [--from-registry|--from-local]
#

set -uo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

TEST_DIR=""
TILE_SOURCE="registry"
ORIGINAL_DIR=""

log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; ((TESTS_PASSED++)); }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; ((TESTS_FAILED++)); }
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

run_test() {
    local name="$1"
    local cmd="$2"
    ((TESTS_RUN++))

    if eval "$cmd" >/dev/null 2>&1; then
        log_pass "$name"
        return 0
    else
        log_fail "$name"
        return 1
    fi
}

setup() {
    log_section "Setup"
    ORIGINAL_DIR=$(pwd)
    TEST_DIR=$(mktemp -d)
    log_info "Test dir: $TEST_DIR"

    cd "$TEST_DIR"
    git init -q
    git config user.email "test@test.com"
    git config user.name "Test"
    echo "# Test" > README.md
    git add README.md
    git commit -qm "init"

    echo '{"tiles":{}}' > tessl.json

    if [[ "$TILE_SOURCE" == "local" ]]; then
        log_info "Installing from local..."
        tessl install "file:$ORIGINAL_DIR/tiles/spec-kit" 2>&1 | grep -v "^-"
    else
        log_info "Installing from registry (latest)..."
        # Note: May need to specify version if recently published
        tessl install tessl-labs/spec-kit 2>&1 | grep -v "^-"
        if [[ ! -d ".tessl/tiles/tessl-labs/spec-kit" ]]; then
            log_info "Retrying with explicit version..."
            tessl install tessl-labs/spec-kit@0.7.0 2>&1 | grep -v "^-" || \
            tessl install tessl-labs/spec-kit@0.6.5 2>&1 | grep -v "^-"
        fi
    fi
}

teardown() {
    cd "$ORIGINAL_DIR" 2>/dev/null || true
    [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]] && rm -rf "$TEST_DIR"
}

test_scripts_exist() {
    log_section "Scripts Exist"
    local base=".tessl/tiles/tessl-labs/spec-kit/skills/speckit-core/scripts/bash"

    run_test "check-prerequisites.sh exists" "[[ -f '$base/check-prerequisites.sh' ]]"
    run_test "create-new-feature.sh exists" "[[ -f '$base/create-new-feature.sh' ]]"
    run_test "setup-plan.sh exists" "[[ -f '$base/setup-plan.sh' ]]"
    run_test "testify-tdd.sh exists" "[[ -f '$base/testify-tdd.sh' ]]"
    run_test "common.sh exists" "[[ -f '$base/common.sh' ]]"
}

test_scripts_executable() {
    log_section "Scripts Execute with Bash"
    local base=".tessl/tiles/tessl-labs/spec-kit/skills/speckit-core/scripts/bash"

    ((TESTS_RUN++))
    if bash "$base/check-prerequisites.sh" --help >/dev/null 2>&1; then
        log_pass "check-prerequisites.sh --help"
    else
        log_fail "check-prerequisites.sh --help"
    fi

    ((TESTS_RUN++))
    if bash "$base/create-new-feature.sh" --help >/dev/null 2>&1; then
        log_pass "create-new-feature.sh --help"
    else
        log_fail "create-new-feature.sh --help"
    fi

    ((TESTS_RUN++))
    if bash "$base/setup-plan.sh" --help >/dev/null 2>&1; then
        log_pass "setup-plan.sh --help"
    else
        log_fail "setup-plan.sh --help"
    fi

    # testify-tdd.sh shows usage on unknown command (exits 1 but runs)
    ((TESTS_RUN++))
    local output
    output=$(bash "$base/testify-tdd.sh" unknown 2>&1) || true
    if echo "$output" | grep -q 'Available commands'; then
        log_pass "testify-tdd.sh runs"
    else
        log_fail "testify-tdd.sh runs (output: ${output:0:50}...)"
    fi
}

test_templates_exist() {
    log_section "Templates Exist"
    local base=".tessl/tiles/tessl-labs/spec-kit/skills/speckit-core/templates"

    run_test "constitution-template.md" "[[ -f '$base/constitution-template.md' ]]"
    run_test "spec-template.md" "[[ -f '$base/spec-template.md' ]]"
    run_test "plan-template.md" "[[ -f '$base/plan-template.md' ]]"
    run_test "tasks-template.md" "[[ -f '$base/tasks-template.md' ]]"
    run_test "checklist-template.md" "[[ -f '$base/checklist-template.md' ]]"
    run_test "testspec-template.md" "[[ -f '$base/testspec-template.md' ]]"
}

test_skills_exist() {
    log_section "Skills Exist"
    local base=".tessl/tiles/tessl-labs/spec-kit/skills"

    # Check speckit-core exists
    run_test "speckit-core skill" "[[ -d '$base/speckit-core' && -f '$base/speckit-core/SKILL.md' ]]"

    for i in 00 01 02 03 04 05 06 07 08 09; do
        local skill=$(ls -d "$base"/speckit-${i}-* 2>/dev/null | head -1)
        run_test "speckit-${i}-* skill" "[[ -d '$skill' && -f '$skill/SKILL.md' ]]"
    done
}

test_workflow_order() {
    log_section "Workflow Order (Next Steps)"
    local base=".tessl/tiles/tessl-labs/spec-kit/skills"

    # Plan should NOT suggest implement (requires tasks)
    ((TESTS_RUN++))
    if grep -A20 "## Next Steps" "$base/speckit-03-plan/SKILL.md" | grep -E "^- /speckit-08-implement|^[0-9]\..*/speckit-08-implement" >/dev/null 2>&1; then
        log_fail "plan suggests implement before tasks"
    else
        log_pass "plan does not suggest implement"
    fi

    # Testify should NOT suggest analyze (requires tasks)
    ((TESTS_RUN++))
    if grep -A15 "## Next Steps" "$base/speckit-05-testify/SKILL.md" | grep -E "^- /speckit-07-analyze|^[0-9]\..*/speckit-07-analyze" >/dev/null 2>&1; then
        log_fail "testify suggests analyze before tasks"
    else
        log_pass "testify does not suggest analyze"
    fi

    # Checklist should NOT suggest implement
    ((TESTS_RUN++))
    if grep -A20 "## Next Steps" "$base/speckit-04-checklist/SKILL.md" | grep -E "^- /speckit-08-implement|^[0-9]\..*/speckit-08-implement" >/dev/null 2>&1; then
        log_fail "checklist suggests implement before tasks"
    else
        log_pass "checklist does not suggest implement"
    fi
}

test_tdd_check_has_args() {
    log_section "TDD Check Has Arguments"
    local impl=".tessl/tiles/tessl-labs/spec-kit/skills/speckit-08-implement/SKILL.md"

    ((TESTS_RUN++))
    if grep -q 'testify-tdd.sh comprehensive-check "FEATURE_DIR' "$impl"; then
        log_pass "implement has complete testify-tdd.sh args"
    else
        log_fail "implement missing testify-tdd.sh args"
    fi
}

test_bash_prefix() {
    log_section "Scripts Use Bash Prefix"
    local base=".tessl/tiles/tessl-labs/spec-kit/skills"

    # Check skills use "bash .tessl/..." not just ".tessl/..."
    ((TESTS_RUN++))
    local found_issue=false

    for skill in "$base"/speckit-*/SKILL.md; do
        # Look for script calls in bash blocks that don't have bash prefix
        if grep -B1 '\.tessl.*scripts/bash.*\.sh' "$skill" 2>/dev/null | grep -v 'bash \.' | grep -q '```bash'; then
            # Has a bash block with script call - check if it has bash prefix
            if grep -A1 '```bash' "$skill" | grep '\.tessl.*scripts/bash.*\.sh' | grep -v '^bash ' | grep -qv 'bash \.'; then
                found_issue=true
                log_fail "$(basename $(dirname $skill)) missing bash prefix"
            fi
        fi
    done

    if [[ "$found_issue" == "false" ]]; then
        log_pass "all scripts have bash prefix"
    fi
}

main() {
    ORIGINAL_DIR=$(pwd)

    while [[ $# -gt 0 ]]; do
        case $1 in
            --from-local) TILE_SOURCE="local"; shift ;;
            --from-registry) TILE_SOURCE="registry"; shift ;;
            *) echo "Unknown: $1"; exit 1 ;;
        esac
    done

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║     Spec-Kit Tile Integration Tests           ║"
    echo "╚═══════════════════════════════════════════════╝"

    trap teardown EXIT

    setup
    test_scripts_exist
    test_scripts_executable
    test_templates_exist
    test_skills_exist
    test_workflow_order
    test_tdd_check_has_args
    test_bash_prefix

    log_section "Summary"
    echo "  Total:  $TESTS_RUN"
    echo -e "  ${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "  ${RED}Failed: $TESTS_FAILED${NC}"

    [[ $TESTS_FAILED -gt 0 ]] && exit 1
    exit 0
}

main "$@"
