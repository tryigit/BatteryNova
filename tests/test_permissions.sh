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

set_perm() {
  echo "set_perm: $@"
}

set_perm_recursive() {
  echo "set_perm_recursive: $@"
}

# Run the script and capture output
output=$(source customize.sh 2>&1)

echo "$output"

# Check for expected calls
if echo "$output" | grep -q "set_perm_recursive: . 0 0 0755 0644"; then
  echo "PASS: set_perm_recursive found"
else
  echo "FAIL: set_perm_recursive missing or incorrect"
  exit 1
fi

if echo "$output" | grep -q "set_perm: ./post-fs-data.sh 0 0 0755"; then
  echo "PASS: set_perm found"
else
  echo "FAIL: set_perm missing or incorrect"
  exit 1
fi
