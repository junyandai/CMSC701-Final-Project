#!/bin/bash
#SBATCH --job-name=trimming_and_filtering
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=trimming_and_filtering.log
#SBATCH --error=trimming_and_filtering_error.log  

export TRIMMOMATIC_EXE=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/Trimmomatic-0.38/trimmomatic-0.38.jar

export FASTAWITHADAPTERSETC_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/Trimmomatic-0.38/adapters/TruSeq3-PE.fa

RESULT_DIR=$1

INPUT_R1=$2
INPUT_R2=$3

OUTPUT_R1_PAIRED=$4
OUTPUT_R2_PAIRED=$5

OUTPUT_R1_UNPAIRED=$6
OUTPUT_R2_UNPAIRED=$7

LOG_FILE=$8

cd $RESULT_DIR

java -jar $TRIMMOMATIC_EXE \
    PE \
    -threads 32 \
    -trimlog $LOG_FILE \
    $INPUT_R1 \
    $INPUT_R2 \
    $OUTPUT_R1_PAIRED \
    $OUTPUT_R1_UNPAIRED \
    $OUTPUT_R2_PAIRED \
    $OUTPUT_R2_UNPAIRED \
    ILLUMINACLIP:$FASTAWITHADAPTERSETC_PATH:2:30:10 \
    SLIDINGWINDOW:5:20 \
    MINLEN:50


