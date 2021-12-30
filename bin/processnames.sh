#!/bin/bash

main() {
    if ! cd "$datadir"; then
	echo "Error: Could not change directory to $datadir" >&2
	exit 1
    fi

    ### List of all possible names, in alphabetical order
    echo "Creating list of all possible names: allnames.txt"
    grep -ho '[A-Za-z]*' yob* | pv | sort -u > ../allnames.txt
}

setup() {
    # Figure out data directory, relative this script's bin directory
    bindir=$(dirname "$0")
    maindir="$bindir/.."
    # Optionally cleanup pathname, if we've got GNU Core Utilities
    if type realpath >/dev/null 2>&1; then
	maindir=$(realpath "$maindir")
    fi
    datadir="$maindir/raw-data"
    
    # Make sure data directory exists
    if [[ ! -e "$datadir" ]]; then
	echo "Error: could not find data directory: $datadir" >&2
	echo "       Consider running getlatest.sh" >&2
	exit 1
    fi

    # We will use pv to shows progress. If not installed, just use cat.
    if ! type pv >/dev/null 2>&1; then
	pv() { cat "$@"; }
    fi
}

setup
main
