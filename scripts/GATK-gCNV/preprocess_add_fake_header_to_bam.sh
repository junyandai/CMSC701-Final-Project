#!/bin/bash
#SBATCH --job-name=fake_header
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=fake_header.log
#SBATCH --error=fake_header_error.log

INPUT_PATH=$1
OUTPUT_PATH=$2
SAMPLE_NAME=$3

source $HOME/.bashrc
conda activate gatk


## if exist preprocess_interval_error.log or preprocess_interval.log delete them
if [ -f preprocess_intervals_error.log ]; then
    rm preprocess_intervals_error.log
fi

if [ -f preprocess_intervals.log ]; then
    rm preprocess_intervals.log
fi

gatk AddOrReplaceReadGroups \
  -I ${INPUT_PATH} \
  -O ${OUTPUT_PATH} \
  -RGID id \
  -RGLB lib1 \
  -RGPL ILLUMINA \
  -RGPU unit1 \
  -RGSM ${SAMPLE_NAME}