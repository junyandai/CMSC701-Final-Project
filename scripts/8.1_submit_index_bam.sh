#!/bin/bash


RES_DIR="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results"
TRIOS=( Trio1 Trio2 Trio3 Trio4 )
# REFS_TYPES=( GAR HZ_2022_03 )
REFS_TYPES=( GAR i5k )
for TRIO in "${TRIOS[@]}"; do
    CUR_TRIO_DIR="${RES_DIR}/${TRIO}"
    for SAMPLE in $(ls $CUR_TRIO_DIR); do
        CUR_ALIGNMENT_DIR="${RES_DIR}/${TRIO}/${SAMPLE}/alignment"
        for REF_TYPE in "${REFS_TYPES[@]}"; do
            CUR_BAM="${CUR_ALIGNMENT_DIR}/${REF_TYPE}_sorted.bam"
            sbatch 8_index_bam.sbatch ${CUR_BAM} ${CUR_ALIGNMENT_DIR}
        done 
    done 
done