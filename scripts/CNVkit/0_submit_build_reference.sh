#!/bin/bash

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

mkdir -p ${RES_DIR}/cnvkit

cd ${RES_DIR}/cnvkit

mkdir -p ${RES_DIR}/cnvkit/LA_H.zea_Part1_reference

cd ${RES_DIR}/cnvkit/LA_H.zea_Part1_reference


SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/CNVkit/build_reference.sh

sbatch ${SCR}