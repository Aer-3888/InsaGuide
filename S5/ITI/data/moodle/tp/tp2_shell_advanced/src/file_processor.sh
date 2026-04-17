#!/bin/bash

# Advanced file processing script
# Demonstrates loops, conditionals, and file testing
# Based on exo02 from original TP

nbfic=0
nbdir=0

# Process all items in current directory
for e in $(ls); do
    if [ -f "$e" ]; then
        nbfic=$((nbfic+1))
    elif [ -d "$e" ]; then
        nbdir=$((nbdir+1))
    fi
done

printf "%d files and %d directories\n" $nbfic $nbdir
