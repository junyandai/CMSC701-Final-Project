#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/collect_read_counts.sh

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

        OUTPUT_PATH=${RES_DIR}/GATK-gCNV/${TRIO}/${SAMPLE}/${SAMPLE}.counts.hdf5

        sbatch ${SCR} ${RENAMED_BAM} ${TARGET_INTERVAL_LIST} ${OUTPUT_PATH}
    done
done 

for path in ${RES_DIR}/LA_H.zea_Part1/*/alignment; do

    path=${path}/i5k_sorted.bam

    mkdir -p ${RES_DIR}/GATK-gCNV/LA_H.zea_Part1
    sample_id=$(basename $(dirname $(dirname "$path")))  # e.g., SRX11654257
    
    CUR_RES_DIR=${RES_DIR}/GATK-gCNV/LA_H.zea_Part1/${sample_id}
    
    mkdir -p ${CUR_RES_DIR}

    cd ${CUR_RES_DIR}

    dir=$(dirname "$path")
    
    FAKED_BAM=${dir}/${sample_id}_sorted_with_fake_RG.bam
    OUTPUT_PATH=${CUR_RES_DIR}/${sample_id}.counts.hdf5
    sbatch ${SCR} ${FAKED_BAM} ${TARGET_INTERVAL_LIST} ${OUTPUT_PATH}
done