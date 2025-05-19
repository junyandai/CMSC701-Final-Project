#!/bin/bash

CNVKIT_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/cnvkit

GATK_GCNV_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV

LUMPY_RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/LUMPY

SUMMARY_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/Summary
mkdir -p $CNVKIT_RES_DIR

python3 summary_total_MIR.py \
    --input-dir $CNVKIT_RES_DIR \
    --output $CNVKIT_RES_DIR/summary_MIR.csv \
    --input mendelian_consistency.csv \
    --method CNVkit

python3 summary_total_MIR.py \
    --input-dir $GATK_GCNV_RES_DIR \
    --output $GATK_GCNV_RES_DIR/summary_total_MIR.csv \
    --input overlap_mendelian_consistency.csv \
    --method GATK-gCNV

python3 summary_total_MIR.py \
    --input-dir $LUMPY_RES_DIR \
    --output $LUMPY_RES_DIR/summary_total_MIR.csv \
    --input overlap_mendelian_consistency.csv \
    --method LUMPY

FINAL_CSV_FILE=$SUMMARY_DIR/MIR.csv

head -n 1 $CNVKIT_RES_DIR/summary_MIR.csv > "$FINAL_CSV_FILE"
tail -n +2 "$CNVKIT_RES_DIR/summary_MIR.csv" >> "$FINAL_CSV_FILE"
tail -n +2 "$GATK_GCNV_RES_DIR/summary_total_MIR.csv" >> "$FINAL_CSV_FILE"
tail -n +2 "$LUMPY_RES_DIR/summary_total_MIR.csv" >> "$FINAL_CSV_FILE"