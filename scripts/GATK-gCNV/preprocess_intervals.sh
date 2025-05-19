#!/bin/bash
#SBATCH --job-name=preprocess_intervals
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=preprocess_intervals.log
#SBATCH --error=preprocess_intervals_error.log

INPUT_REF=$1
OUTPUT_PATH=$2

source $HOME/.bashrc
conda activate gatk

gatk PreprocessIntervals --reference ${INPUT_REF} --bin-length 1000 --interval-merging-rule OVERLAPPING_ONLY --output ${OUTPUT_PATH}
