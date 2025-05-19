#!/bin/bash
#SBATCH --job-name=align_SpeedSeq
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --constraint=EPYC-7313
#SBATCH --output=align_SpeedSeq.log
#SBATCH --error=align_SpeedSeq_error.log


REF=$1
FORWARD=$2
BACKWARD=$3
OUTPUT_PREFIX=$4

if [[ ! -f "$FORWARD" ]]; then
  echo "Error: need to provide $FORWARD file"
  exit 1
fi

SAMPLE_NAME=$(basename "$FORWARD")
#XFRIT_20240412_A00904_IL10019-001_N1UD-G12_L004_R1_trimmomatic_paired.fastq.gz
lib=$(echo "$SAMPLE_NAME" | cut -d'_' -f5)           # IL10019-001
sample=$(echo "$SAMPLE_NAME" | cut -d'_' -f6)        # N1UD-G12
lane=$(echo "$SAMPLE_NAME" | grep -o '_L[0-9][0-9][0-9]' | tr -d '_L')  # e.g., 004 -> 4


first_header=$(zcat "$FORWARD" | head -1)
# @A00904:378:H5MHLDSXC:4:1101:6551:1000 1:N:0:GATAGCCA+CTGTGTTG
flowcell=$(echo "$first_header" | cut -d ':' -f3)  # H5MHLDSXC

# Platform unit = flowcell.lane
pu="${flowcell}.${lane}"

rg="@RG\\tID:${sample}_L${lane}\\tSM:${sample}\\tLB:${lib}\\tPL:ILLUMINA\\tPU:${pu}"

SPEED_SEQ_PATH=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/software/speedseq/bin/speedseq

${SPEED_SEQ_PATH} align -R ${rg} ${REF} ${FORWARD} ${BACKWARD} -o ${OUTPUT_PREFIX} -t 32
