#!/bin/bash
#SBATCH --job-name=preprocess_ref_dict
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=preprocess_ref_dict.log
#SBATCH --error=preprocess_ref_dict_error.log

INPUT_REF=$1
OUTPUT_PATH=$2
source $HOME/.bashrc
conda activate gatk4

gatk CreateSequenceDictionary \
  -R ${INPUT_REF} \
  -O ${OUTPUT_PATH}