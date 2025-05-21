#!/bin/bash

RES_DIR="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref"
DATA_DIR="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data"

OLD_CHROMOS="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCA_022343045.1/ncbi_dataset/data/GCA_022343045.1/chromosomes.split"
NEW_REFERENCE="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna"

PVALUE=${1:-75}
COUNT=1
for CHROMO in $(ls ${OLD_CHROMOS}); do
    CUR_OLD_CHROMO="${OLD_CHROMOS}/${CHROMO}"
    if [[ ! ${CUR_OLD_CHROMO} == *.fai ]]; then
        CUR_OUT=${RES_DIR}/$COUNT
        COUNT=$((COUNT+1))
        echo $CUR_OUT
        sbatch ./1_run_wfmash.sbatch ${NEW_REFERENCE} ${CUR_OLD_CHROMO} ${CUR_OUT} ${PVALUE}
    fi
done