#!/bin/bash
#SBATCH --job-name=i5k_rename
#SBATCH --time=6:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=i5k_rename.log
#SBATCH --error=i5k_rename_error.log  

REFERENCE_PATH=$1
OUTPUT_PATH=$2
RENAME_SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/CNVkit/rename_reference_chrom_with_fake_sex.py
MAPP_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/id2num.csv

python3 ${RENAME_SCR} --map ${MAPP_PATH} --in ${REFERENCE_PATH} --out ${OUTPUT_PATH} --sex-chrom-name X

samtools faidx ${OUTPUT_PATH}