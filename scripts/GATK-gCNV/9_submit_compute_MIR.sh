#!/bin/bash
RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/GATK-gCNV

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/GATK-gCNV/compute_MIR.sh

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")


for TRIO in ${TRIOS[@]}; do
    SAMPLE_DIR=${RES_DIR}/${TRIO}
    SAMPLES=($(find "${SAMPLE_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
    cd ${SAMPLE_DIR}



    CHILD=""
    PARENTS=()
    
    for SAMPLE in "${SAMPLES[@]}"; do
        if [[ $SAMPLE =~ _BZ[FM][12]$ ]]; then
            PARENTS+=("$SAMPLE")
        elif [[ $SAMPLE =~ \.log$ ]] ; then 
            continue
        else
            CHILD=$SAMPLE
        fi
    done

    MOTHER=${PARENTS[0]}
    FATHER=${PARENTS[1]}

    echo "  Mother: $MOTHER"
    echo "  Father: $FATHER"
    echo "  Child:  $CHILD"



    CHILD_VCF=${SAMPLE_DIR}/${CHILD}/gCNV_calling/${CHILD}_genotyped_segments.vcf
    MOTHER_VCF=${SAMPLE_DIR}/${MOTHER}/gCNV_calling/${MOTHER}_genotyped_segments.vcf
    FATHER_VCF=${SAMPLE_DIR}/${FATHER}/gCNV_calling/${FATHER}_genotyped_segments.vcf
   

    echo "  Child VCF: $CHILD_VCF"
    echo "  Mother VCF: $MOTHER_VCF"
    echo "  Father VCF: $FATHER_VCF"

   



    if [[ ! -f "$CHILD_VCF" || ! -f "$MOTHER_VCF" || ! -f "$FATHER_VCF" ]]; then
        echo "  [!] One or more VCF files do not exist. Skipping $TRIO"
        exit
    fi


    OUTPUT_CSV=${SAMPLE_DIR}/overlap_mendelian_consistency.csv

    echo " OUTPUT_CSV : $OUTPUT_CSV"

    sbatch ${SCR} ${MOTHER_VCF} ${FATHER_VCF} ${CHILD_VCF} ${OUTPUT_CSV} overlap

    OUTPUT_CSV=${SAMPLE_DIR}/genotype_mendelian_consistency.csv

    echo " OUTPUT_CSV : $OUTPUT_CSV"

    sbatch ${SCR} ${MOTHER_VCF} ${FATHER_VCF} ${CHILD_VCF} ${OUTPUT_CSV} genotype

done 
