#!/bin/bash

# Count files and directories using loops and file tests (bash approach)
# This demonstrates bash scripting with variables, loops, and conditionals

# Initialize counters
nbfic=0
nbdir=0

# Loop through all items in current directory
# $(ls) expands to list of filenames/directories
for e in $(ls); do
    # Test if item is a regular file
    if [ -f $e ]; then
        nbfic=$((nbfic+1))    # Arithmetic expansion: increment counter
    # Test if item is a directory
    elif [ -d $e ] ; then
        nbdir=$((nbdir+1))
    fi
done

# Print results using printf (more reliable than echo for formatting)
# %d is format specifier for integers
printf "%d files and %d directories\n" $nbfic $nbdir
