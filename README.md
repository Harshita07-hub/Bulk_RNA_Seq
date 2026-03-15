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

The repository contains all scripts, intermediate analyses, and figures needed for reproducible Bulk RNA-Seq analysis.

fastq/ – Raw and processed FASTQ files

fastqc_results/ – FastQC reports

multiqc_report/ – MultiQC summary

scripts/ – Pipeline scripts

figs/ – Figures and screenshots

analysis/ – Intermediate files

alignedreads/ – Alignment outputs (future)

quants/ – Gene quantification results (future)

results/ – Final analysis outputs




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
## 🧬 Functional Categorization of Key Differentially Expressed Genes

To understand the biological response to hypoxia, the top differentially expressed genes were grouped based on their known functions. This highlights major pathways activated under low-oxygen conditions.

**1️⃣ Glycolysis & Metabolic Reprogramming**  
Several upregulated genes indicate a shift toward glycolysis for energy production. Key genes: PFKFB3, PFKFB4, LDHA, PGK1, HK1, HK2, PFKP, GPI, PDK1, SLC2A1, SLC16A3.  
PDK1 inhibits mitochondrial oxidative phosphorylation, blocking pyruvate entry into the TCA cycle. SLC2A1 and SLC16A3 facilitate glucose uptake and lactate export.  
*Interpretation:* Cells switch toward aerobic glycolysis (Warburg effect) — a hallmark of hypoxic adaptation.

**2️⃣ Canonical HIF1α Target Genes**  
Confirm activation of the hypoxia signaling pathway. Key genes: CA9, BNIP3, BNIP3L, P4HA1, ERO1A, LOX, KDM3A, CITED2, NDRG1, BHLHE40.  
These regulate pH (CA9), mitochondrial turnover (BNIP3/BNIP3L), ECM remodeling (P4HA1, LOX), and transcriptional feedback (CITED2).  
*Interpretation:* Upregulation reflects a classical hypoxia response.

**3️⃣ Angiogenesis & Microenvironment Remodeling**  
Genes involved in vascular remodeling and angiogenesis improve oxygen supply. Key genes: APLN, LOX.  
APLN encodes an angiogenic peptide; LOX contributes to ECM remodeling and metastasis.  
*Interpretation:* Cells may enhance oxygen delivery under hypoxic stress.

**4️⃣ Cell Survival & Autophagy**  
Hypoxia triggers pathways promoting survival and stress adaptation. Key genes: BNIP3, BNIP3L, NDRG1, RORA.  
They regulate autophagy/mitophagy and stress responses.  
*Interpretation:* Supports homeostasis during oxygen deprivation.

**5️⃣ Transcriptional & Epigenetic Regulators**  
Genes acting as transcription factors or chromatin regulators. Key genes: BHLHE40, CITED2, KDM3A, RORA, KLF7, ZNF395, PIAS2, SAP30.  
*Interpretation:* Coordinate the broader transcriptional response to hypoxia.

**6️⃣ Additional Genes with Diverse Functions**  
Other DEGs contribute to various processes: INSIG2 (lipid metabolism/ER stress), FUT11 (protein fucosylation), LRP1 (endocytosis/signaling), BTG1 (cell cycle), TMEM45A/FAM162A (hypoxia-induced), ARHGEF37 (Rho signaling), RNF24 (ubiquitination).  
*Interpretation:* Likely contribute to cellular adaptation under stress.

**🔥 Overall Interpretation**  
This functional categorization shows a coordinated transcriptional program under hypoxia:  
- Metabolic reprogramming → glycolysis (PFKFB4, PDK1, LDHA, PGK1, HK2)  
- HIF1α activation → canonical hypoxia response (CA9, BNIP3, P4HA1, ERO1A)  
- Angiogenic factors → enhanced oxygen delivery (APLN, LOX)  
- Survival & autophagy genes → stress adaptation (BNIP3L, NDRG1, RORA)  
- Transcriptional regulators → coordinate broader response (BHLHE40, KDM3A, CITED2)

*Conclusion:* Cells maintain energy production, regulate stress responses, and remodel their environment, reflecting a comprehensive adaptive strategy under hypoxia.


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
## 📊 Gene Set Enrichment Analysis (GSEA)

To identify biological pathways affected by hypoxia, Gene Set Enrichment Analysis (GSEA) was performed using the Hallmark gene sets.

### Key Findings

Several pathways were significantly enriched under hypoxic conditions:

- **HYPOXIA** – confirms activation of HIF1α-related transcriptional programs  
- **GLYCOLYSIS** – supports metabolic reprogramming toward glycolysis (Warburg effect)  
- **MTORC1 SIGNALING** – links hypoxia to cellular growth and metabolic regulation  
- **EPITHELIAL MESENCHYMAL TRANSITION (EMT)** – suggests microenvironment and cellular remodeling  
- **TNFA SIGNALING VIA NFKB** – indicates inflammatory and stress-response signaling  
- **UV RESPONSE DN** – associated with cellular stress and DNA damage response pathways  

### Consistency with Differential Expression Analysis

The GSEA results align with observations from the differential expression analyses:

- Upregulation of **PFKFB4, PDK1, and LDHA** in the volcano plot corresponds with enrichment of the **GLYCOLYSIS** pathway.  
- Increased expression of **CA9, BNIP3, and P4HA1** aligns with enrichment of the **HYPOXIA** pathway.  
- Coordinated upregulation of hypoxia-responsive genes in the heatmap further supports pathway-level enrichment observed in GSEA.

### Conclusion

