#!/usr/bin/ruby
# Simple line-by-line file processor
# Demonstrates Ruby file I/O and regex basics

if ARGV.length < 1
    puts "Usage: #{$0} <filename>"
    exit 1
end

filename = ARGV[0]

File.open(filename, "r") do |file|
    file.each_line do |line|
        # Process each line - examples:

        # Remove leading/trailing whitespace
        line.strip!

        # Skip empty lines
        next if line.empty?

        # Example: Print lines containing 'a'
        puts line if line =~ /a/
    end
end
