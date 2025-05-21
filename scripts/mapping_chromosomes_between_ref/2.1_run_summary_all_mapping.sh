#!/bin/bash

#SBATCH --job-name=summary
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=summary_%j.log
#SBATCH --error=summary_error_%j.log  

MAPPING_P75_DIR="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref"
MAPPING_P95_DIR="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref_p95"

MAPPING_DIRS=($MAPPING_P75_DIR $MAPPING_P95_DIR)

CHROMOS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)

for CUR_MAPPING_DIR in ${MAPPING_DIRS[@]}; do
  for CHROMO in ${CHROMOS[@]}; do
    CUR_OUT_DIR=${CUR_MAPPING_DIR}/${CHROMO}
    CUR_MAPPING_PAF=${CUR_OUT_DIR}/genome_mapping.paf
    CUR_OUTPUT=${CUR_OUT_DIR}/summary_mapping.csv
    
    python3 2_summary_mapping.py -i \
        ${CUR_MAPPING_PAF} \
        -o \
        ${CUR_OUTPUT}
  done
done

for CUR_MAPPING_DIR in ${MAPPING_DIRS[@]}; do
  CUR_ALL_SUMMARY=${CUR_MAPPING_DIR}/summary_all_mapping.csv
  # append all summary results but only the header from the first file
    for CHROMO in ${CHROMOS[@]}; do
        CUR_OUT_DIR=${CUR_MAPPING_DIR}/${CHROMO}
        CUR_OUTPUT=${CUR_OUT_DIR}/summary_mapping.csv
        if [ $CHROMO -eq 1 ]; then
        head -n 1 ${CUR_OUTPUT} > ${CUR_ALL_SUMMARY}
        fi
        tail -n +2 ${CUR_OUTPUT} >> ${CUR_ALL_SUMMARY}
    done

done