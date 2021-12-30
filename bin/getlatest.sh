#!/bin/bash

# Location of US Social Security Administration's baby names, 1880 to present
url=https://www.ssa.gov/oact/babynames/names.zip

# Figure out data directory, relative this script's bin directory
dir=$(dirname "$0")
dir="$dir/../raw-data"

# Optionally cleanup pathname, if we've got GNU Core Utilities
if type realpath >/dev/null 2>&1; then
    dir=$(realpath "$dir")
fi

if [[ ! -e "$dir" ]]; then
    echo "Creating data directory: $dir"
    mkdir -p "$dir"
fi
if ! cd "$dir"; then
    echo "Error: Could not change directory to $dir" >&2
    exit 1
fi

before=$(stat --format '%Y' names.zip 2>/dev/null) || before=0

# Download the latest baby names if we do not already have them.
if ! wget -N "$url"; then
    echo "Error: Could not download '$url'" >&2
    echo "Error: Has SSA's website changed?" >&2
    exit 1
fi    

after=$(stat --format '%Y' names.zip)

if [[ $before != $after ]]; then
    echo "New data downloaded."
    echo -n "Unzipping names.zip in $dir... "
    unzip -q -o names.zip		 # -q: quiet, -o: overwrite w/o asking 
    echo "done."
else
    echo "No new data."
fi
