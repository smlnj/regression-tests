#!/bin/sh
#
# COPYRIGHT (c) 2024 The Fellowship of SML/NJ (https://www.smlnj.org)
# All rights reserved.
#
# usage: dotest.sh testdir [-help] [-sml <sml-path>] [-diff]
#


CMD=${0##*/}\>

# determine the default path to SML/NJ
if [ -x /usr/local/smlnj/bin/sml ] ; then
  SML_PATH=/usr/local/smlnj/bin/sml
elif [ -x /usr/local/bin/sml ] ; then
  SML_PATH=/usr/local/bin/sml
else
  SML_PATH=sml
fi
SMLX=${SML:-"$SML_PATH"}

ECHO=print
DIFFS=

function printUsage {
 $ECHO -u2 "dotest.sh [options] testdir "
 $ECHO -u2 "    -sml <sml-path>     default=$SMLX"
 $ECHO -u2 "    -diff               default=off"
 $ECHO -u2 "    -help"
}

while [[ $# -ne 0 ]]
do
    arg=$1; shift
    case $arg in
      -sml)
	if [[ $# -eq 0 ]]
	then
	    $ECHO $CMD must name executable with -sml option
	    exit 1
	fi
	SMLX=$1; shift
	;;
      -diff)
	DIFFS="-diff";
	;;
      -help)
	printUsage
	exit 0
	;;
      *)
	TESTDIR=$arg
	;;
    esac
done

if [ x"$TESTDIR" = x ] ; then
    printUsage
    exit 1
fi

# get the suffix from the sml executable
#
SUFFIX=$($SMLX @SMLsuffix)

#
# Make sure output files do not exist
#
if [[ -a $TESTDIR/LOG.$SUFFIX ]]
then
    $ECHO $CMD $TESTDIR/LOG.$SUFFIX exists -- please run bin/clean.sh
    exit 1
fi

if [[ -a $TESTDIR/RESULTS.$SUFFIX ]]
then
    $ECHO $CMD $TESTDIR/RESULTS.$SUFFIX exists -- please run bin/clean.sh
    exit 1
fi

#
# Go for it
#
$ECHO $CMD Running testml.sh for $TESTDIR ...
./bin/testml.sh $TESTDIR -sml $SMLX 1>$TESTDIR/LOG.$SUFFIX
if [[ $? -eq 0 ]] ; then
    $ECHO $CMD Running process.sh for $TESTDIR $SUFFIX ...
    ./bin/process.sh $TESTDIR $SUFFIX $DIFFS 1>$TESTDIR/RESULTS.$SUFFIX 2>&1
fi
