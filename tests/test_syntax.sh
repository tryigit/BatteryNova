#!/usr/bin/env bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists shellcheck; then
  echo "Error: shellcheck is not installed."
  echo "Please install shellcheck to run this test."
  echo "See https://github.com/koalaman/shellcheck#installing"
  exit 1
fi

echo "Running shellcheck..."
shellcheck -x customize.sh

if [ $? -eq 0 ]; then
  echo "Syntax check passed!"
else
  echo "Syntax check failed!"
  exit 1
fi
