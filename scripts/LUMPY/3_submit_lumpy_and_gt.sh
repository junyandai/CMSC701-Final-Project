#!/bin/bash

SBATCH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/LUMPY/run_lumpy_and_genotyping.sh

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/LUMPY


TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

REF_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna



SCRIPTS_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/lumpy-sv/scripts

if [ ! -d "/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin/scripts" ]; then
    echo "bamkit not found — copying..."
    cp -r ${SCRIPTS_PATH} \
          /fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin/
else
    echo "scripts already exists — skipping copy."
fi


counter=0

for trio in ${TRIOS[@]};
do  

    for folder in $(ls $RES_DIR/$trio);
    do  
        CUR_RES_DIR=${RES_DIR}/${trio}/${folder}
        
        SAMPLE_BAM=$(find $CUR_RES_DIR -type f -name "*paired.fastq.gz.bam")
        SPLITE_BAM=$(find $CUR_RES_DIR -type f -name "*paired.fastq.gz.splitters.bam")
        DISCORD_BAM=$(find $CUR_RES_DIR -type f -name "*paired.fastq.gz.discordants.bam")

        # echo ${FOWARD_PAIRED}
        # echo ${REVERSE_PAIRED}

        cd ${CUR_RES_DIR}

        OUTPUT_VCF_NAME=${folder}

        # echo ${SAMPLE_BAM}
        # echo ${SPLITE_BAM}
        # echo ${DISCORD_BAM}
        # echo ${OUTPUT_VCF_NAME}

        echo "working on directory: $CUR_RES_DIR"

        ls -lh ${SAMPLE_BAM}
        ls -lh ${SPLITE_BAM}
        ls -lh ${DISCORD_BAM}

        echo " OUTPUT_VCF_NAME: $OUTPUT_VCF_NAME"



        sbatch ${SBATCH} ${SAMPLE_BAM} ${SPLITE_BAM} ${DISCORD_BAM} ${OUTPUT_VCF_NAME} ${CUR_RES_DIR} run
        
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


