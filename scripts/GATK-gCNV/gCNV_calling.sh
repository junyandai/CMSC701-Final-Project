#!/bin/bash
#SBATCH --job-name=gCNV_calling
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=gCNV_calling.log
#SBATCH --error=gCNV_calling_error.log
#SBATCH --exclusive

SAMPLE_COUNT=$1
OUTPUT_DIR=$2
PLOIDY_RES_DIR=$3
SAMPLE_NAME=$4
MODLE_DIR=$5

module load miniforge3/24.3.0
export OMP_NUM_THREADS=32
conda activate gatk


TIME="/usr/bin/time"

${TIME} -v -o gCNV_calling_usage.log gatk GermlineCNVCaller \
    --run-mode CASE \
    --contig-ploidy-calls ${PLOIDY_RES_DIR} \
    --input ${SAMPLE_COUNT} \
    --model ${MODLE_DIR} \
    --output ${OUTPUT_DIR} \
    --output-prefix normal_case_run_${SAMPLE_NAME} 

