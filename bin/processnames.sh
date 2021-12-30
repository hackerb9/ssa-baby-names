#!/bin/bash

main() {
    if ! cd "$maindir"; then
	echo "Error: Could not change directory to $maindir" >&2
	exit 1
    fi

    ### Merge all the yob files into a single file for easier parsing
    echo "Collating all data from yob*.txt into alldata.txt"
    alldata | pv > alldata.txt

    ###  Maximum occurances in any year, alphabetical order
    echo "Finding max occurances of each name: maxoccurances.txt"
    maxoccurances < alldata.txt  > maxoccurances.txt

    ### List of all possible names, in alphabetical order, merging sex
    echo "Creating list of all possible names: allnames.txt"
    cat maxoccurances.txt | cut -f1 -d, | pv | sort -u > allnames.txt    
}

setup() {
    # Set global variables maindir (where to write files)
    #                  and datadir (the raw data files from SSA)
    #
    # Also allow frippery such as 'pv', if installed.
    
    # The data directory is relative this script's bin directory
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

alldata() {
    # Merge the yob files into a single file for easier processing.
    # Also remove DOS carriage return.

    # Reads raw-data/yob{1880,1881,1882,..,2019,2020,2021,2022}.txt
    # Input format: <name>,<sex>,<occurances>
    # Output format is same as input format but with an additional
    # field for year: <name>,<sex>,<occurances>,<year>
    
    for f in ${datadir}/yob*.txt; do
	year=${f#*raw-data/yob}
	year=${year%.txt}
	sed 's/$/,'${year}'/; s/\r//' < "$f"
    done
}	

maxoccurances() {
    # Print to stdout a list of all the names from yob*, but include
    # the maximum number of times the name was given in any year.
    #
    # Format:	<name>,<sex>,<max>,<maxyear>
    # for example:
    # 		Mariadelosang,F,14,1997
    #
    # Note that if there is a tie for maxyear, the earlier year will be used.

    awk -F, '
        { 
	  if (max[$1$2]<$3) { max[$1$2]=$3; year[$1	$2]=$4; } 
	}

	END {
	  asorti(max, sorted)
	  for (i in sorted) {
	    x = sorted[i]
	    name = substr(x,0,length(x)-1)
	    sex = substr(x,length(x))
	    print name "," sex "," max[x] "," year[x];
	  }
	}	
    '   
}


setup
main
