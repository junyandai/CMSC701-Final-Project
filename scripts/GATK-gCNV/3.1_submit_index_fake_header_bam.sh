#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/8_index_bam.sbatch

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

TARGET_INTERVAL_LIST=${RES_DIR}/GATK-gCNV/preprocess/targets.interval_list

for TRIO in ${TRIOS[@]}; do
    mkdir -p ${RES_DIR}/GATK-gCNV/${TRIO}
    
    for SAMPLE in $(ls ${RES_DIR}/${TRIO}); do
        echo $SAMPLE
        

        mkdir -p ${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}

        cd ${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}
        echo ${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}
        
        
        RENAMED_BAM=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted_with_fake_RG.bam

        # RENAMED_BAI=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam.bai

        sbatch ${SCR} ${RENAMED_BAM} ${RES_DIR}/${TRIO}/${SAMPLE}/alignment/
    done
done 

for path in ${RES_DIR}/LA_H.zea_Part1/*/alignment; do

    path=${path}/i5k_sorted.bam

    sample_id=$(basename $(dirname $(dirname "$path")))  # e.g., SRX11654257
    dir=$(dirname "$path")
    
    cd $dir

    FAKED_BAM=${dir}/${sample_id}_sorted_with_fake_RG.bam
    sbatch ${SCR} ${FAKED_BAM} ${dir}
done









