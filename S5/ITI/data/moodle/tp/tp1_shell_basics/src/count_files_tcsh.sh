#!/bin/tcsh

# Count files and directories using pipes and text processing (tcsh approach)
# This script demonstrates the Unix philosophy: combine simple tools via pipes

echo "Analyse du contenu du répertoire `pwd` :"

# Count regular files: ls -l shows 'type' as first character
# Files start with '-', so grep "^-" filters for files only
echo -n "   Nombre de fichiers    : "
ls -l | grep "^-" | wc -l

# Count directories: ls -l shows directories starting with 'd'
# grep "^d" filters for directories only
echo -n "   Nombre de répertoires : "
ls -l | grep "^d" | wc -l
