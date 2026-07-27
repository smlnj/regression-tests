#!/bin/sh
#
# see https://github.com/smlnj/legacy/issues/378
#

# Create a whole bunch of environment variables
var_value="$(printf 'x%.0s' $(seq 1 250))"
var_defs="SML_CMD=\"$SML_CMD\""
for i in $(seq 1 100); do var_defs="$var_defs PAD_$i=$var_value"; done

# how big is the environment?
env -i PATH=$PATH $var_defs printenv | wc -c

# Now running in an environment with these vars crashes SML/NJ
env -i PATH=$PATH $var_defs $SML_CMD 378.sml
