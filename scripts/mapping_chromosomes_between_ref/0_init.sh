#!/bin/bash

RES_DIR="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results"

mkdir -p ${RES_DIR}/Mapping_Chromosomes_bewteen_Ref
# list of 31 CHROMOSOMES
CHROMOS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)

for CHROMO in ${CHROMOS[@]}; do
    mkdir -p ${RES_DIR}/Mapping_Chromosomes_bewteen_Ref/${CHROMO}
done

mkdir -p ${RES_DIR}/Mapping_Chromosomes_bewteen_Ref_p95

for CHROMO in ${CHROMOS[@]}; do
    mkdir -p ${RES_DIR}/Mapping_Chromosomes_bewteen_Ref_p95/${CHROMO}
done