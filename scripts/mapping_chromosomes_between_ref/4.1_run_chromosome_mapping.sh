#!/bin/bash
#SBATCH --job-name=renmaing_mapping
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=renmaing_mapping_%j.log
#SBATCH --error=renmaing_mapping_error_%j.log  


MAPPING_FILE1="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCA_022343045.1/ncbi_dataset/data/GCA_022343045.1/id2num.csv"
MAPPING_FILE2="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data/GCF_022581195.2/ncbi_dataset/data/GCF_022581195.2/id2num.csv"

MAPPING_P75="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref/summary_all_mapping.csv"
MAPPING_P95="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref_p95/summary_all_mapping.csv"

RENAME_MAPPING_P75="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref/summary_all_mapping_renamed.csv"
RENAME_MAPPING_P95="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Mapping_Chromosomes_bewteen_Ref_p95/summary_all_mapping_renamed.csv"

python3 4_chromosome_mapping.py \
    -i $MAPPING_P75 \
    -m1 $MAPPING_FILE1 \
    -m2 $MAPPING_FILE2 \
    -o $RENAME_MAPPING_P75

python3 4_chromosome_mapping.py \
    -i $MAPPING_P95 \
    -m1 $MAPPING_FILE1 \
    -m2 $MAPPING_FILE2 \
    -o $RENAME_MAPPING_P95