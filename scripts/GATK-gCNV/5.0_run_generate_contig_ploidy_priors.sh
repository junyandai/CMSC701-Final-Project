#!/bin/bash
#SBATCH --job-name=generate_contig_ploidy_priors
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=generate_contig_ploidy_priors.log
#SBATCH --error=generate_contig_ploidy_priors_error.log

PY_SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/generate_contig_ploidy_priors.py


souce ~/.bashrc
conda activate ~/my_conda_env

python3 ${PY_SCR} -r /fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/i5k_fake_X.fna -o /fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/contig_ploidy_priors.tsv -z X
