#!/bin/bash
#SBATCH --job-name=id2num
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=id2num_%j.log
#SBATCH --error=id2num_error_%j.log  

source ~/.bashrc

NEW_REF="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna"
OLD_REF="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCA_022343045.1/ncbi_dataset/data/GCA_022343045.1/GCA_022343045.1_ASM2234304v1_genomic.fna"
NEW_MAP="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/id2num.csv"
OLD_MAP="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCA_022343045.1/ncbi_dataset/data/GCA_022343045.1/id2num.csv"


python3 3_id2num.py -i $NEW_REF -o $NEW_MAP
python3 3_id2num.py -i $OLD_REF -o $OLD_MAP