#!/bin/bash


SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/CNVkit/0.3_fake_reference_chromosomes_name.sh

I5K_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna
RENAMED_I5K=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/i5k_fake_X.fna

sbatch ${SCR} ${I5K_PATH} ${RENAMED_I5K}