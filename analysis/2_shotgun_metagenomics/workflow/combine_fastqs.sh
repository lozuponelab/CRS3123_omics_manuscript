#!/bin/bash

### this script combines raw FASTQ files into one for analysis ###
### author: madi apgar                                         ###

## pulls values from the second column of the file to use to combine fastqs
sampleList=$(tail -n+2 shotgun_metaG_sampleid_key.txt | cut -f2)

## runs each value through the loop to combine the forward/reverse fastq files into one per sample 
for ID_SAMPLE in ${sampleList}
do
 ## had to pull new line white space off of the end of each variable since from tab-delimited file 
 FIXED_ID_SAMPLE=$(echo ${ID_SAMPLE} | tr -d [:space:])
 ID_NUM=$(echo ${FIXED_ID_SAMPLE} | sed -e 's/LOZ_/S/g')

## need to use cat instead of zcat to combine gzipped files that you want to stay in gzipped format! 
## zcat uncompresses the files so you're not actually getting a gzipped output
## to check if files are gzipped: file <file name> or gzip -t -v <file name>
echo "combining forward reads!"
cat L002/${FIXED_ID_SAMPLE}_${ID_NUM}_L002_R1_001.fastq.gz L006/${FIXED_ID_SAMPLE}_${ID_NUM}_L006_R1_001.fastq.gz > combined/${FIXED_ID_SAMPLE}_R1_001.fastq.gz
echo "forward1: L002/${FIXED_ID_SAMPLE}_${ID_NUM}_L002_R1_001.fastq.gz forward2: L006/${FIXED_ID_SAMPLE}_${ID_NUM}_L006_R1_001.fastq.gz output: combined/${FIXED_ID_SAMPLE}_R1_001.fastq.gz"

echo "combining reverse reads!"
cat L002/${FIXED_ID_SAMPLE}_${ID_NUM}_L002_R2_001.fastq.gz L006/${FIXED_ID_SAMPLE}_${ID_NUM}_L006_R2_001.fastq.gz > combined/${FIXED_ID_SAMPLE}_R2_001.fastq.gz
echo "reverse1: L002/${FIXED_ID_SAMPLE}_${ID_NUM}_L002_R2_001.fastq.gz reverse2: L006/${FIXED_ID_SAMPLE}_${ID_NUM}_L006_R2_001.fastq.gz output: combined/${FIXED_ID_SAMPLE}_R2_001.fastq.gz"

done