#!/bin/bash

# This is a wrapper for a cluster scripts
# It's exected to be called from bsub
# the first argument is a script that should be executed
# the rest of the arguments are arguments of the script
# all all the other arguments will be copied locally if they are valid files
# the last argument got to be the output


# The memory should be managed via -l h_vmem=size
# However here: http://bioinformatics.mdc-berlin.de/intro2UnixandSGE/sun_grid_engine_for_beginners/how_to_submit_a_job_using_qsub.html
# they say it's per processor slot, while here: http://gridscheduler.sourceforge.net/htmlman/htmlman5/queue_conf.html?pathrev=V62u5_TAG
# They say "The per-job maximum memory limit in bytes."
# not sure what am I missing, should ask Dom next time I see him, for now, I will just not specify memory at all

set -e

#####################
# PREPARE LOCAL DIR #
#####################

WORKING_DIR=$(pwd)
LOCAL_DIR="/scratch/$USER/$JOB_ID"
mkdir -p "$LOCAL_DIR/temp"
export TMPDIR="$LOCAL_DIR/temp"

####################
# COPY INPUT FILES #
####################

for arg in "$@"; do
    # if file exists, copy it to
    if [[ -s "$arg" ]]
    then
        RELATIVE_PATH=$(dirname "$arg")
        mkdir -p $LOCAL_DIR/$RELATIVE_PATH
        rsync -a $arg $LOCAL_DIR/$RELATIVE_PATH
    fi
done

ls -l $LOCAL_DIR*

###########################
# PREPARE FOR OUTPUT FILE #
###########################

# get info about output
OUTPUT=$arg
RELATIVE_PATH=$(dirname "$OUTPUT")
# create directory for the output (both in the work dir and local dir)
mkdir -p $LOCAL_DIR/$RELATIVE_PATH
mkdir -p $WORKING_DIR/$RELATIVE_PATH

# remove script name from arguemnts
SCRIPT=$1
shift 1;

###########
# RUN JOB #
###########

cd $LOCAL_DIR

pwd
ls -l *

$SCRIPT $@

###############################
# MOVE RESULTS TO WORKING_DIR #
###############################

if [ -d $OUTPUT ]; then
    # The output put not contain the 
    rsync -a --remove-source-files $OUTPUT $WORKING_DIR/$RELATIVE_PATH
else
    rsync --remove-source-files $OUTPUT* $WORKING_DIR/$RELATIVE_PATH
fi

echo $OUTPUT
echo $WORKING_DIR
ll $WORKING_DIR/$RELATIVE_PATH

# test if the copied file exists
# if yes, delete it the local copy

############
# CLEANING #
############

# remove script and the input files (the output is hopefully already saved)
rm $SCRIPT
for arg in "$@"; do
    # if tghe argument is an existing file, remove it
    if [[ -s "$arg" ]]
    then
        rm -r $arg
    fi
done

# remove all empty direcories
find . -type d -empty -delete
rmdir "$LOCAL_DIR"
