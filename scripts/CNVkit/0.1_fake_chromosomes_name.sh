#!/bin/bash
#SBATCH --job-name=alignment_rename
#SBATCH --time=6:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=alignment_rename.log
#SBATCH --error=alignment_rename_error.log  



INPUT_BAM=$1
OUTPUT_BAM=$2

source ~/.bashrc

conda activate cnvkit_env

RENMAE_SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/rename_alignment_bam_file_chrom_name.py
MAPP_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/id2num.csv


python3 ${RENMAE_SCR} --map ${MAPP_PATH} --in ${INPUT_BAM} --out ${OUTPUT_BAM} --sex-chrom-name X


samtools index -@ 32 ${OUTPUT_BAM}