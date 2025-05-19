#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/CNVkit/run_cnvkit.sh

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")


for TRIO in ${TRIOS[@]}; do
    for SAMPLE in $(ls ${RES_DIR}/${TRIO}); do
        echo $SAMPLE
        mkdir -p ${RES_DIR}/cnvkit/${TRIO}

        mkdir -p ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}

        cd ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}
        echo ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}
        
        rm -f ${SAMPLE}*.cns 
        rm -f ${SAMPLE}*.cnr
        rm -f ${SAMPLE}*.vcf
        rm -f ${SAMPLE}*.cnn
        
        RENAMED_BAM=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam
        RENAMED_BAI=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam.bai


        sbatch ${SCR} ${RENAMED_BAM} ${TRIO} ${SAMPLE}
    done
done 