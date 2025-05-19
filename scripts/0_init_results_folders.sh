#!/bin/bash

exit 

DATA_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/HzeaTrios_BRAG2024
RESULTS_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

mkdir $RESULTS_DIR
cd $RESULTS_DIR

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

# get all folders name in each trios folder and stroe in an array

for trio in ${TRIOS[@]};
do
    mkdir $trio
    cd $trio
    for folder in $(ls $DATA_DIR/$trio);
    do
        mkdir $folder
    done
    cd ..
done

echo "Results folders created"