#!/bin/bash
#SBATCH --job-name=wfmash
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=wfmash_%j.log
#SBATCH --error=wfmash_error_%j.log  

REF=$1
QUERY=$2
OUT_DIR=$3
PVALUE=$4

source ~/.bashrc
conda activate wfmash

module load gcc/11.2.0
module load bzip2/1.0.8
module load htslib/1.16

export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/wfmash/lib64:$LD_LIBRARY_PATH


WFMASH_PATH="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/wfmash/bin/wfmash"



cd $OUT_DIR
$WFMASH_PATH -t 32 \
    -p ${PVALUE} \
    $REF  \
    $QUERY \
    > genome_mapping.paf
