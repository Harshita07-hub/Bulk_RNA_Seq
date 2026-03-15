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
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/684717f1-5856-4775-a903-22a1824e4413" />


**Interpretation:** PC1 separates LNCaP and PC3 cells, indicating strong cell-line-specific expression differences. PC2 separates hypoxia from normoxia samples, confirming that hypoxia induces a detectable transcriptional response across both cell lines.

---

### Volcano Plot
Highly significant genes are highlighted; red points indicate upregulation under hypoxia, blue points downregulation.

<img width="1255" height="692" alt="Image" src="https://github.com/user-attachments/assets/4183494c-4075-49c3-90b9-6cc0a8f162fe" />

## 📊 Volcano Plot Analysis: Transcriptional Response to Hypoxia

### Overall Distribution

The volcano plot reveals widespread transcriptional reprogramming under hypoxic conditions, with a substantial number of genes crossing the significance threshold (*padj < 0.05*). The symmetric distribution around zero indicates good data quality, while the asymmetric enrichment of **upregulated genes (red)** compared to **downregulated genes (blue)** suggests that hypoxia predominantly **activates gene expression rather than repressing it**.

---

## 🔴 Upregulated Genes: Hallmarks of Hypoxic Adaptation

### Metabolic Reprogramming (Warburg Effect)

Several significantly upregulated genes are involved in **glycolytic metabolism**, indicating a metabolic shift toward glycolysis.

* **[PFKFB4](https://www.ncbi.nlm.nih.gov/gene/5217)** – A glycolytic regulator that enhances glycolytic flux, allowing cells to generate energy efficiently under low oxygen conditions.
* **[PDK1](https://www.ncbi.nlm.nih.gov/gene/5163)** – Pyruvate dehydrogenase kinase that inhibits mitochondrial oxidative phosphorylation by preventing pyruvate entry into the TCA cycle.
* **[PGK1](https://www.ncbi.nlm.nih.gov/gene/5230)** – A key glycolytic enzyme that catalyzes ATP production during the later stages of glycolysis.

**Interpretation:**
Together, these genes indicate a **metabolic switch from oxidative phosphorylation to aerobic glycolysis (Warburg effect)**. This metabolic adaptation allows cells to maintain energy production and generate biosynthetic intermediates when oxygen availability is limited.

---

### HIF1α Direct Targets (Hypoxia Signature)

The upregulation of known **HIF1α-responsive genes** confirms activation of the canonical hypoxia response pathway.

* **[P4HA1](https://www.ncbi.nlm.nih.gov/gene/5033)** – Encodes collagen prolyl hydroxylase involved in extracellular matrix remodeling and hypoxia signaling feedback mechanisms.
* **[BHLHE40](https://www.ncbi.nlm.nih.gov/gene/8553)** – A transcriptional repressor that participates in stress responses, circadian rhythm regulation, and cell cycle modulation.

**Interpretation:**
The induction of these genes serves as an internal validation of the experiment, demonstrating that:

* The hypoxic treatment successfully triggered the hypoxia signaling cascade
* The **HIF1α pathway is transcriptionally active**
* Downstream hypoxia-responsive transcriptional programs are engaged

---

### Structural Remodeling and Microenvironment Adaptation

Several upregulated genes suggest that hypoxic cells actively modify their **cellular environment and structural organization**.

* **[FUT11](https://www.ncbi.nlm.nih.gov/gene/170392)** – A fucosyltransferase that modifies glycoproteins on the cell surface, potentially influencing cell–cell and cell–matrix interactions.
* **[ANKZF1](https://www.ncbi.nlm.nih.gov/gene/55139)** – A protein associated with stress responses and potentially involved in hypoxia-related signaling pathways.
* **[RORA](https://www.ncbi.nlm.nih.gov/gene/6095)** – A transcription factor linking hypoxia signaling with circadian rhythm regulation and metabolic pathways.

**Interpretation:**
These transcriptional changes suggest that hypoxic cells are actively **remodeling their microenvironment**, potentially preparing for **angiogenic signaling and enhanced oxygen delivery**. Such remodeling can help create a **pro-survival cellular niche** during oxygen deprivation.

---

## 🔵 Downregulated Genes

Although fewer in number, the downregulated genes likely represent cellular processes that are **energetically costly or less essential under hypoxic stress**.

Commonly suppressed processes include:

* Components of oxidative phosphorylation
* Cell cycle progression pathways
* Differentiation-associated genes

This pattern reflects a strategy of **energy conservation and metabolic prioritization** during oxygen limitation.

---

## 🎯 Biological Conclusion

Overall, the transcriptional landscape revealed by the volcano plot indicates a **coordinated adaptive response to hypoxia** characterized by:

* **Metabolic reprogramming toward glycolysis** to sustain ATP production
* **Activation of canonical HIF1α target genes** confirming hypoxia pathway engagement
* **Microenvironment remodeling** that may promote angiogenesis and survival
* **Transcriptional regulation integrating metabolic and stress responses**

These observations are consistent with established models of **HIF1α-mediated hypoxic adaptation**, commonly observed in tumor biology and other oxygen-limited physiological contexts.

---

## 📌 Key Takeaway

> Hypoxia induces a coordinated transcriptional program characterized by metabolic reprogramming toward glycolysis, activation of canonical HIF1α targets, and remodeling of the cellular microenvironment, collectively representing an adaptive survival response.


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
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/d98fdc96-9c0e-4b14-8716-121d103416e0" />
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/9008d8d7-b8b7-49bd-b003-700aabec320c" />
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/3e36e913-459b-481e-86f1-e3d739031ca9" />
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/966c2ed5-8880-4373-8217-34d1d4bc3f08" />
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/a3612ce8-bc72-42c8-8411-36e1b8a6ae96" />
**Interpretation:** The dotplot shows the most significantly enriched Hallmark pathways in my analysis. Hypoxia, glycolysis, and mTORC1 signaling are top hits, consistent with cellular adaptation to low oxygen. EMT enrichment suggests hypoxia may promote a more invasive phenotype.

#### Waterfall Plot
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/dc162d8c-ccc8-41ae-87b9-9d1a8b437922" />


<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/e2c7d848-f748-408c-a8ec-389297e4f94d" />

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

