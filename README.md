# Bulk RNA-Seq Analysis: Hypoxia Response in Prostate Cancer Cells

This repository contains a step-by-step bulk RNA-seq analysis workflow to study
gene expression changes in response to hypoxia in prostate cancer cell lines.

The project focuses on reproducibility, clarity, and learning-by-doing, with all
commands, scripts, and intermediate outputs organized in a structured manner.

---

## 📌 Study Background

The dataset used in this project comes from the study:

**Guo et al., Nature Communications (2019)**

The raw sequencing data were obtained from the **NCBI Gene Expression Omnibus (GEO)**
under the accession number:

**GSE106305**  
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE106305

This study investigates how prostate cancer cells respond at the transcriptional
level when exposed to **hypoxic (low oxygen) conditions**.

---

## 🎯 Biological Objective

The main goal of this analysis is to identify **genes that are differentially
expressed under hypoxia** compared to normoxia in prostate cancer cell lines.

Two cell lines are analyzed:

- **LNCaP**
- **PC3**

Only **control samples** were selected to ensure that observed changes are due to oxygen conditions and not genetic perturbations.

---

## 🧪 Sample Selection Strategy

The following experimental conditions were included:

- **LNCaP – Empty Vector**
  - Normoxia (2 replicates)
  - Hypoxia (2 replicates)

- **PC3 – siCtrl**
  - Normoxia (2 replicates)
  - Hypoxia (2 replicates)

Raw sequencing data were downloaded from the Sequence Read Archive (SRA) using
individual **SRR run identifiers**, ensuring full control over data handling.

---

## 🗂️ Project Directory Structure

Bulk_RNA_Seq/
├── fastq/              # Raw and processed FASTQ files
├── fastqc_results/     # FastQC output (HTML + ZIP)
├── multiqc_report/     # MultiQC summary report
├── scripts/            # Bash scripts used in the pipeline
├── figs/               # Screenshots and figures
├── analysis/           # Intermediate analysis files
├── alignedreads/       # Alignment outputs (future)
├── quants/             # Gene quantification results (future)
├── results/            # Final results
└── README.md




Large raw data files (SRA / FASTQ) are **not uploaded to GitHub** to keep the
repository lightweight and reproducible.

---

## 🔍 SRA Metadata Validation

Before converting SRA files to FASTQ format, metadata for selected runs was
validated using `vdb-dump`.

This step ensured:
- Correct sequencing platform
- File integrity
- Compatibility with FASTQ conversion

Metadata outputs are stored in the `analysis/` directory, while the commands used
to generate them are preserved as scripts in the `scripts/` directory.

---

## 🚀 Analysis Workflow Overview

1. Download SRA files from NCBI
2. Validate SRA metadata
3. Convert SRA → FASTQ
4. Perform quality control (FastQC)
5. Downstream processing and analysis (ongoing)

Each step is documented and reproducible.

---

## 🧠 Notes

This repository is actively evolving as the analysis progresses.
The README and scripts are updated incrementally to reflect each completed step.

## FASTQ sanity checks

Before downstream RNA-Seq analysis, FASTQ files were validated for correctness and sequencing depth.

FASTQ structure was inspected to confirm:
- Proper 4-line FASTQ format
- Presence of base quality scores
- Expected read length (76 bp)

Sequencing depth was estimated by counting total lines in each FASTQ file and dividing by four (each read occupies four lines).  
All samples showed sufficient read depth for bulk RNA-Seq differential expression analysis.


FASTQ Concatenation

Each biological sample was sequenced across multiple SRA runs (technical replicates). FASTQ files corresponding to the same biological sample were concatenated before trimming to create one FASTQ file per sample.

This ensures uniform trimming, simplifies downstream analysis, and preserves the total sequencing depth for each sample. After concatenation, each FASTQ file represents one complete biological sample and was used for further QC, trimming, alignment, and gene quantification.
