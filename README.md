# ODFAutoTests

Read the [fine introduction](doc/01_introduction.md) to learn more.

## Requirements

For use:
- Java Runtime Environment

For development:
- Java SDK
- Ant build system

## Instructions

Locate the file odftester.jar. Run

   java -jar odftester.jar config.xml tests.xml

The file config.xml specifies the ODF software that you would like to test. Adapt the provided config.xml to your environment. The file tests.xml contains the tests. A set of example tests is provided in the file texttests.xml. You can add your own tests in this file or start a completely new file.

The results of the tests are written to the file results.xml and the file results.html.

## Compilation

Run 'ant jar' to create the odftester.jar.