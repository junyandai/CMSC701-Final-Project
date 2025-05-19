#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/postprocessgCNV.sh

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

MODEL_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/training_gCNV/normal_cohort_run-model

PLOIDY_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/ploidy-calls/normal_cohort-calls

for TRIO in ${TRIOS[@]}; do
    
    
    for SAMPLE in $(ls ${RES_DIR}/${TRIO}); do
        echo $SAMPLE
        
        CALLING_PATH=${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}/gCNV_calling
        
        cd ${CALLING_PATH}
        CALLS_PATH=${CALLING_PATH}/normal_case_run_${SAMPLE}-calls
        sbatch ${SCR} ${CALLS_PATH} ${MODEL_DIR} ${SAMPLE} ${PLOIDY_RES_DIR}
    done
done 