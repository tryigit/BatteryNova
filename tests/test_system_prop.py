#!/usr/bin/env python3
import sys
import os

def validate_system_prop(filepath):
    if not os.path.exists(filepath):
        print(f"Error: File {filepath} not found.")
        return False

    with open(filepath, 'r') as f:
        lines = f.readlines()

    errors = []
    keys = set()

    for i, line in enumerate(lines):
        line = line.strip()

        # Skip comments and empty lines
        if not line or line.startswith('#'):
            continue

        # Check for key=value format
        if '=' not in line:
            errors.append(f"Line {i+1}: Invalid format (missing '='): {line}")
            continue

        # Split into key and value
        parts = line.split('=', 1)
        key = parts[0].strip()
        value = parts[1].strip()

        if not key:
            errors.append(f"Line {i+1}: Empty key: {line}")
            continue

        if key in keys:
            errors.append(f"Line {i+1}: Duplicate key found: {key}")

        keys.add(key)

    if errors:
        print(f"Validation failed for {filepath}:")
        for error in errors:
            print(f"  - {error}")
        return False

    print(f"Validation passed for {filepath}.")
    return True

if __name__ == "__main__":
    filepath = "system.prop"
    if len(sys.argv) > 1:
        filepath = sys.argv[1]

    if validate_system_prop(filepath):
        sys.exit(0)
    else:
        sys.exit(1)
