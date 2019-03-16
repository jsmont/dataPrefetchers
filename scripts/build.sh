#!/bin/bash

BASE_L1_PREF=$1
BASE_L2_PREF=$2
BASE_LLC_PREF=$3

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

echo -e "Branch predictor: ${BRANCH_PRED}\tLLC replacement: ${LLC_REPLACEMENT}\tL1 prefetcher: ${BASE_L1_PREF}"

L1_PREF=($(parsePrefList l1d_pref))
L2_PREF=($(parsePrefList l2c_pref))
LLC_PREF=($(parsePrefList llc_pref))

if [ -z "${$BASE_L1_PREF}" ]; then
    L1_PREF=($BASE_L1_PREF)
    if [ ! -f "$TARGET_FOLDER/$BASE_L1_PREF.l1d_pref" ]; then
        echo "L1: $BASE_L1_PREF does not exist!"
        exit 1
    fi
fi

if [ -z "${$BASE_L2_PREF}" ]; then
    L2_PREF=($BASE_L2_PREF)
    if [ ! -f "$TARGET_FOLDER/$BASE_L2_PREF.l2c_pref" ]; then
        echo "L2: $BASE_L2_PREF does not exist!"
        exit 1
    fi
fi

if [ -z "${$BASE_LLC_PREF}" ]; then
    LLC_PREF=($BASE_LLC_PREF)
    if [ ! -f "$TARGET_FOLDER/$BASE_LLC_PREF.llc_pref" ]; then
        echo "LLC: $BASE_LLC_PREF does not exist!"
        exit 1
    fi
fi

echo "L1 prefetchers: ${L1_PREF[@]}"
echo "L2 prefetchers: ${L2_PREF[@]}"
echo "LLC prefetchers: ${LLC_PREF[@]}"



for l1p in "${L1_PREF[@]}"; do
    for l2p in "${L2_PREF[@]}"; do
        for llcp in "${LLC_PREF[@]}"; do
            echo  -e "Buidling l1:${l1p}\tl2:${l2p}\tllc:${llcp}"
            $BUILDER ${BRANCH_PRED} ${l1p} ${l2p} ${llcp} ${LLC_REPLACEMENT} 1 > /dev/null
            $BUILDER ${BRANCH_PRED} ${l1p} ${l2p} ${llcp} ${LLC_REPLACEMENT} 4 > /dev/null
        done
    done
done
