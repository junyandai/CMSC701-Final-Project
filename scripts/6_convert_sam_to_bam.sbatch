#!/bin/bash
#SBATCH --job-name=sam_to_bam
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=sam_to_bam_%j.log
#SBATCH --error=sam_to_bam_error_%j.log  

BOWTIE2_OUTPUT=$1
UNSORT_SAM=$2
SORT_SAM=$3

SAMTOOLS=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/samtools_build/bin/samtools

# first convet sam to bam then sort the bam file only if the conversion is successful
$SAMTOOLS view -@ 32 -bS $BOWTIE2_OUTPUT > $UNSORT_SAM && $SAMTOOLS sort -@ 32 $UNSORT_SAM -o $SORT_SAM

