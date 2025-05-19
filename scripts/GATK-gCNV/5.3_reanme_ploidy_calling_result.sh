#!/bin/bash

# Set this to your ploidy call directory (e.g., cohort1-calls)
PLOIDY_CALL_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV/ploidy-calls/normal_cohort-calls

# Set output directory for renamed copies
RENAMED_DIR="${PLOIDY_CALL_DIR}-renamed"
mkdir -p "$RENAMED_DIR"

# Loop through each SAMPLE_* folder
for sample_dir in "$PLOIDY_CALL_DIR"/SAMPLE_*; do
    if [ -d "$sample_dir" ]; then
        name_file="$sample_dir/sample_name.txt"
        if [ -f "$name_file" ]; then
            sample_name=$(cat "$name_file" | tr -d '\r\n')
            dest_dir="$RENAMED_DIR/$sample_name"
            echo "[COPY] $sample_dir to $dest_dir"
            cp -r "$sample_dir" "$dest_dir"
            
        else
            echo "[WARN] Missing sample_name.txt in $sample_dir"
        fi
    fi
done


mkdir -p "$RENAMED_DIR"/LA_H.zea_Part1
mkdir -p "$RENAMED_DIR"/Trios

for sample_dir in $RENAMED_DIR/*; do
    # skip if is LA_H.zea_Part1 or Trios
    
    if [[ "$sample_dir" == *LA_H.zea_Part1* || "$sample_dir" == *Trios* ]]; then
        echo "[SKIP] $sample_dir"
        continue
    fi

    ## if sample_dir starts with SRX mv the folder to LA_H.zea_Part1
    if [[ "$sample_dir" == *SRX* ]]; then
        echo "[COPY] $sample_dir to $RENAMED_DIR/LA_H.zea_Part1"
        mv "$sample_dir" "$RENAMED_DIR"/LA_H.zea_Part1
    else
        echo "[COPY] $sample_dir to $RENAMED_DIR/Trios"
        mv "$sample_dir" "$RENAMED_DIR"/Trios
    fi
done 
