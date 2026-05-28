#!/bin/bash

# Mock environment
export MODPATH="."
export API=30 # Android 11

ui_print() {
  echo "ui_print: $@"
}

abort() {
  echo "abort: $@"
  exit 1
}

grep_prop() {
  echo "1.0"
}

# Run the script and capture output
output=$(source customize.sh 2>&1)

echo "$output"

# Check if script completed successfully
if echo "$output" | grep -q "Done, please reboot system"; then
  echo "PASS: Script completed successfully"
else
  echo "FAIL: Script failed to complete"
  exit 1
fi
