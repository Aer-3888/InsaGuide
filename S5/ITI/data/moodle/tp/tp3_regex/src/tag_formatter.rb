#!/usr/bin/ruby -p
# Formats HTML/XML by adding newlines between tags
# -p flag automatically prints modified lines

# Replace "><" with ">\n<" to put each tag on its own line
# [^<>]* matches any characters except angle brackets
# This prevents breaking self-closed tags
$_.gsub!(/>([^<>]+)</, ">\n<")
