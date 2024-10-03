#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory to run cargo fmt in, default to current directory
RUST_DIR=${1:-.}

# Function to format rust code
run_cargo_fmt() {
    echo "Executing 'cargo fmt'"
    cd "$RUST_DIR"
    cargo fmt
}

run_cargo_fmt

# Utilize pre-commit's stash functionality to get a diff
output=$(git diff --stat)

if [ -z "$output" ]; then
    echo "No changes in any files."
else
    echo "files that weren't formatted:"
    echo "$output" | awk -F '|' '/\|/ { print $1 }'
    exit 1
fi
