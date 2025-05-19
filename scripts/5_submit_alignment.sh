#!/bin/bash



ALIGMENT_SBATCH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/4_run_alignment.sbatch

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results


TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

INDEX_DIR=$1
#Hzea_index  
ALIGNMENT_NAME=$2
#HZ_2022_03.sam
#GAR.sam
counter=0

for trio in ${TRIOS[@]};
do
    for folder in $(ls $RES_DIR/$trio);
    do
        CUR_RES_DIR=$RES_DIR/$trio/$folder
        FOWARD_PAIRED=$(find $CUR_RES_DIR -type f -name "*R1_trimmomatic_paired.fastq.gz")
        REVERSE_PAIRED=$(find $CUR_RES_DIR -type f -name "*R2_trimmomatic_paired.fastq.gz")

        mkdir -p $CUR_RES_DIR/alignment

        ALIGMENT_SAM=$CUR_RES_DIR/alignment/$ALIGNMENT_NAME

        ## check if the files exist if exist then delete it 
        if [ -f $ALIGMENT_SAM ]; then
            echo "Deleting existing alignment file $ALIGMENT_SAM"
            rm $ALIGMENT_SAM
        fi
        
        cd $CUR_RES_DIR/alignment

        sbatch \
            $ALIGMENT_SBATCH \
            $FOWARD_PAIRED \
            $REVERSE_PAIRED \
            $ALIGMENT_SAM \
            $INDEX_DIR
        
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