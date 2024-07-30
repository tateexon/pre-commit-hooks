#!/usr/bin/env bash

# Function to check for typos
check_typos() {
    local config_option=""
    if [[ -f "./_typos.toml" ]]; then
        config_option="--config ./_typos.toml"
    fi
    typos "$config_option" --force-exclude "$@"
}

# Run the typos check
check_typos "$@"
typos_result=$?

# Check typos result
if [[ $typos_result -ne 0 ]]; then
    echo -e "❌ Found typos\n"
    if [[ -f "./_typos.toml" ]]; then
        echo -e "Run 'typos --write-changes --config ./_typos.toml --force-exclude $*' and fix any issues left\n"
    else
        echo -e "Run 'typos --write-changes --force-exclude $*' and fix any issues left\n"
    fi
    exit 1
fi
