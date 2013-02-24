#!/bin/sh
export JAVA_OPTS=-Dfile.encoding=ISO-8859-1
export JVM_CLIENT_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5001"
exec scala -J$JVM_CLIENT_OPTS -cp classes:. $0 $*
!#
var inPreamble=true
val map=io.Source.stdin.getLines.map(line => {
  inPreamble=inPreamble && (!line.trim.startsWith("#!"))
    if (inPreamble && !line.trim.startsWith("#!")) { " "}
    else { line } })
Console.println(map.mkString(","))
Console.println("first one!")
Console.println("hey there world args are %s %s".format(args(0), args(1)))
