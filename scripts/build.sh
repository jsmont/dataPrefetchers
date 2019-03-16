#!/bin/bash

#Parse initial arguments

REPOROOT=$(git rev-parse --show-toplevel)
SIMULATOR_FOLDER=$REPOROOT/ChampSim
BUILDER=$REPOROOT/ChampSim/build_champsim.sh
JOBS_FILE=$REPOROOT/scripts/jobs

cd "$SIMULATOR_FOLDER"

#Compilation
while read JOB
do
    echo  -e "Buidling ${JOB}"
    $BUILDER $JOB 1 > /dev/null
    $BUILDER $JOB 4 > /dev/null
done < $JOBS_FILE
