#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV
REF=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/i5k_fake_X.fna
mkdir -p ${RES_DIR}/preprocess
cd ${RES_DIR}/preprocess

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/preprocess_intervals.sh
OUTPUT=${RES_DIR}/preprocess/targets.interval_list

sbatch ${SCR} ${REF} ${OUTPUT}