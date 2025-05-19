#!/bin/bash
#SBATCH --job-name=alignment
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=alignment_%j.log
#SBATCH --error=alignment_error_%j.log  

BOWTIE2_EXE=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/bowtie2/bowtie2
RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results


FOWARD_PAIRED=$1
REVERSE_PAIRED=$2
ALIGMENT_SAM=$3

INDEX_DIR=$RES_DIR/$4/$4


$BOWTIE2_EXE -x \
    $INDEX_DIR \
    -1 \
    $FOWARD_PAIRED \
    -2 \
    $REVERSE_PAIRED \
    --very-sensitive \
    --threads 32 \
    -S $ALIGMENT_SAM \


