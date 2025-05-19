#!/bin/bash
#SBATCH --job-name=download
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=download.log
#SBATCH --error=download_error.log  

source ~/.bashrc
conda activate ~/my_conda_env

SRA_SAMPLE=$1
OUT_DIR=$2

SRR_ID=$(esearch -db sra -query ${SRA_SAMPLE} | efetch -format runinfo | cut -d ',' -f1 | grep SRR)

fasterq-dump --split-3 --threads 32 "$SRR_ID" --outdir "$OUTDIR"




