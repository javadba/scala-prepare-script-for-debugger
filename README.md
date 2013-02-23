scala-prepare-script-for-debugger
=================================

Scala has capability to run file as a script. It has preamble section enclosed by #! .. !# that unfortunately throws off debuggers because it is stripped away. This small script clones the file into tmp one, replaces preamble with blanks, the launches tmp one in debug mode. Now the debugger sees same line numbers as original source.