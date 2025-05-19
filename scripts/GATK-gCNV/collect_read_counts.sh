#!/bin/bash
#SBATCH --job-name=collect_read_counts
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=collect_read_counts.log
#SBATCH --error=collect_read_counts_error.log

INPUT_BAM=$1
TARGET_INTERVAL_LIST=$2
OUTPUT_PATH=$3

source $HOME/.bashrc
conda activate gatk4_env

gatk CollectReadCounts \
		-I ${INPUT_BAM} \
		-L ${TARGET_INTERVAL_LIST} \
		-O ${OUTPUT_PATH} \
		--interval-merging-rule OVERLAPPING_ONLY

