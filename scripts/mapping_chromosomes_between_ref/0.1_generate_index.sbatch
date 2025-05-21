#!/bin/bash
#SBATCH --job-name=genereate_index
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=genereate_index_%j.log
#SBATCH --error=genereate_index_error_%j.log  

INPUT=$1

samtools \
    faidx \
    ${INPUT}