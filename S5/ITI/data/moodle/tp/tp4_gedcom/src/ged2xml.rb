#!/usr/bin/ruby
# GEDCOM to XML Converter
# Converts genealogical data from GEDCOM format to XML

# Usage message
syntaxe = "Usage: #{$0} input.ged output.xml"

# Validate number of arguments
nbarg = ARGV.size
if nbarg != 2
    abort syntaxe
end

# Rename parameters for clarity
(entree, sortie) = ARGV

# Verify input file exists
unless File.exist?(entree)
    abort "\t[Error: Input file #{entree} does not exist]\n"
end

# Open input file with error handling
begin
    fe = File.open(entree, "r")
rescue Errno::ENOENT
    abort "\t[Error: Failed to open input file #{entree}]\n"
end

# Open output file with error handling
begin
    fs = File.open(sortie, "w")
rescue Errno::ENOENT
    abort "\t[Error: Failed to open output file #{sortie}]\n"
end

# For testing: redirect output to stdout
# fs = STDOUT

# Track previous tag level for managing nested structures
last_tag_level = 0

# Stack to manage opening and closing of XML tags
tag_stack = []

# Main parsing loop
begin
    while line = fe.readline
        # Remove trailing whitespace
        line.sub!(/\s+$/, "")

        # Extract level and remainder of line
        # GEDCOM format: <level> <tag> <optional_value>
        if line =~ /\s*(\d+)\s+(.*)$/
            niv = $1.to_i
            remainder = $2

            # Add indentation based on level
            fs.print "\t" * niv
        end

        # Close tags when level decreases (moving back up the hierarchy)
        if last_tag_level > niv
            while last_tag_level > niv
                last_tag_level -= 1
                fs.print "</", tag_stack.pop, ">\n"
                fs.print "\t" * last_tag_level
            end
        elsif last_tag_level < niv
            last_tag_level = niv
        end

        # Ignore HEAD tag
        if remainder =~ /^HEAD$/
            # Skip processing

        # Class 2: Identifier lines (@ID@ INDI or @ID@ FAM)
        # These open new tags with ID attributes
        elsif line =~ /@(\d+)@\s*(INDI|FAM)$/
            balise = $2
            tag_stack.push($2)
            fs.print "<#{balise} ID=\"#{$1}\">\n"

        # Class 1: NAME tag with format "Given/SURNAME/"
        # Extract given name and surname separately
        elsif remainder =~ /NAME ([\s\w].*)\/([A-Z\-].*)\/

/
            fs.print "<NAME>#{$1}<S>#{$2}</S></NAME>\n"

        # Class 3: Reference lines (FAMS, FAMC, HUSB, WIFE, CHIL + @ID@)
        # Create empty tags with REF attributes
        elsif /(?<balise>FAMS|FAMC|HUSB|WIFE|CHIL)\s+@(?<id>\d+)@/ =~ remainder
            fs.print "<#{balise} REF=\"#{id}\"></#{balise}>\n"

        # Class 4: Event tags without values (BIRT, DEAT, MARR, MARC)
        # These open new tags that will contain DATE/PLAC children
        elsif /(?<tag>BIRT|DEAT|MARR|MARC)/ =~ remainder
            fs.print "<EVEN EV='#{tag}'>\n"
            tag_stack.push("EVEN")

        # Class 5: Tag with value (SEX, OCCU, DATE, PLAC + data)
        # Create simple element with content
        elsif /(?<tag>SEX|OCCU|DATE|PLAC)\s+(?<data>.*)$/ =~ remainder
            fs.print "<#{tag}>#{data}</#{tag}>\n"

        # Unexpected line format
        else
            print "Unexpected line: #{line}\n"
        end
    end
rescue EOFError
    # Reached end of file
end

# Close any remaining unclosed tags
while !tag_stack.empty?
    fs.print "\t" * (tag_stack.size - 1), "</", tag_stack.pop, ">\n"
end

# Close files
fe.close
fs.close
