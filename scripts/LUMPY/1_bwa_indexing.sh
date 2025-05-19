#!/bin/bash
#SBATCH --job-name=bwa_indexing
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=bwa_indexing.log
#SBATCH --error=bwa_indexing_error.log

BWA_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin/bwa


REF=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna

${BWA_PATH} index ${REF}