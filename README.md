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

## 📈 MA Plot Analysis

### Overview
The MA plot visualizes the relationship between gene expression intensity and fold change between hypoxic and normoxic conditions. It serves both as a quality control tool and as a way to examine how hypoxia influences genes across different expression levels.

---

### Plot Interpretation

- **X-axis (A value):** Average gene expression level (log scale)
- **Y-axis (M value):** Log₂ fold change (Hypoxia vs Normoxia)
- **Red/blue dots:** Significantly differentially expressed genes (padj < 0.05)
- **Grey dots:** Non-significant genes

---

### Key Observations

**1. Symmetric distribution around zero**

The majority of genes are distributed symmetrically around the zero line, indicating effective normalization of the dataset using DESeq2. The absence of a global upward or downward shift suggests that no major systematic bias is present.

---

**2. Differential expression across expression levels**

Significant genes are observed across the entire range of expression values. This indicates that hypoxia influences genes at multiple expression levels rather than affecting only highly or lowly expressed genes.

---

**3. Expression-level patterns**

- **Low expression genes:** Greater variability and occasional extreme fold changes, which is expected due to higher statistical noise in low-count genes.
- **Moderate expression genes:** Highest density of significant changes, suggesting that many hypoxia-responsive genes fall within this range.
- **Highly expressed genes:** Tend to cluster close to the zero line, indicating stable expression of housekeeping genes.

---

### Quality Assessment

The MA plot provides several indicators of good data quality:

- Symmetric distribution around the baseline
- No strong expression-dependent bias
- Limited artifacts among low-count genes

These observations suggest that the normalization and filtering steps were effective.

---

### Biological Interpretation

Overall, the MA plot indicates that hypoxia induces transcriptional changes across a wide range of genes. The strongest differential expression appears among moderately expressed genes, which often include metabolic enzymes and signaling proteins involved in stress responses. In contrast, highly expressed housekeeping genes remain relatively stable between conditions.

---

### Conclusion

The MA plot confirms that the dataset is well normalized and suitable for downstream interpretation. The observed patterns support a coordinated transcriptional response to hypoxia, consistent with activation of hypoxia-responsive pathways and metabolic adaptation.

---

### Heatmap of Top 50 DE Genes
Unsupervised clustering of the top 50 most significant genes.


<img width="1019" height="689" alt="Image" src="https://github.com/user-attachments/assets/83d717ca-70b2-4937-af0e-ed6f81a94ed0" />

🧬 Functional Categorization of Key Differentially Expressed Genes

To understand the biological response to hypoxia, the top differentially expressed genes were grouped based on their known functions.

1️⃣ Glycolysis & Metabolic Reprogramming

Several upregulated genes indicate a metabolic shift toward glucose breakdown for energy production.

Key genes: PFKFB3, PFKFB4, LDHA, PGK1, HK1, HK2, PFKP, GPI, PDK1, SLC2A1, SLC16A3

PDK1 inhibits mitochondrial oxidative phosphorylation, blocking pyruvate entry into the TCA cycle.

SLC2A1 and SLC16A3 facilitate glucose uptake and lactate export.

Interpretation: Cells switch toward aerobic glycolysis (Warburg effect) — a hallmark of hypoxic adaptation.

2️⃣ Canonical HIF1α Target Genes

These genes confirm activation of the hypoxia signaling pathway.

Key genes: CA9, BNIP3, BNIP3L, P4HA1, ERO1A, LOX, KDM3A, CITED2, NDRG1, BHLHE40

Regulate pH balance (CA9), mitochondrial turnover (BNIP3/BNIP3L), ECM remodeling (P4HA1, LOX), and transcriptional feedback (CITED2).

Interpretation: Upregulation reflects a classical hypoxia response.

3️⃣ Angiogenesis & Microenvironment Remodeling

Genes associated with vascular remodeling and angiogenesis help improve oxygen supply.

Key genes: APLN, LOX

APLN encodes an angiogenic peptide.

LOX contributes to ECM remodeling and metastasis.

Interpretation: Cells may enhance oxygen delivery under hypoxic stress.

4️⃣ Cell Survival & Autophagy

Hypoxia triggers pathways promoting cell survival and stress adaptation.

Key genes: BNIP3, BNIP3L, NDRG1, RORA

Regulate autophagy/mitophagy (BNIP3/BNIP3L) and stress responses (NDRG1, RORA).

Interpretation: Supports homeostasis during oxygen deprivation.

5️⃣ Transcriptional & Epigenetic Regulators

Genes that act as transcription factors or chromatin regulators, controlling other genes.

Key genes: BHLHE40, CITED2, KDM3A, RORA, KLF7, ZNF395, PIAS2, SAP30

Interpretation: Coordinate the broader transcriptional response to hypoxia.

6️⃣ Additional Genes with Diverse Functions

Other DEGs contribute to various cellular processes:

INSIG2 — Lipid metabolism, ER stress

FUT11 — Protein fucosylation

LRP1 — Endocytosis, signaling

BTG1 — Cell cycle regulation

TMEM45A, FAM162A — Hypoxia-induced, under investigation

ARHGEF37 — Rho signaling

RNF24 — Protein ubiquitination

Interpretation: Likely contribute to cellular adaptation under stress.

🔥 Overall Interpretation

The functional categorization reveals a coordinated transcriptional program under hypoxic conditions:

Metabolic reprogramming (PFKFB4, PDK1, LDHA, PGK1, HK2) → glycolysis (Warburg effect)

HIF1α activation (CA9, BNIP3, P4HA1, ERO1A) → canonical hypoxia response

Angiogenic factors (APLN, LOX) → enhanced oxygen delivery

Survival & autophagy genes (BNIP3L, NDRG1, RORA) → stress adaptation

Transcriptional regulators (BHLHE40, KDM3A, CITED2) → coordinate broader response

Conclusion: These changes represent a comprehensive adaptive strategy, enabling cells to maintain energy production, regulate stress responses, and remodel their environment under hypoxia.

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

