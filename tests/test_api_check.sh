#!/bin/sh

# Set the path to customize.sh (relative to this script's location or assuming script is run from root)
CUSTOMIZE_SH="./customize.sh"

if [ ! -f "$CUSTOMIZE_SH" ]; then
    echo "Error: customize.sh not found. Please run this script from the root of the repository."
    exit 1
fi

# Track failures
FAILURES=0
FAILED_TESTS=""

# Function to run a single test case
run_test() {
    local api_level="$1"
    local expected_result="$2"
    local description="$3"

    echo "Running test: $description (API='$api_level')"

    # Use a subshell to isolate the test environment
    (
        # Mock functions required by customize.sh
        ui_print() {
            # Silence output or redirect to stderr for debugging
            # echo "ui_print: $*" >&2
            :
        }

        abort() {
            # echo "abort called" >&2
            exit 1
        }

        grep_prop() {
            echo "1.0"
        }

        # Mock variables
        export MODPATH="."
        export API="$api_level"

        # Source the script under test
        . "$CUSTOMIZE_SH"

    ) > /dev/null 2>&1

    local exit_code=$?

    if [ "$expected_result" = "success" ]; then
        if [ $exit_code -eq 0 ]; then
            echo "✅ PASS"
            return 0
        else
            echo "❌ FAIL: Expected success (exit code 0), got exit code $exit_code"
            return 1
        fi
    elif [ "$expected_result" = "failure" ]; then
        if [ $exit_code -ne 0 ]; then
            echo "✅ PASS"
            return 0
        else
            echo "❌ FAIL: Expected failure (non-zero exit code), got exit code 0"
            return 1
        fi
    fi
    echo "---------------------------------------------------"
}

# Test cases

# 1. API < 28 (Android 8.1 / API 27) -> Should fail
if ! run_test "27" "failure" "API level 27 (Android 8.1) - below minimum"; then
    FAILURES=$((FAILURES + 1))
    FAILED_TESTS="$FAILED_TESTS\n- API level 27 (Android 8.1) - below minimum"
fi

# 2. API = 28 (Android 9 / API 28) -> Should succeed
if ! run_test "28" "success" "API level 28 (Android 9) - minimum supported"; then
    FAILURES=$((FAILURES + 1))
    FAILED_TESTS="$FAILED_TESTS\n- API level 28 (Android 9) - minimum supported"
fi

# 3. API > 28 (Android 10 / API 29) -> Should succeed
if ! run_test "29" "success" "API level 29 (Android 10) - above minimum"; then
    FAILURES=$((FAILURES + 1))
    FAILED_TESTS="$FAILED_TESTS\n- API level 29 (Android 10) - above minimum"
fi

# 4. API > 28 (Android 11 / API 30) -> Should succeed
if ! run_test "30" "success" "API level 30 (Android 11) - above minimum"; then
    FAILURES=$((FAILURES + 1))
    FAILED_TESTS="$FAILED_TESTS\n- API level 30 (Android 11) - above minimum"
fi

# 5. Invalid API (Empty) -> Should fail
# Note: customize.sh handles empty input via 'case "$API" in ...' which calls abort.
if ! run_test "" "failure" "Empty API level"; then
    FAILURES=$((FAILURES + 1))
    FAILED_TESTS="$FAILED_TESTS\n- Empty API level"
fi

# 6. Invalid API (Non-numeric) -> Should fail
# Note: customize.sh handles non-numeric input via 'case "$API" in ...' which calls abort.
if ! run_test "abc" "failure" "Non-numeric API level"; then
    FAILURES=$((FAILURES + 1))
    FAILED_TESTS="$FAILED_TESTS\n- Non-numeric API level"
fi

echo "---------------------------------------------------"
if [ $FAILURES -eq 0 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "$FAILURES tests failed:"
    echo -e "$FAILED_TESTS"
    exit 1
fi
