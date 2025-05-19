#!/bin/bash 


SRA_SAMPLES=( SRX11654269 
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
    SRX11654257 )

DATA_PATH="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/data"
DOWNLOAD_SCRIPT="/fs/cbcb-lab/ekmolloy/umd-ufl-collab/H.zea_trios/scripts/population_data_process/download_data.sh"

mkdir -p ${DATA_PATH}/LA_H.zea_Part1

for SRA_SAMPLE in "${SRA_SAMPLES[@]}"; do
    OUT_DIR=${DATA_PATH}/LA_H.zea_Part1/${SRA_SAMPLE}
    rm -rf $OUT_DIR
    mkdir -p $OUT_DIR
    cd $OUT_DIR
    echo "Fetching SRR run ID for ${SRA_SAMPLE}"
    sbatch ${DOWNLOAD_SCRIPT} $SRA_SAMPLE $OUT_DIR
done