#!/bin/bash

REPOROOT=$(git rev-parse --show-toplevel)
SIMULATOR_FOLDER=$REPOROOT/ChampSim
PULL_TRACE_SCRIPT=$SIMULATOR_FOLDER/scripts/download_dpc3_traces.sh

echo "Getting traces"

cd $SIMULATOR_FOLDER/scripts
$PULL_TRACE_SCRIPT
