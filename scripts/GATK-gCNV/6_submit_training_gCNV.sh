#!/bin/bash

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results
OUTPUT_DIR=${RES_DIR}/GATK-gCNV/training_gCNV

mkdir -p ${OUTPUT_DIR}

cd ${OUTPUT_DIR}

sbatch /fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/training_gCNV.sh