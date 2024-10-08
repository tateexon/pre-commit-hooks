#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to run linters in the directory containing 'go.mod' files
run_linters() {
    local directory=$1
    cd "$directory" || exit 1

    echo "Executing linters in $directory..."

    # Run the linter and capture the exit status
    set +e
    golangci-lint run
    local linting_result=$?
    set -e

    # Check the linter result and provide feedback
    if [[ $linting_result -ne 0 ]]; then
        echo -e "\e[31mNOK!\e[0m"
        echo "Run 'cd $directory && golangci-lint run --fix -v' and fix the issues"
        exit 1
    else
        echo -e "\e[32mOK!\e[0m"
    fi

    cd - > /dev/null || exit 1
}

# Find all 'go.mod' files and run the linters
find "./" -type f -name 'go.mod' -print0 | while IFS= read -r -d $'\0' file; do
    directory=$(dirname "$file")
    run_linters "$directory"
done
