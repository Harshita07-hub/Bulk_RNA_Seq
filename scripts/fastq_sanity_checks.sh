#!/bin/bash

# FASTQ sanity checks
# 1. Peek at FASTQ structure
zcat fastq/SRR7179504_pass.fastq.gz | head -n 8
zcat fastq/SRR7179507_pass.fastq.gz | head -n 8
zcat fastq/SRR7179520_pass.fastq.gz | head -n 8

# 2. Count number of lines (reads = lines / 4)
zcat fastq/SRR7179504_pass.fastq.gz | wc -l
zcat fastq/SRR7179520_pass.fastq.gz | wc -l
zcat fastq/SRR7179537_pass.fastq.gz | wc -l

