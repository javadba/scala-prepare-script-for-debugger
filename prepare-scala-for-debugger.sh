#!/bin/bash -x
fname=$1
#cp -p $fname $fname.tmp
chmod +x $fname.tmp
#scalaexec=$(grep "exec scala" $fname | sed -e "s/\$0/$fname.tmp/g" | sed -e "s/\$*/${@:2:($#)}/g")
JVM_OPTS=$(grep "JVM_CLIENT_OPTS" $fname | tr -d '"')
execline=$(grep "exec scala" $fname)
shift
echo "cmdline=$*"
scalabuilder=$(scala -e<<-EOF
	val jvmOpts = "$JVM_OPTS".substring("$JVM_OPTS".indexOf("JVM_CLIENT_OPTS=")+"JVM_CLIENT_OPTS=".length+1)
  var fcontents="$execline".replace("\$0","$fname.tmp").replace("\$*","$*").replace("\$JVM_CLIENT_OPTS","$JVM_OPTS")
  Console.println(fcontents)
EOF
)
scalaexec=$(eval "$scalabuilder")

#$(grep "exec scala" $fname | sed -e "s/\$JVM_CLIENT_OPTS/\-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5001/g" |  sed -e "s/$fname/$fname.tmp/g" | sed -e "s/\\$0/$fname.tmp/g" | sed -e "s/\\$*/$*/g")
echo "scalaexec=$scalaexec"
cat $fname | scala -e 'var inPreamble=true;Console.println(io.Source.stdin.getLines.map(line => {inPreamble=inPreamble && (!line.trim.startsWith("!#")); System.err.println("inPreamble=%b".format(inPreamble)); if (inPreamble || line.trim.startsWith("!#")) { " "} else { line } }).mkString("\n"));' > $fname.tmp
#eval "$scalaexec $*"
eval "$scalaexec "
