#!/usr/bin/ruby
# Analyzes C source code for various patterns
# Demonstrates multiple regex patterns for code analysis

def analyze_file(filename)
    File.open(filename, "r") do |file|
        line_num = 0
        file.each_line do |line|
            line_num += 1

            # Find function definitions (simplified pattern)
            if line =~ /^\w+\s+\w+\s*\([^)]*\)\s*\{?/
                puts "#{line_num}: Possible function definition"
            end

            # Find while loops
            if line =~ /\bwhile\s*\(/
                puts "#{line_num}: While loop"
            end

            # Find for loops
            if line =~ /\bfor\s*\(/
                puts "#{line_num}: For loop"
            end

            # Find labels (for goto)
            if line =~ /^\s*\w+\s*:/
                puts "#{line_num}: Label definition"
            end

            # Find goto statements
            if line =~ /\bgoto\s+\w+/
                puts "#{line_num}: Goto statement"
            end

            # Find multi-line comments start
            if line =~ /\/\*/
                puts "#{line_num}: Comment block starts"
            end
        end
    end
end

# Run if called directly
if __FILE__ == $0
    if ARGV.length < 1
        puts "Usage: #{$0} <c_source_file>"
        exit 1
    end

    analyze_file(ARGV[0])
end
