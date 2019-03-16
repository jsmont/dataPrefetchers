#!/bin/bash

#Parse initial arguments

NUM_BUILDS=$1
BUILD_ID=$2

REPOROOT=$(git rev-parse --show-toplevel)
TARGET_FOLDER=$REPOROOT/ChampSim/prefetcher
JOBS_FILE=$REPOROOT/scripts/jobs

rm -f $JOBS_FILE

BRANCH_PRED=perceptron
LLC_REPLACEMENT=lru

function parsePrefList(){
    local pathlist=("$TARGET_FOLDER"/*.$1)
    local namelist=()
    for f in "${pathlist[@]}"; do
        namelist+=("$(basename -- "${f%.*}")")
    done
    echo "${namelist[@]}"
}

#Configuration and case detection

echo -e "Branch predictor: ${BRANCH_PRED}\nLLC replacement: ${LLC_REPLACEMENT}"

L1_PREF=($(parsePrefList l1d_pref))
L2_PREF=($(parsePrefList l2c_pref))
LLC_PREF=($(parsePrefList llc_pref))

echo "L1 prefetchers: ${L1_PREF[@]}"
echo "L2 prefetchers: ${L2_PREF[@]}"
echo "LLC prefetchers: ${LLC_PREF[@]}"

L1_SIZE=${#L1_PREF[@]}
L2_SIZE=${#L2_PREF[@]}
LLC_SIZE=${#LLC_PREF[@]}

TOTAL_JOBS=$((L1_SIZE*L2_SIZE*LLC_SIZE))

echo -e "Total jobs: $TOTAL_JOBS"

counter=0;

#Compilation
for l1p in "${L1_PREF[@]}"; do
    for l2p in "${L2_PREF[@]}"; do
        for llcp in "${LLC_PREF[@]}"; do
            module=$((counter % NUM_BUILDS))
            if [ "$module" == "$BUILD_ID" ]; then
                echo "${BRANCH_PRED} ${l1p} ${l2p} ${llcp} ${LLC_REPLACEMENT}" >> $JOBS_FILE
            fi
            counter=$((counter+1))
        done
    done
done
