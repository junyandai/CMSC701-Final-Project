#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/preprocess_add_fake_header_to_bam.sh

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

TARGET_INTERVAL_LIST=${RES_DIR}/GATK-gCNV/preprocess/targets.interval_list

for TRIO in ${TRIOS[@]}; do
    mkdir -p ${RES_DIR}/GATK-gCNV/${TRIO}
    
    for SAMPLE in $(ls ${RES_DIR}/${TRIO}); do
        echo $SAMPLE
        

        mkdir -p ${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}

        cd ${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}
        echo ${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}
        
        
        RENAMED_BAM=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam
        RENAMED_BAI=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam.bai

        OUTPUT_PATH=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted_with_fake_RG.bam

        sbatch ${SCR} ${RENAMED_BAM} ${OUTPUT_PATH} ${SAMPLE}
    done
done 

for path in ${RES_DIR}/LA_H.zea_Part1/*/alignment; do

    path=${path}/i5k_sorted.bam

    sample_id=$(basename $(dirname $(dirname "$path")))  # e.g., SRX11654257
    dir=$(dirname "$path")
    
    cd $dir

    fake_bam="${dir}/${sample_id}_i5k_sorted_fake_sex.bam"
    OUTPUT_PATH=${dir}/${sample_id}_sorted_with_fake_RG.bam
    sbatch ${SCR} ${fake_bam} ${OUTPUT_PATH} ${sample_id}
done