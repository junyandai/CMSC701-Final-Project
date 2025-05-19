#!/bin/bash
#SBATCH --job-name=cnvkit_build_reference
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=cnvkit_build_reference.log
#SBATCH --error=cnvkit_build_reference_error.log  


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results
REFERENCE_GENO_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/i5k_fake_X.fna

source ~/.bashrc

# rm -rf cnvkit_build_reference*log

conda activate cnvkit_env
sed -i '1s|^#!.*|#!/usr/bin/env python3|' $(which cnvkit.py) ## change the header in cnvkit.py since my account name was changed by umiacs

# set -euxo pipefail

cd ${RES_DIR}/cnvkit/LA_H.zea_Part1_reference

cnvkit.py batch \
    --normal ${RES_DIR}/LA_H.zea_Part1/*/alignment/*_i5k_sorted_fake_sex.bam \
    --fasta ${REFERENCE_GENO_PATH} \
    --output-reference ${RES_DIR}/cnvkit/LA_H.zea_Part1_reference/reference.cnn \
    --output-dir ${RES_DIR}/cnvkit/LA_H.zea_Part1_reference \
    --method wgs \
    -p 32