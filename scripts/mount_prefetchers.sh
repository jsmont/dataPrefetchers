#!/bin/bash

REPOROOT=$(git rev-parse --show-toplevel)
TARGET_FOLDER=$REPOROOT/ChampSim/prefetcher
PREFETCHERS_PATH=$REPOROOT/prefetchers

echo "Adding custom prefetchers"
cd "$PREFETCHERS_PATH" 
for prefetcher in */ ; do
    echo  "Adding $(basename -- "$prefetcher")"
    cd $prefetcher > /dev/null
    for file in *.cc ; do
        name=${file%.*}
        cd "$TARGET_FOLDER"
        rm -f  $(basename -- $prefetcher).$name
        ln -s ../../prefetchers/$prefetcher/$file $(basename -- $prefetcher).$name
        cd "$PREFETCHERS_PATH/$prefetcher" > /dev/null
    done
    cd ..
done
