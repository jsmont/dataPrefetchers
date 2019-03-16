#!/bin/bash

REPOROOT=$(git rev-parse --show-toplevel)
SIMULATOR_FOLDER=$REPOROOT/ChampSim
TARGET_FOLDER=$REPOROOT/ChampSim/prefetcher
BUILDER=$REPOROOT/ChampSim/build_champsim.sh

cd "$SIMULATOR_FOLDER"

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

L1_PREF=($(parsePrefList l1d_pref))
L2_PREF=($(parsePrefList l2c_pref))
LLC_PREF=($(parsePrefList llc_pref))

echo "L1 prefetchers: ${L1_PREF[@]}"
echo "L2 prefetchers: ${L2_PREF[@]}"
echo "LLC prefetchers: ${LLC_PREF[@]}"

for l1p in "${L1_PREF[@]}"; do
    for l2p in "${L2_PREF[@]}"; do
        for llcp in "${LLC_PREF[@]}"; do
            echo  -e "Buidling l1:${l1p}\tl2:${l2p}\tllc:${llcp}"
            $BUILDER ${BRANCH_PRED} ${l1p} ${l2p} ${llcp} ${LLC_REPLACEMENT} 1
            $BUILDER ${BRANCH_PRED} ${l1p} ${l2p} ${llcp} ${LLC_REPLACEMENT} 4
        done
    done
done
