#!/bin/bash
#SBATCH --job-name=bowtie2_build
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=bowtie2_build_%j.log
#SBATCH --error=bowtie2_build_error_%j.log  


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/

cd $RES_DIR

REFERENCE_PATH=$1
#/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/GCF_022581195.2_ilHelZeax1.1_genomic.fna
#/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCA_022343045.1/ncbi_dataset/data/GCA_022343045.1/GCA_022343045.1_ASM2234304v1_genomic.fna

INDEX_DIR=$2
#/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Hzea_index/Hzea_index
#/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GAR_index/GAR_index

mkdir -p $INDEX_DIR

BOWTIE2_BUILD=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/bowtie2/bowtie2-build



cd $INDEX_DIR

echo $INDEX_DIR

pwd

$BOWTIE2_BUILD \
    $REFERENCE_PATH \
    $INDEX_DIR \
    --threads 32