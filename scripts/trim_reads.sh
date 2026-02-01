#!/bin/bash
# Script to trim all trimmed FASTQ files using Trimmomatic

for file in ../fastq/*.fastq.gz
do
    base=$(basename "$file" .fastq.gz)

    java -jar ~/Downloads/Trimmomatic-0.40/trimmomatic-0.40.jar \
    SE -threads 2 \
    "$file" \
    "../fastq/${base}_trimmed.fastq.gz" \
    TRAILING:10 -phred33
done
