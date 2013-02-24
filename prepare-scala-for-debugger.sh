#!/bin/bash
fname=$1

fnametmp="${fname%.*}.sav.${fname##*.}"
cp -p $fname $fnametmp
chmod +x $fnametmp
JVM_OPTS=$(grep "JVM_CLIENT_OPTS=" $fname | tr -d '"')
execline=$(grep "exec scala" $fname)
shift
echo "cmdline=$*"
scalabuilder=$(cat<<-EOF
	val jvmOpts = "$JVM_OPTS".substring("$JVM_OPTS".indexOf("JVM_CLIENT_OPTS=")+"JVM_CLIENT_OPTS=".length)
  var fcontents="$execline".replace("\$0","$fnametmp").replace("\$*","$*").replace("\$JVM_CLIENT_OPTS",jvmOpts)
  Console.println(fcontents)
EOF
)
scalaexec=$(echo -E "$scalabuilder" | xargs -0 scala -e)

cat $fname | scala -e 'var inPreamble=true;Console.println(io.Source.stdin.getLines.map(line => {inPreamble=inPreamble && (!line.trim.startsWith("!#")); System.err.println("inPreamble=%b".format(inPreamble)); if (inPreamble || line.trim.startsWith("!#")) { " "} else { line } }).mkString("\n"));' > $fnametmp
eval "$scalaexec "
