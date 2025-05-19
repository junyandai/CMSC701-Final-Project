#!/bin/bash
#exit 
DATA_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/HzeaTrios_BRAG2024
RESULTS_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results
SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/1_run_trimming_filtering.sbatch
TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")

for trio in ${TRIOS[@]};
do
    
    for folder in $(ls $RESULTS_DIR/$trio);
    do  
        CUR_RES_DIR=$RESULTS_DIR/$trio/$folder
        CUR_DATA_DIR=$DATA_DIR/$trio/$folder
        ## get R1 and R2 files ending with R1.fastq.gz and R2.fastq.gz
        CUR_INPUT_R1=$(find $CUR_DATA_DIR -type f -name "*R1.fastq.gz")
        CUR_INPUT_R2=$(find $CUR_DATA_DIR -type f -name "*R2.fastq.gz")

        echo $CUR_INPUT_R1
        echo $CUR_INPUT_R2
        CUR_OUTPUT_R1_PAIRED=$CUR_RES_DIR/$(basename $CUR_INPUT_R1 | sed 's/R1.fastq.gz/R1_trimmomatic_paired.fastq.gz/')
        CUR_OUTPUT_R2_PAIRED=$CUR_RES_DIR/$(basename $CUR_INPUT_R2 | sed 's/R2.fastq.gz/R2_trimmomatic_paired.fastq.gz/')
        CUR_OUTPUT_R1_UNPAIRED=$CUR_RES_DIR/$(basename $CUR_INPUT_R1 | sed 's/R1.fastq.gz/R1_trimmomatic_unpaired.fastq.gz/')
        CUR_OUTOUT_R2_UNPAIRED=$CUR_RES_DIR/$(basename $CUR_INPUT_R2 | sed 's/R2.fastq.gz/R2_trimmomatic_unpaired.fastq.gz/') 
        CUR_LOG_FILE=$CUR_RES_DIR/trimmomatic.log
        # trimmomatic
        cd ${CUR_RES_DIR}
        sbatch ${SCR} \
            $CUR_RES_DIR \
            $CUR_INPUT_R1 \
            $CUR_INPUT_R2 \
            $CUR_OUTPUT_R1_PAIRED \
            $CUR_OUTPUT_R2_PAIRED \
            $CUR_OUTPUT_R1_UNPAIRED \
            $CUR_OUTOUT_R2_UNPAIRED \
            $CUR_LOG_FILE
        ## if there is no error in the sbatch command, print the success message
        if [ $? -eq 0 ]; then
            echo "Submitted trimming and filtering job for $folder"
        fi
    done
done    
