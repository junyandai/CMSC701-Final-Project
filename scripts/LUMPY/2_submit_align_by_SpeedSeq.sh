#!/bin/bash

ALIGMENT_SBATCH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/LUMPY/align_by_SpeedSeq.sh

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results


TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

REF_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna

counter=0

for trio in ${TRIOS[@]};
do
    for folder in $(ls $RES_DIR/$trio);
    do
        CUR_RES_DIR=$RES_DIR/$trio/$folder
        FOWARD_PAIRED=$(find $CUR_RES_DIR -type f -name "*R1_trimmomatic_paired.fastq.gz")
        REVERSE_PAIRED=$(find $CUR_RES_DIR -type f -name "*R2_trimmomatic_paired.fastq.gz")

        
        OUTPUT_DIR=${RES_DIR}/LUMPY/${trio}
        
        mkdir -p ${OUTPUT_DIR}

        OUTPUT_DIR=${OUTPUT_DIR}/${folder}

        mkdir -p ${OUTPUT_DIR}

        cd ${OUTPUT_DIR}

        echo ${OUTPUT_DIR}
        # echo ${FOWARD_PAIRED}
        # echo ${REVERSE_PAIRED}

        sbatch ${ALIGMENT_SBATCH} ${REF_PATH} ${FOWARD_PAIRED} ${REVERSE_PAIRED} ${folder}
        
        ## if there is an error submitting the job, print an error message
        if [ $? -ne 0 ]; then
            echo "Error submitting aligment job for $folder"
            exit 1
        fi
        ## if successful, then increase the counter

        if [ $? -eq 0 ]; then
            counter=$((counter+1))
            echo "Submitted aligment job for $folder"
        fi

    done
done

# output the number of jobs submitted
echo "Submitted $counter aligment jobs"

