#!/bin/bash

DATA_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/LA_H.zea_Part1

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

QC_SCRIPT=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/1_run_trimming_filtering.sbatch

for SAMPLE in "${SAMPLES[@]}"; do
    
    RES_DIR=$RESULTS_DIR/$SAMPLE
    
    CUR_DATA_DIR=$DATA_DIR/$SAMPLE
    
    mkdir -p $RES_DIR
    
    cd $RES_DIR
    
    INPUT_R1=$(find $CUR_DATA_DIR -type f -name "SRR*1.fastq")
    INPUT_R2=$(find $CUR_DATA_DIR -type f -name "SRR*2.fastq")
    OUTPUT_R1_PAIRED=$RES_DIR/$(basename $INPUT_R1 | sed 's/1.fastq/R1_trimmomatic_paired.fastq.gz/')
    OUTPUT_R2_PAIRED=$RES_DIR/$(basename $INPUT_R2 | sed 's/2.fastq/R2_trimmomatic_paired.fastq.gz/')
    OUTPUT_R1_UNPAIRED=$RES_DIR/$(basename $INPUT_R1 | sed 's/1.fastq/R1_trimmomatic_unpaired.fastq.gz/')
    OUTPUT_R2_UNPAIRED=$RES_DIR/$(basename $INPUT_R2 | sed 's/2.fastq/R2_trimmomatic_unpaired.fastq.gz/') 
    CUR_LOG_FILE=$RES_DIR/trimmomatic.log

    

    sbatch $QC_SCRIPT \
        $RES_DIR \
        $INPUT_R1 \
        $INPUT_R2 \
        $OUTPUT_R1_PAIRED \
        $OUTPUT_R2_PAIRED \
        $OUTPUT_R1_UNPAIRED \
        $OUTPUT_R2_UNPAIRED \
        $CUR_LOG_FILE
done