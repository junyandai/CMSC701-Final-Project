#!/bin/bash
#SBATCH --job-name=cnvkit
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=cnvkit.log
#SBATCH --error=cnvkit_error.log  

BAM_FILE=$1
TRIO=$2
SAMPLE=$3

RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results
REFERENCE_GENO_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/i5k_fake_X.fna
source $HOME/.bashrc


# rm -rf cnvkit_build_reference*log

conda activate cnvkit_env



cnvkit.py batch ${BAM_FILE} \
    --reference ${RES_DIR}/cnvkit/LA_H.zea_Part1_reference/reference.cnn \
    --output-dir ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE} \
    --method wgs \

cnvkit.py call ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}/${SAMPLE}_sorted.cns \
    -o ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}/${SAMPLE}.call.cns \


cnvkit.py export vcf ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}/${SAMPLE}.call.cns \
    -i ${SAMPLE} \
    -o ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}/${SAMPLE}.call.vcf \
