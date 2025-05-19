#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/gCNV_calling.sh
TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

MODEL_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/training_gCNV/normal_cohort_run-model

PLOIDY_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/ploidy-calls/normal_cohort-calls

for TRIO in ${TRIOS[@]}; do
    
    
    for SAMPLE in $(ls ${RES_DIR}/${TRIO}); do
        echo $SAMPLE
        
        OUTPUT_DIR=${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}/gCNV_calling
        
        mkdir -p ${OUTPUT_DIR}

        cd ${OUTPUT_DIR}

        SAMPLE_COUNT=${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}/${SAMPLE}.counts.hdf5

        sbatch ${SCR} ${SAMPLE_COUNT} ${OUTPUT_DIR} ${PLOIDY_RES_DIR} ${SAMPLE} ${MODEL_DIR}
    done
done 