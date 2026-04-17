GDB Quick Reference for FUS5 TP
================================

Compilation:
-----------
gcc -g principal.c tableau.c -o principal

Starting GDB:
------------
gdb ./principal
gdb --args ./principal arg1 arg2

Essential Commands:
------------------
run (r)                      # Start program
run arg1 arg2                # Start with arguments
break main (b main)          # Set breakpoint at main()
break principal.c:42         # Set breakpoint at line 42
break inverseValeurs         # Set breakpoint at function
info breakpoints             # List all breakpoints
delete 1                     # Delete breakpoint #1

Execution Control:
-----------------
continue (c)                 # Continue until next breakpoint
next (n)                     # Execute next line (step over)
step (s)                     # Execute next line (step into)
finish                       # Run until current function returns
until 50                     # Run until line 50

Inspection:
----------
print variable (p variable)  # Print value of variable
print *pointer               # Dereference pointer
print array[0]@10            # Print 10 elements of array
display variable             # Auto-print after each step
info locals                  # Show all local variables
info args                    # Show function arguments
whatis variable              # Show type of variable

Call Stack:
----------
backtrace (bt)               # Show call stack
frame 0                      # Switch to stack frame 0
up                           # Move up one frame
down                         # Move down one frame

Source Code:
-----------
list (l)                     # Show source around current line
list main                    # Show source of main function
list 40,50                   # Show lines 40-50

Breakpoint on inverseValeurs:
-----------------------------
(gdb) break inverseValeurs
(gdb) run
(gdb) print i                # Check loop counter
(gdb) print valeurs[i]       # Examine array element
(gdb) continue

Tips:
----
- Compile with -g flag ALWAYS
- Use TAB for command completion
- Press ENTER to repeat last command
- Ctrl+X A for TUI mode (source window)
- Use 'quit' or Ctrl+D to exit
