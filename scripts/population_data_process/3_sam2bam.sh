#!/bin/bash 

RESULTS_DIR=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/results/LA_H.zea_Part1

mkdir -p $RESULTS_DIR

SAMPLES=(
    SRX11654269 
    SRX11654268 
    SRX11654267 
    SRX11654266 
    SRX11654265 
    SRX11654264 
    SRX11654263 
    SRX11654262
    SRX11654261
    SRX11654260
    SRX11654259
    SRX11654258
    SRX11654257
)

SAM2BAM_SCRICPT=/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/6_convert_sam_to_bam.sbatch

REF_INDEX_PATH=Hzea_index

for SAMPLE in "${SAMPLES[@]}"; do
    
    RES_DIR=$RESULTS_DIR/$SAMPLE
    
    mkdir -p $RES_DIR/alignment

    cd $RES_DIR/alignment

    rm -rf sam_to_bam*log
    
    ALIGNMENT_SAM=${RES_DIR}/alignment/i5k.sam
    
    UNSORT_BAM=${RES_DIR}/alignment/i5k_unsorted.bam
    
    SORT_BAM=${RES_DIR}/alignment/i5k_sorted.bam

    sbatch $SAM2BAM_SCRICPT \
        $ALIGNMENT_SAM \
        $UNSORT_BAM \
        $SORT_BAM \




    ## if there is an error submitting the job, print an error message
    if [ $? -ne 0 ]; then
        echo "Error submitting sam2bam job for $(basename $RES_DIR)"
        exit 1
    fi
    ## if successful, then increase the counter

    if [ $? -eq 0 ]; then
        counter=$((counter+1))
        echo "Submitted sam2bam job for $(basename $RES_DIR)"
    fi

done

# output the number of jobs submitted
echo "Submitted $counter sam2bam jobs"
