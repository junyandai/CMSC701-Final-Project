#!/bin/bash

RESULTS_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/LA_H.zea_Part1

mkdir -p $RESULTS_DIR

SAMPLES=(
    SRX11654269 
    SRX11654268 
    SRX11654267 
    SRX11654266 
    SRX11654265 
    SRX11654264 
    SRX11654263 
    SRX11654262
    SRX11654261
    SRX11654260
    SRX11654259
    SRX11654258
    SRX11654257
)

ALIGNMENT_SCRIPT=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/4_run_alignment.sbatch

REF_INDEX_PATH=Hzea_index

for SAMPLE in "${SAMPLES[@]}"; do
    
    RES_DIR=$RESULTS_DIR/$SAMPLE
    
    mkdir -p $RES_DIR/alignment

    cd $RES_DIR/alignment
    
    rm -rf alignment*log

    R1_PAIRED=$(find $RES_DIR -type f -name "*R1_trimmomatic_paired.fastq.gz")
    R2_PAIRED=$(find $RES_DIR -type f -name "*R2_trimmomatic_paired.fastq.gz")
  
    sbatch $ALIGNMENT_SCRIPT \
        $R1_PAIRED \
        $R2_PAIRED \
        i5k.sam \
        $REF_INDEX_PATH



    ## if there is an error submitting the job, print an error message
    if [ $? -ne 0 ]; then
        echo "Error submitting aligment job for $(basename $RES_DIR)"
        exit 1
    fi
    ## if successful, then increase the counter

    if [ $? -eq 0 ]; then
        counter=$((counter+1))
        echo "Submitted aligment job for $(basename $RES_DIR)"
    fi

done

# output the number of jobs submitted
echo "Submitted $counter aligment jobs"