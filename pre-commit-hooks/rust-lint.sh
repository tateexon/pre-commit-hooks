#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to run linters on the rust project
run_linter() {
    echo "Executing clippy"

    # Run the linter and capture the exit status
    set +e
    cargo clippy -- -D warnings
    local linting_result=$?
    set -e

    # Check the linter result and provide feedback
    if [[ $linting_result -ne 0 ]]; then
        echo -e "\e[31mNOK!\e[0m"
        echo "Run 'cargo clippy -- -D warnings' and fix the issues"
        exit 1
    else
        echo -e "\e[32mOK!\e[0m"
    fi
}

run_linter
