#!/usr/bin/ruby -n
# Simulates grep functionality using Ruby regex
# Demonstrates various pattern matching techniques
# Usage: ./grep_simulator.rb < input_file

# Match lines with standard tags (label: format)
# Example: "main:", "loop:", etc.
# print if ($_ =~ /^[ \t]*[a-z0-9]+[ \t]*:/)

# Match lines starting with non-word, non-space characters
# Useful for finding special characters at line start
print if ($_ =~ /^\s*[^\w\s]/)

# Match lines containing 'while' keyword
# print if ($_ =~ /while/)

# Match increment/decrement operators
# Need to escape + since it's a regex metacharacter
# print if ($_ =~ /\+\+/)

# Match non-empty lines
# \S matches any non-whitespace character
# print if ($_ =~ /^\s*\S.*$/)

# Transform: Remove leading whitespace
# Uncommenting next two lines would trim lines
# $_.sub!(/^\s+/,"")
# print $_

# Transform: Compress multiple spaces to single space
# Only apply to comment blocks
# $_.gsub!(/\s\s+/," ") if ($_ =~ /\/\*/)
# print $_
