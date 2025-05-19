#!/bin/bash


RES_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results

SCR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/CNVkit/0.1_fake_chromosomes_name.sh

TRIOS=("Trio1" "Trio2" "Trio3" "Trio4")


for TRIO in ${TRIOS[@]}; do
    for SAMPLE in $(ls ${RES_DIR}/${TRIO}); do
        echo $SAMPLE
        mkdir -p ${RES_DIR}/cnvkit/${TRIO}

        mkdir -p ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}

        cd ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}
        echo ${RES_DIR}/cnvkit/${TRIO}/${SAMPLE}

        # ORIG_BAM=${RES_DIR}/${TRIO}/$SAMPLE/alignment/HZ_2022_03_sorted.bam

        ORIG_BAM=${RES_DIR}/${TRIO}/$SAMPLE/alignment/i5k_sorted.bam

        RENAMED_BAM=${RES_DIR}/${TRIO}/${SAMPLE}/alignment/${SAMPLE}_sorted.bam

        sbatch ${SCR} ${ORIG_BAM} ${RENAMED_BAM}
        
    done
done 

exit 0 

for path in ${RES_DIR}/LA_H.zea_Part1/*/alignment; do

    path=${path}/i5k_sorted.bam

    sample_id=$(basename $(dirname $(dirname "$path")))  # e.g., SRX11654257
    dir=$(dirname "$path")
    
    cd $dir


    new_bam="${dir}/${sample_id}_i5k_sorted.bam"
    new_bai="${new_bam}.bai"
    fake_bam="${dir}/${sample_id}_i5k_sorted_fake_sex.bam"
    

    if [ ! -e "$new_bam" ]; then
        echo "Renaming $path → $new_bam"
        mv "$path" "$new_bam"
        mv "$path.bai" "$new_bai"
    else
        echo "Already renamed: $new_bam"
    fi

    sbatch ${SCR} ${new_bam} ${fake_bam}
done

