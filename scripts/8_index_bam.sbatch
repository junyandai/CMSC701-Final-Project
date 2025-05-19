#!/bin/bash
#SBATCH --job-name=index_bam
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=index_bam_%j.log
#SBATCH --error=index_bam_error_%j.log  

SORTED_BAM=$1
BAM_DIR=$2

cd $BAM_DIR

samtools index -@ 32 ${SORTED_BAM}