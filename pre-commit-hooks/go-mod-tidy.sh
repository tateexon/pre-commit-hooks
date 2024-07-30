#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to run 'go mod tidy' in the directory containing 'go.mod' files
run_go_mod_tidy() {
    local directory=$1
    cd "$directory" || exit 1

    echo "Executing 'go mod tidy' in $directory"
    go mod tidy

    cd - > /dev/null || exit 1
}

# Find all 'go.mod' files and run 'go mod tidy'
find "./" -type f -name 'go.mod' -print0 | while IFS= read -r -d $'\0' file; do
    directory=$(dirname "$file")
    run_go_mod_tidy "$directory"
done

# Utilize pre-commit's stash functionality to get a diff
output=$(git diff --stat)

if [ -z "$output" ]; then
    echo "No changes in any files."
else
    echo "go.mod files that need to be tidied:"
    echo "$output" | awk -F '|' '/\|/ { print $1 }'
    exit 1
fi
