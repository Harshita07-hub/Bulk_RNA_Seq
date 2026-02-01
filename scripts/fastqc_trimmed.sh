#!/bin/bash

# Create output directory if not present
mkdir -p fastqc_trimmed_results

# Run FastQC on all trimmed FASTQ files
for file in fastq/*_trimmed.fastq.gz
do
    fastqc -o fastqc_trimmed_results -t 2 "$file"
done
