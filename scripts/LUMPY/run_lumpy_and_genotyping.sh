#!/bin/bash
#SBATCH --job-name=run_lumpy
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=run_lumpy.log
#SBATCH --error=run_lumpy_error.log
#SBATCH --exclusive

SAMPLE_BAM=$1
SAMPLE_SPLIT_BAM=$2
SAMPLE_DISCORD_BAM=$3
OUTPUT_VCF_NAME=$4
WORK_DIR=$5
MODE=$6

TIME="/usr/bin/time"

module load miniforge3/24.3.0

source ~/.bashrc


cd ${WORK_DIR}

conda activate lumpy_env

# LUMPY_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin/lumpyexpress

export PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin:$PATH

PYTHON_RENAME=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/LUMPY/rename_chr_in_vcf.py

SVTYPER=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin/svtyper

echo "SPLIT BAM = ${SAMPLE_SPLIT_BAM}"
echo "DISCORD BAM = ${SAMPLE_DISCORD_BAM}"
echo "BAM = ${SAMPLE_BAM}"
ls -lh "$SAMPLE_SPLIT_BAM"


### 
if [[ "$MODE" == "run" ]]; then 
    echo "Running LUMPY"
    
    ${TIME} -v -o lumpy_usage.log lumpyexpress \
        -B "${SAMPLE_BAM}" -S "${SAMPLE_SPLIT_BAM}" -D "${SAMPLE_DISCORD_BAM}" -o "${OUTPUT_VCF_NAME}.vcf"


    echo "Working on genotyping "
    ${SVTYPER} \
        -B ${SAMPLE_BAM} \
        -S ${SAMPLE_SPLIT_BAM} \
        -i ${OUTPUT_VCF_NAME}.vcf \
        > ${OUTPUT_VCF_NAME}.gt.vcf

else
    echo "Skipping running LUMPY, just renaming vcf files"
fi

conda deactivate

NAME_MAPPING=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/id2num.csv 

echo "working on renaming vcf files"

python3 ${PYTHON_RENAME} -m ${NAME_MAPPING} -i ${OUTPUT_VCF_NAME}.gt.vcf -o ${OUTPUT_VCF_NAME}_renamed.gt.vcf --mode vcf --sample-name ${OUTPUT_VCF_NAME}