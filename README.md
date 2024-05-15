# SML/NJ Regression Testing

This directory contains regression test suites and shell scripts for
running them.

## Overview

There are a number of active test suites, found in the directories:

* `coresml` -- core SML tests (based on tests from Peter Sestoft)
* `typing` -- type checking
* `modules` -- modules
* `bugs` -- bug tests
* `basis` -- Basis tests (based on tests from Peter Sestoft)[^filesys]
* `printing` -- miscellaneous printing tests

Each test suite directory contains two subdirectories

* `tests` -- source files for tests[^variants]
* `outputs` -- corresponding output files[^output]

and a file

* `openbugs`

that lists test files with known problems in the current version
of **SML/NJ** (*i.e.*, known regression failures).[^setup]

## Scripts

* `bin/testml.sh` -- performs tests in a suite
* `bin/process.sh` -- generates report of results
* `bin/dotest.sh` -- combines testml.sh and process.sh
* `bin/doallseq.sh` -- performs all suites one after another
* `bin/doallpar.sh` -- performs all suites in parallel

Normally one will execute one of `dotest.sh`, `doallseq.sh`, or
`doallpar.sh`.  The scripts are designed not to interfere with one
another, so that test suites can be executed concurrently on a given
architecture, and also on multiple machines (or varying architectures)
sharing the file system containing this directory.

For a particular architecture and operating system, arch-os,
`bin/testml.sh` produces a file <testdir>/LOG.arch-os and
a directory <testdir>/bad.arch-os. process.sh <testdir> then
produces a file <testdir>/RESULTS.arch-os.

Before running a regression test suite, any old copies of these files
and directories should be removed (if not, the scripts will complain).

### `bin/dotest.sh`

> `bin/dotest.sh` `<testdir>` [ *options* ]

runs the tests in `<testdir>`, which should be one of the directories
listed above (*e.g.*, `coresml`, `typing`, *etc*).  The options are

* `-sml <filename>`
  the path to the sml command to be used.  If this option is not
  supplied, then the value of shell variable `SML` is used instead.
  If `SML` is not defined, then the default path `/usr/local/smlnj/bin/sml`
  is used.

* `-diff`
  this option causes the diff between the test output and
  the corresponding reference output (in `<testdir>/outputs`) to be
  included in the `RESULT` file, overriding the default behavior, which
  is to include the old and new outputs in full.

### `bin/doallseq.sh`

### `bin/doallpar.sh`

## Example

Assume that the host system is an Intel processor running Linux.
Then we start by removing any old output:
``` bash
rm -rf bugs/*.amd64-linx
```
Then we run the tests using the specified version of *SML/NJ*
``` bash
bin/dotest.sh bugs -diff -sml /usr/local/smlnj/bin/sml
```

Then review the file `bugs/RESULTS.amd64-linux` to see if there are
any discrepancies, which could be unexpected failures or bug fixes.

[^filesys]: The test `basis/tests/filesys.sml` is sensitive to file
permissions and may produce spurious failures ("EXN" instead of "OK")
if the tester is not the owner of the files in basis/tests.

[^setup]: After you have created tests directory (say by checking
out from the Chicago gforge SVN repository), be sure to read the
instructions in `tests/basis/tests/README`.  This file explains
how to set up some symbolic and hard links needed by the `filesys.sml`
test.

[^variants]: Some tests depend on the word size of the target
architecture (*i.e.*, 32 vs 64 bit).  For these, we use the convention
of appending a suffix of either "-32bit" or "-64bit" to the test
file name (and to the corresponding output file name).  Such tests
are only run when the SML wordsize matches the size specified by
the suffix.

[^output]: There are actually two versions of the outputs directory
for each test suite. These are named with the **SML/NJ** versions that
they match as follows:
* outputs.legacy -- outputs for the Legacy versions (110.97 and later)
* outputs -- outputs for the development versions (2023.1 and later)
