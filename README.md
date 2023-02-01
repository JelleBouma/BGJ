# Java API and Static Verification Annotation Generator
BGJ is a tool to generate Java APIs and processes from a Scribble protocol.
Unlike previous tools, BGJ also generates annotations which can be checked by the static verifier VerCors.
This verification checks whether the input protocol is adhered to, without affecting performance or style of the generated code.

BGJ is an edit of Scribble-Java (https://github.com/scribble/scribble-java) using a new code generation module.

BGJ is the result of scientific research, please see our paper for more details: https://sungshik.github.io/papers/tacas2023.pdf

## Building from source

The main class is org.scribble.cli.CommandLine

## Command line usage:
Parameters:
- .scr file location
- Roles to generate code for, format as follows: `-api protocol role`
- Destination directory, format as follows: `-d path`
- VerCors directory, format as follows: `-vercors path`

So for example, generating code for role C and S of the Adder protocol looks as follows:
`scribble-demos\scrib\tutorial\src\tutorial\adder\Adder.scr -api Adder C -api Adder S -d scribble-demos/scrib/tutorial/ -vercors C:\vercors`

## Issue reporting

Bugs and issues can be reported via the github Issues facility.
