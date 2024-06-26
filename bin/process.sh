#! /bin/sh
#
# COPYRIGHT (c) 2024 The Fellowship of SML/NJ (https://www.smlnj.org)
# All rights reserved.

# process.sh -- processes a log created by testml from
# the commands:
#
#      script LOG
#      testml [testml options] 2>/dev/null
#
# For all tests that fail or possible bug fixes, the source code and
# the conflicting outputs are concatenated.
# For openbugs and new test cases, the source file and generated output
# is concatenated.

#
# Usage process.sh  <testdir> <heap-suffix> [options]
# [-log <log-file>] [-test <test-dir>] [-bad <baddir>]
#

#
# Command line processing.
#

# initial default values for usage message
TESTDIR=bugs
BADDIR=$TESTDIR/bad.$SUFFIX
LOGFILE=$TESTDIR/LOG.$SUFFIX
DIFF=0

function printUsage {
  echo "Usage: process.sh <testdir> <heap-suffix> [ options ]"
  echo "Options:"
  echo "    -log <log-file>     default=$LOGFILE"
  echo "    -bad <baddir>       default=$BADDIR"
  echo "    -diff               default=<no diffs>"
  echo "    -help               print this message"
}

#
# testdir must be the first (manditory) parameter.
#
case x"$1" in
  x) printUsage; exit 1 ;;
  x-*)  printUsage; exit 1 ;;
  *) TESTDIR=$1; shift ;;
esac

#
# heapsuffix must be the second (manditory) parameter.
#
case x"$1" in
  x) printUsage; exit 1 ;;
  x-*)  printUsage; exit 1 ;;
  *) SUFFIX=$1; shift ;;
esac

BADDIR=$TESTDIR/bad.$SUFFIX
LOGFILE=$TESTDIR/LOG.$SUFFIX

while [[ $# -ne 0 ]]
do
    arg=$1; shift
    case $arg in
      -log)
		if [[ $# -eq 0 ]]
		then
		    echo "Error: must provide log file with -log option"
		    exit 1
		fi
		LOGFILE=$1; shift
		;;
      -bad)
		if [[ $# -eq 0 ]]
		then
		    echo "Error: must provide bad directory with -bad option"
		    exit 1
		fi
		BADDIR=$1; shift
		;;
      -diff)
		DIFF=1
		;;
      -help)
		printUsage
		exit 1
		;;
      *)
		printUsage
		exit 1
   esac
done

#
# make sure that testing directory has correct structure.
#
if [[ ! (-d $TESTDIR/tests) ]]
then
	echo "process> $TESTDIR does not contain a tests subdirectory"
	exit 1
elif [[ ! (-d $TESTDIR/outputs) ]]
then
	echo "process> $TESTDIR does not contain an outputs subdirectory"
	exit 1
fi

#
# test if the output directory and LOG file exists
#
if [[ ! ( -d $BADDIR) ]]
then
	echo "process> output directory ($BADDIR) does not exist."
	exit 1
elif [[ ! ( -a $LOGFILE) ]]
then
	echo 'process> log-file ($LOGFILE) does not exist.'
	exit 1
fi

#
# generate the various sets of files.

FAIL=`cat $LOGFILE | grep fail | awk '{print $3}'`
OPENBUGS=`cat $LOGFILE | grep unchanged | awk '{print $3}'`
FIXED=`cat $LOGFILE | grep fix | awk '{print $3}'`
NEW=`cat $LOGFILE | grep exist | awk '{print $3}'`

#
# Process files that failed
#
function changedFiles
{
    for f in $1
    do
	  echo :::::::::::::::::::::::::::::$f::::::::::::::::::::::::::
	  cat $TESTDIR/tests/$f
	  if [[ $DIFF -eq 0 ]]
	  then
	     echo ---------------------------bad---------------------------
	     cat $BADDIR/${f%.sml}.out
  	     echo ---------------------------outputs-----------------------
  	     cat $TESTDIR/outputs/${f%.sml}.out
 	     echo " "
	  else
	    echo ---------------------------diff--------------------------
	    echo diff -w -B $BADDIR/${f%.sml}.out  $TESTDIR/outputs/${f%.sml}.out
	    diff -w -B $BADDIR/${f%.sml}.out  $TESTDIR/outputs/${f%.sml}.out
	  fi
    done
}

function newFiles
{
    for f in $NEW
    do
	  echo :::::::::::::::::::::::::::$f::::::::::::::::::::::::::::
	  cat $TESTDIR/tests/$f
	  echo ---------------------------new----------------------------
	  cat $BADDIR/${f%.sml}.out
	  echo " "
    done
}

function unchangedFilesOLD
{
    for f in $OPENBUGS
    do
	  echo :::::::::::::::::::::::::::$f::::::::::::::::::::::::::::
	  cat $TESTDIR/tests/$f
	  echo -------------------------unchanged-----------------------
	  cat $TESTDIR/outputs/${f%.sml}.out
	  echo " "
    done
}

function unchangedFiles
{
    for f in $OPENBUGS
    do
          echo $f
    done
}

function banner
{
  echo "**************************************************"
  print $BANNER
  echo "**************************************************"
}


#
# go for it!
#
BANNER="\t\tTESTS  THAT   FAILED"
banner
changedFiles "$FAIL"

BANNER="\t\tPOTENTIAL BUG FIXES"
banner
changedFiles "$FIXED"

BANNER="\t\tNEW TEST CASES"
banner
newFiles


BANNER="\t\tOPENBUGS"
banner
unchangedFiles
