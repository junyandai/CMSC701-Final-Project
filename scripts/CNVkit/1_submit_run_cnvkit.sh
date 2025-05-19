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

        ORIG_BAM=${RES_DIR}/${TRIO}/$SAMPLE/alignment/HZ_2022_03_sorted.bam
        ORIG_BAI=${RES_DIR}/${TRIO}/$SAMPLE/alignment/HZ_2022_03_sorted.bam.bai

        RENAMED_BAM=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam
        RENAMED_BAI=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam.bai

        if [ ! -f "$RENAMED_BAM" ]; then
            echo "Copying BAM for $SAMPLE"
            cp "$ORIG_BAM" "$RENAMED_BAM"
        else
            echo "Renamed BAM already exists for $SAMPLE"
        fi

        # Only copy BAM index if it doesn't already exist
        if [ ! -f "$RENAMED_BAI" ]; then
            echo "Copying BAM index for $SAMPLE"
            cp "$ORIG_BAI" "$RENAMED_BAI"
        else
            echo "Renamed BAI already exists for $SAMPLE"
        fi

        sbatch ${SCR} ${RENAMED_BAM} ${TRIO} ${SAMPLE}
    done
done 