GSEA highlights a **coordinated transcriptional response to hypoxia** involving metabolic reprogramming, activation of canonical HIF1α pathways, and cellular stress adaptation. These pathway-level results complement the differential expression analysis and strengthen the overall interpretation of the dataset.


#### Waterfall Plot
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/dc162d8c-ccc8-41ae-87b9-9d1a8b437922" />


<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/e2c7d848-f748-408c-a8ec-389297e4f94d" />

## 📊 GSEA Waterfall Plots

### Key Observations

The waterfall plots display the **Normalized Enrichment Score (NES)** for Hallmark pathways under hypoxic conditions.

- **Positive NES** → Pathway enriched in **Hypoxia**
- **Negative NES** → Pathway enriched in **Normoxia**

### Pathways Enriched in Hypoxia

Several pathways show positive enrichment scores, indicating activation under hypoxic conditions:

- **HYPOXIA (NES ≈ +1.8)** – Confirms activation of HIF1α-regulated transcriptional programs.
- **GLYCOLYSIS (NES ≈ +1.6)** – Supports metabolic reprogramming toward glycolysis (Warburg effect).
- **MTORC1 SIGNALING (NES ≈ +1.4)** – Suggests regulation of cellular growth and metabolism during hypoxic stress.
- **EPITHELIAL MESENCHYMAL TRANSITION (NES ≈ +1.2)** – Indicates cellular remodeling and microenvironment adaptation.
- **UV RESPONSE DN (NES ≈ +1.0)** – Reflects cellular stress response pathways.
- **TNFA SIGNALING VIA NFKB (NES ≈ +0.8)** – Suggests activation of inflammatory and stress-response signaling.

### Pathways Enriched in Normoxia

Some pathways show negative enrichment scores, indicating higher activity under normoxic conditions:

- **INTERFERON GAMMA RESPONSE (NES ≈ −0.8)** – Immune signaling pathways more active under normal oxygen levels.
- **INTERFERON ALPHA RESPONSE (NES ≈ −0.7)** – Reduced activity under hypoxic stress.
- **MYC TARGETS V2 (NES ≈ −0.6)** – Downregulation of proliferation-related genes in hypoxia.

### Consistency with Differential Expression Analysis

The GSEA results are consistent with observations from the differential expression analyses:

- Upregulation of **PFKFB4, PDK1, and LDHA** corresponds with enrichment of the **GLYCOLYSIS** pathway.
- Increased expression of **CA9, BNIP3, and P4HA1** aligns with enrichment of the **HYPOXIA** pathway.
- Coordinated upregulation of hypoxia-responsive genes in the heatmap further supports the pathway-level enrichment observed in GSEA.

### Conclusion

The waterfall plots indicate that hypoxia induces a **coordinated transcriptional response** involving metabolic reprogramming, activation of canonical hypoxia pathways, and cellular stress adaptation. In contrast, pathways related to immune signaling and proliferation show reduced activity under hypoxic conditions. These pathway-level findings support and validate the gene-level results obtained from differential expression analysis.
---

## 🔬 Comparison with Guo et al. (2019)

To assess the validity of our findings, we compared our results with the published study by Guo et al. (2019), which characterized the hypoxic response in prostate cancer cells.

### Key Findings

Several major observations reported in the original study were successfully reproduced in this analysis.

**Hypoxia induces a strong transcriptional response**  
A total of **911 differentially expressed genes (DEGs)** were identified (padj < 0.05, log2FC > 1), indicating a substantial transcriptional shift under hypoxic conditions.

**Classic hypoxia markers are upregulated**  
Well-established HIF1α target genes including **VEGFA, CA9, PDK1, LDHA, and PGK1** were significantly upregulated in the differential expression analysis, confirming activation of canonical hypoxia pathways.

**Glycolysis pathway activation**  
The **GLYCOLYSIS** hallmark pathway was significantly enriched in GSEA (NES ≈ +1.6), supporting the metabolic shift toward glycolysis under hypoxic stress.

**mTORC1 signaling activation**  
The **MTORC1 SIGNALING** pathway showed positive enrichment (NES ≈ +1.4), indicating altered growth and metabolic regulation in response to hypoxia.

**Epithelial–Mesenchymal Transition (EMT)**  
The **EMT** pathway was also enriched (NES ≈ +1.2), suggesting cellular remodeling and microenvironmental adaptation.

### Androgen Receptor Signaling – A Closer Look

The original study reported that hypoxia suppresses androgen receptor (AR) signaling in **LNCaP cells**. In our combined analysis (LNCaP + PC3), the **Androgen Response** pathway showed a positive enrichment score but was not statistically significant.

This discrepancy can likely be explained by differences between the cell lines used:

- **LNCaP cells are AR-positive**
- **PC3 cells are AR-negative**

Combining both cell lines in a single analysis may have diluted AR-specific transcriptional signals. As a result, AR pathway suppression could not be clearly detected in this dataset.

### Overall Interpretation

Overall, this analysis successfully reproduces the **core biological findings** reported by Guo et al.:

- Hypoxia induces a strong transcriptional response  
- Classical **HIF1α target genes** are strongly upregulated  
- Key pathways including **glycolysis, mTORC1 signaling, and EMT** are activated under hypoxic conditions  

The difference observed in AR signaling highlights the importance of **cell-type-specific analysis**. A dedicated **LNCaP-only analysis** would likely provide clearer insight into AR pathway suppression under hypoxia.

### Reproducibility Note

All preprocessing and analysis steps—including quality control, trimming, differential expression analysis, and pathway enrichment—were implemented through shell scripts and R code available in the `scripts/` directory, ensuring full **reproducibility and transparency** of the workflow.
