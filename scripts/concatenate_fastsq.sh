#!/bin/bash

# ============================================
# Script: concatenate_fastq.sh
# Purpose:
#   - Concatenate multiple SRR FASTQ files
#     belonging to the same biological sample
#   - Rename FASTQ files with meaningful sample names
# ============================================

# Go to FASTQ directory
cd ~/Bulk_RNA_Seq/fastq || exit 1

echo "Starting FASTQ concatenation..."

# -------- LNCaP samples (4 SRRs per sample) --------

cat SRR7179504_pass.fastq.gz SRR7179505_pass.fastq.gz SRR7179506_pass.fastq.gz SRR7179507_pass.fastq.gz \
> LNCAP_Normoxia_S1.fastq.gz

cat SRR7179508_pass.fastq.gz SRR7179509_pass.fastq.gz SRR7179510_pass.fastq.gz SRR7179511_pass.fastq.gz \
> LNCAP_Normoxia_S2.fastq.gz

cat SRR7179520_pass.fastq.gz SRR7179521_pass.fastq.gz SRR7179522_pass.fastq.gz SRR7179523_pass.fastq.gz \
> LNCAP_Hypoxia_S1.fastq.gz

cat SRR7179524_pass.fastq.gz SRR7179525_pass.fastq.gz SRR7179526_pass.fastq.gz SRR7179527_pass.fastq.gz \
> LNCAP_Hypoxia_S2.fastq.gz

echo "LNCaP FASTQs concatenated."

# -------- PC3 samples (single SRR per sample) --------

mv SRR7179536_pass.fastq.gz PC3_Normoxia_S1.fastq.gz
mv SRR7179537_pass.fastq.gz PC3_Normoxia_S2.fastq.gz
mv SRR7179540_pass.fastq.gz PC3_Hypoxia_S1.fastq.gz
mv SRR7179541_pass.fastq.gz PC3_Hypoxia_S2.fastq.gz

echo "PC3 FASTQs renamed."

echo "FASTQ preparation complete."
