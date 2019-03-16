#!/bin/bash
REPOROOT=$(pwd)
TARGET_FOLDER=$REPOROOT/ChampSim/prefetcher

echo "Cleaning up original prefetchers"
rm -f $TARGET_FOLDER/*

echo "Adding custom prefetchers"
cd prefetchers > /dev/null
for prefetcher in */ ; do
    echo  "Adding $(basename -- "$prefetcher")"
    cd $prefetcher
    for file in *.cc ; do
        name=${file%.*}
        cd $TARGET_FOLDER
        ln -s ../../prefetchers/$prefetcher/$file $(basename -- $prefetcher).$name
        cd $REPOROOT/prefetchers/$prefetcher
    done
    cd ..
done
