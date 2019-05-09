[![Build Status][ci-img]][ci] [![Released Version][maven-img]][maven]

# Java Tooling for Scribble

This project provides Java tooling/libraries for the Scribble multi-party
protocol definition language.


## Building from source

First step is to clone this git repository locally. Once available, run the
following maven command to build the project:

    mvn [clean] install

The distribution will be available from the folder _scribble-dist/target_. The
contents of the zip is:

- lib            jars needed to run the scribble-java tool
- scribblec.sh   script for running the command line tool


## Command line usage:

Assuming scribblec.sh has been extracted from the above zip:

> List command line options.

    ./scribblec.sh --help

Assuming a Scribble module file Test.scr in the same directory:

> Check well-formedness of global protocols in module Test.scr.

    ./scribblec.sh Test.scr

Note: try the -V command line flag to obtain full traces for errors (and other
  details).

> Project local protocol for role "C" of protocol "Proto" in Test.scr

    ./scribblec.sh Test.scr -project Proto C


> Print (a dot representation of) the Endpoint FSM for role "C" of protocol 
  "Proto" in Test.scr

    ./scribblec.sh Test.scr -fsm Proto C


> Generate Java Endpoint API for role "C" of protocol "Proto"
  in Test.scr

    ./scribblec.sh -d . Test.scr -api Proto C

Note: omitting the -d argument will print the output to stdout.


## Examples:

> To write a HelloWorld protocol in Test.scr (e.g., for the commands listed above):

    echo 'module Test; global protocol Proto(role C, role S) { Hello() from C to S; }' > Test.scr


Further examples can be found in:

  https://github.com/scribble/scribble-java/tree/master/scribble-demos/scrib

The distribution zip does not include these examples.  They can be obtained as
part of the source repository, or separately via the above link.

> E.g. To generate the Java Endpoint API for role "C" in the "Adder" protocol from the
  Scribble-Java tutorial (http://www.scribble.org/docs/scribble-java.html#QUICK)

    ./scribblec.sh scribble-demos/scrib/tutorial/src/tutorial/adder/Adder.scr 
        -d scribble-demos/scrib/tutorial/src/ -api Adder C 


## Alternative command line usage:

To run the Scribble tool directly via java, try

    ./scribblec.sh --verbose [args]

to see the underlying java command with main class, classpath and other args.

Or try (from Nick Ng):

    mvn dependency:build-classpath -Dmdep.outputFile=classpath

    java -cp $(cat dist/classpath) org.scribble.cli.CommandLine [args] MyModule.scr


## Issue reporting

Bugs and issues can be reported via the github Issues facility.

Or email  r.z.h.hu1234 [at] herts.ac.uk  excluding the 1234.


  [ci-img]: https://travis-ci.org/scribble/scribble-java.svg?branch=master
  [ci]: https://travis-ci.org/scribble/scribble-java
  [cov-img]: https://coveralls.io/repos/github/scribble/scribble-java/badge.svg?branch=master
  [cov]: https://coveralls.io/github/scribble/scribble-java?branch=master
  [maven-img]: https://img.shields.io/maven-central/v/org.scribble/scribble-core.svg?maxAge=2592000
  [maven]: http://search.maven.org/#search%7Cga%7C1%7Cscribble-core

