#!/bin/bash



NEW_REFERENCE="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna"

# sbatch 0.1_generate_index.sbatch ${NEW_REFERENCE}

OLD_CHROMOS="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCA_022343045.1/ncbi_dataset/data/GCA_022343045.1/chromosomes.split"

for CHROMO in $(ls ${OLD_CHROMOS}); do
    CUR_OLD_CHROMO=${OLD_CHROMOS}/${CHROMO}
    ## if not end with .fai, then submit
    if [[ ! ${CUR_OLD_CHROMO} == *.fai ]]; then
        ls ${CUR_OLD_CHROMO}
        sbatch ./0.1_generate_index.sbatch ${CUR_OLD_CHROMO}
    fi
done 