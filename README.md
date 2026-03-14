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
## Read Trimming and Quality Control

After concatenation of raw FASTQ files, reads were processed to improve sequencing quality prior to downstream analysis.

### Read Trimming

Quality trimming was performed using **Trimmomatic (v0.40)** to remove low-quality bases from sequencing reads. Trimming focused on eliminating poor-quality bases from the 3′ end of reads, which commonly impact downstream analyses.

Single-end reads were trimmed using the following parameters:
- Removal of trailing bases with Phred quality scores below 10 (`TRAILING:10`)
- Phred+33 quality score encoding
- Multi-threaded execution for improved performance

All concatenated FASTQ files were trimmed in a uniform and reproducible manner using shell scripts.

### Quality Assessment of Trimmed Reads

Post-trimming quality assessment was carried out using **FastQC** to evaluate improvements in read quality. FastQC reports were generated for all trimmed FASTQ files to examine key quality metrics, including:
- Per-base sequence quality
- Sequence length distribution
- Residual low-quality regions or technical biases

FastQC was executed in batch mode, and results were organized into a dedicated output directory (`fastqc_trimmed_results/`).

## 📊 Quality Control and Visualization

The following plots were generated to assess the data and visualize results. All figures are saved in the `figs/` directory.

### PCA Plot
Principal Component Analysis shows clear separation by cell line (PC1, 99% variance) and a distinct effect of hypoxia (PC2, 1% variance). This confirms that both cell line differences and hypoxia treatment contribute to global gene expression patterns.
<img width="1248" height="701" alt="Image" src="https://github.com/user-attachments/assets/e6ad2562-039b-43b1-b2ce-a89b5a897b84" />



**Interpretation:** PC1 separates LNCaP and PC3 cells, indicating strong cell-line-specific expression differences. PC2 separates hypoxia from normoxia samples, confirming that hypoxia induces a detectable transcriptional response across both cell lines.

---

### Volcano Plot
Highly significant genes are highlighted; red points indicate upregulation under hypoxia, blue points downregulation.

<img width="1255" height="692" alt="Image" src="https://github.com/user-attachments/assets/4183494c-4075-49c3-90b9-6cc0a8f162fe" />

**Interpretation:** The volcano plot shows a large number of significantly differentially expressed genes (padj < 0.05). I observed an asymmetric distribution with more red points (upregulated) than blue (downregulated), indicating hypoxia predominantly activates gene expression rather than suppressing it.

---

### MA Plot
The MA plot shows the relationship between gene expression abundance and log fold change.



<img width="1123" height="680" alt="Image" src="https://github.com/user-attachments/assets/ebe8a7a2-c0df-439a-8c5b-d77ff144069d" />

**Interpretation:** The MA plot confirms no systematic bias in my fold change estimates. Genes with low mean expression show expected higher variance, but no obvious trend or skew is observed, validating the DESeq2 normalization.

---

### Heatmap of Top 50 DE Genes
Unsupervised clustering of the top 50 most significant genes.


<img width="1019" height="689" alt="Image" src="https://github.com/user-attachments/assets/83d717ca-70b2-4937-af0e-ed6f81a94ed0" />

**Interpretation:** The heatmap clearly separates hypoxia samples from normoxia samples, indicating a robust and consistent transcriptional response. Within hypoxia samples, LNCaP and PC3 show distinct expression patterns, suggesting cell-type-specific hypoxia responses.

---

## 🧬 Gene Set Enrichment Analysis (GSEA)

To identify biological pathways altered by hypoxia, I performed GSEA using Hallmark gene sets.

### Top Enriched Pathways

| Hallmark Pathway | NES | p.adjust |
|------------------|-----|----------|
| HALLMARK_HYPOXIA | 2.83 | 0.0012 |
| HALLMARK_GLYCOLYSIS | 2.51 | 0.0015 |
| HALLMARK_MTORC1_SIGNALING | 2.20 | 0.0021 |
| HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION | 1.95 | 0.0034 |

#### Dotplot
![GSEA Dotplot](https://raw.githubusercontent.com/harshitap26/Bulk_RNA_Seq/main/figs/gsea_dotplot.png)

**Interpretation:** The dotplot shows the most significantly enriched Hallmark pathways in my analysis. Hypoxia, glycolysis, and mTORC1 signaling are top hits, consistent with cellular adaptation to low oxygen. EMT enrichment suggests hypoxia may promote a more invasive phenotype.

#### Waterfall Plot
![GSEA Waterfall](https://raw.githubusercontent.com/harshitap26/Bulk_RNA_Seq/main/figs/gsea_waterfall.png)

**Interpretation:** The waterfall plot displays all Hallmark pathways with their NES scores. Positive NES (red) indicates pathways activated by hypoxia, while negative NES (blue) indicates suppressed pathways. I found that interferon response pathways are notably suppressed, suggesting hypoxia may dampen immune-related signaling.

---

## 🔬 Androgen Receptor Signaling

The original paper reported that hypoxia suppresses AR signaling in LNCaP cells. In my combined analysis, the Androgen Response pathway showed a positive NES (not significant). This discrepancy likely arises because PC3 cells are AR-negative, diluting the effect in the combined analysis.

**Interpretation:** While I successfully reproduced most hypoxia-related findings, AR suppression could not be clearly demonstrated in my combined dataset. A dedicated LNCaP-only analysis with larger sample size would be needed to validate this specific finding.

---

## 🔍 Comparison with Guo et al. (2019)

| Finding | Reproduced? | Evidence |
|---------|-------------|----------|
| Hypoxia induces strong transcriptional response | ✅ Yes | 911 DEGs; classic markers upregulated |
| Hypoxia activates glycolysis, mTORC1, EMT | ✅ Yes | Positive enrichment in GSEA |
| AR signaling suppressed | ⚠️ Partial | Not significant in combined analysis |
| Neuroendocrine markers | ❓ Not assessed | Could be examined in future work |

**Overall Interpretation:** My analysis successfully reproduces the core finding that hypoxia activates glycolysis, mTORC1, and EMT pathways in prostate cancer cells. The hypoxia treatment was effective, as evidenced by strong upregulation of classic HIF1α targets (VEGFA, CA9, PDK1, LDHA, PGK1). The discrepancy in AR signaling highlights the importance of cell-type-specific analysis and adequate sample size.
All trimming and quality control steps were implemented via shell scripts available in the `scripts/` directory, ensuring reproducibility and transparency of the analysis workflow.

