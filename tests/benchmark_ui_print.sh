#!/bin/bash

# Benchmark for customize.sh ui_print calls

# Number of iterations
ITERATIONS=20

# Mock ui_print with delay
# Function to simulate IPC delay
mock_ui_print() {
    # Simulate IPC delay (e.g. 5ms)
    # Using python for reliable sleep if sleep command doesn't support float
    sleep 0.005 2>/dev/null || \
    python3 -c "import time; time.sleep(0.005)" 2>/dev/null || \
    true
}

grep_prop() {
    echo "1.0.0"
}

abort() {
    # echo "abort called" >&2
    exit 1
}

# Use a temporary directory to avoid modifying source files
TEMP_DIR=$(mktemp -d)
# Copy necessary files
# Note: customize.sh needs system/ directory relative to MODPATH
if [ -f "customize.sh" ]; then
    cp customize.sh "$TEMP_DIR/"
else
    # Try parent directory if running from tests/
    if [ -f "../customize.sh" ]; then
        cp ../customize.sh "$TEMP_DIR/"
        cp ../module.prop "$TEMP_DIR/" 2>/dev/null || true
        cp -r ../system "$TEMP_DIR/" 2>/dev/null || true
    else
        echo "Error: customize.sh not found"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

# Also check current dir for system if not found in parent
if [ ! -d "$TEMP_DIR/system" ] && [ -d "system" ]; then
    cp -r system "$TEMP_DIR/"
fi
if [ ! -f "$TEMP_DIR/module.prop" ] && [ -f "module.prop" ]; then
    cp module.prop "$TEMP_DIR/"
fi


# Mock variables
export MODPATH="$TEMP_DIR"
export API="30"
export MODVER="1.0.0"

run_benchmark() {
    total_time_ns=0

    echo "Running benchmark with $ITERATIONS iterations..."

    for i in $(seq 1 $ITERATIONS); do
        start_ns=$(date +%s%N)

        (
            # Re-define mocks inside subshell just in case
            ui_print() {
                # Simulate IPC delay (e.g. 5ms)
                sleep 0.005 2>/dev/null || \
                python3 -c "import time; time.sleep(0.005)" 2>/dev/null || \
                true
            }
            grep_prop() { echo "1.0.0"; }
            abort() { exit 1; }

            # Since customize.sh is sourced, we need to handle its exit/abort behavior carefully
            . "$MODPATH/customize.sh"
        ) > /dev/null 2>&1

        end_ns=$(date +%s%N)
        diff_ns=$((end_ns - start_ns))
        total_time_ns=$((total_time_ns + diff_ns))
    done

    avg_ns=$((total_time_ns / ITERATIONS))
    avg_ms=$((avg_ns / 1000000))

    echo "Average execution time: ${avg_ms} ms"
}

run_benchmark

# Cleanup
rm -rf "$TEMP_DIR"
