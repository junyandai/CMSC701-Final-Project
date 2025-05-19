#!/bin/bash
#SBATCH --job-name=train_gCNV
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=train_gCNV.log
#SBATCH --error=train_gCNV_error.log

module load miniforge3/24.3.0
source ~/.bashrc
export OMP_NUM_THREADS=32
conda activate gatk


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

declare -a INPUT_ARGS
for f in ${RES_DIR}/GATK-gCNV/LA_H.zea_Part1/*/*.counts.hdf5; do
  INPUT_ARGS+=(--input "$f")
done

# PLOIDY_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/ploidy-calls/normal_cohort-calls-renamed/LA_H.zea_Part1

PLOIDY_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/ploidy-calls/normal_cohort-calls

TARGET_INTERVAL_LIST=${RES_DIR}/GATK-gCNV/preprocess/targets.interval_list

OUTPUT_DIR=${RES_DIR}/GATK-gCNV/training_gCNV

mkdir -p ${OUTPUT_DIR}

gatk GermlineCNVCaller \
    --run-mode COHORT \
    --contig-ploidy-calls ${PLOIDY_RES_DIR} \
    "${INPUT_ARGS[@]}" \
    -L ${TARGET_INTERVAL_LIST} \
    --interval-merging-rule OVERLAPPING_ONLY \
    --output ${OUTPUT_DIR} \
    --output-prefix normal_cohort_run

