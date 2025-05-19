#!/bin/bash

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV

PLOIDY_RES_DIR=${RES_DIR}/ploidy-calls

mkdir -p ${PLOIDY_RES_DIR}

cd ${PLOIDY_RES_DIR}

sbatch /fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/5.1_determine_germline_contig_ploidy.sh