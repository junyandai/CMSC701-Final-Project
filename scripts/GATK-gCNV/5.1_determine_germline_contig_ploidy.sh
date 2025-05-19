#!/bin/bash
#SBATCH --job-name=determine_germline_contig_ploidy
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=determine_germline_contig_ploidy.log
#SBATCH --error=determine_germline_contig_ploidy_error.log


export OMP_NUM_THREADS=32

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV

PLOIDY_RES_DIR=${RES_DIR}/ploidy-calls

mkdir -p ${PLOIDY_RES_DIR}

PRIORS_TABLE=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/contig_ploidy_priors.tsv

TARGET_INTERVAL_LIST=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/preprocess/targets.interval_list

module load miniforge3/24.3.0 

conda activate gatk


declare -a INPUT_ARGS
for f in ${RES_DIR}/Trio*/*/*.counts.hdf5; do
  INPUT_ARGS+=(--input "$f")
done

for f in ${RES_DIR}/LA_H.zea_Part1/*/*.counts.hdf5; do
  INPUT_ARGS+=(--input "$f")
done

gatk DetermineGermlineContigPloidy \
  -L ${TARGET_INTERVAL_LIST} \
  "${INPUT_ARGS[@]}" \
  --interval-merging-rule OVERLAPPING_ONLY \
  --contig-ploidy-priors ${PRIORS_TABLE} \
  --output ${PLOIDY_RES_DIR} \
  --output-prefix normal_cohort \
