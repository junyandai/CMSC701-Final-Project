#!/bin/bash

SAM_TO_BAM_SBATCH=6_convert_sam_to_bam.sbatch
RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results
TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")
counter=0

ALIGNMENT_NAME=$1

for trio in ${TRIOS[@]};
do
    for folder in $(ls $RES_DIR/$trio);
    do
        CUR_RES_DIR=$RES_DIR/$trio/$folder/alignment
        
        ALIGMENT_SAM=$(find $CUR_RES_DIR -type f -name "${ALIGNMENT_NAME}.sam")
        
        UNSORT_BAM=${CUR_RES_DIR}/${ALIGNMENT_NAME}_unsorted.bam
        
        SORT_BAM=${CUR_RES_DIR}/${ALIGNMENT_NAME}_sorted.bam
        
        echo $ALIGMENT_SAM
        echo $UNSORT_BAM
        echo $SORT_BAM

        sbatch \
            $SAM_TO_BAM_SBATCH \
            $ALIGMENT_SAM \
            $UNSORT_BAM \
            $SORT_BAM

        ## if there is an error submitting the job, print an error message
        if [ $? -ne 0 ]; then
            echo "Error submitting sam to bam job for $folder"
            exit 1
        fi
        ## if successful, then increase the counter

        if [ $? -eq 0 ]; then
            counter=$((counter+1))
            echo "Submitted sam to bam job for $folder"
        fi

    done
done