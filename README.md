# Bulk RNA-Seq Analysis: Hypoxia Response in Prostate Cancer Cells

This repository presents a reproducible bulk RNA-seq analysis workflow to investigate transcriptional responses to hypoxia in prostate cancer cell lines.

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

## Pipeline 

SRA → FASTQ → QC → Trimming → Alignment → Quantification → DESeq2 → GSEA

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

## FASTQ Processing and Validation

Before downstream RNA-seq analysis, FASTQ files were validated to ensure correct structure and sufficient sequencing depth.

FASTQ files were inspected to confirm:

- Proper 4-line FASTQ format
- Presence of base quality scores
- Expected read length (~76 bp)

Sequencing depth was estimated by counting total lines in each FASTQ file and dividing by four (each read occupies four lines). All samples showed sufficient read depth for bulk RNA-seq differential expression analysis.

Because each biological sample was sequenced across multiple SRA runs (technical replicates), FASTQ files belonging to the same sample were concatenated prior to trimming. This produced one FASTQ file per biological sample, simplifying downstream processing while preserving total sequencing depth.

### Read Trimming

Quality trimming was performed using **Trimmomatic (v0.40)** to remove low-quality bases and improve overall read quality before downstream analysis.

All concatenated FASTQ files were trimmed in a uniform and reproducible manner using shell scripts.

### Quality Assessment of Trimmed Reads
Post-trimming quality assessment was carried out using **FastQC** to evaluate improvements in read quality.

FastQC was executed in batch mode, and results were organized into a dedicated output directory (`fastqc_trimmed_results/`).


## 📊 Quality Control and Visualization

The following plots were generated to assess the data and visualize results. All figures are saved in the `figs/` directory.

### PCA Plot
Principal Component Analysis shows clear separation by cell line (PC1, 99% variance) and a distinct effect of hypoxia (PC2, 1% variance). 
<img width="1304" height="692" alt="Image" src="https://github.com/user-attachments/assets/684717f1-5856-4775-a903-22a1824e4413" />

**Interpretation:**

PC1 separates the two prostate cancer cell lines (LNCaP and PC3), indicating strong cell-type-specific expression differences.

PC2 separates hypoxia from normoxia samples, demonstrating that oxygen availability drives a measurable transcriptional response.

---

### Volcano Plot Analysis
Highly significant genes are highlighted; red points indicate upregulation under hypoxia, blue points downregulation.

<img width="1255" height="692" alt="Image" src="https://github.com/user-attachments/assets/4183494c-4075-49c3-90b9-6cc0a8f162fe" />

## 📊 Volcano Plot Interpretation 

### Key Observations

**1. Strong transcriptional response**

A large number of genes exceed the significance threshold (*padj < 0.05*), indicating a robust transcriptional response to hypoxia.

**2. Predominant gene activation**

More genes are **upregulated** than downregulated, suggesting that hypoxia primarily induces gene expression programs. This is consistent with the role of HIF1α as a transcriptional activator.

**3. Classic hypoxia markers**

Several well-known hypoxia-responsive genes are strongly upregulated:

- **PFKFB4, PDK1, PGK1, LDHA** – glycolysis and metabolic reprogramming  
- **CA9, BNIP3, P4HA1** – canonical HIF1α target genes  

These genes confirm activation of the hypoxia signaling pathway.

### Biological Interpretation

The transcriptional changes indicate:

- **Metabolic reprogramming** toward glycolysis (Warburg effect)  
- **Activation of canonical HIF1α pathways**  
- **Cellular adaptation to hypoxic stress**

### Conclusion

Overall, the volcano plot demonstrates a coordinated transcriptional response to hypoxia involving glycolytic activation, HIF1α signaling, and stress-adaptation pathways.

---

### MA Plot Analysis
The MA plot shows the relationship between gene expression abundance and log fold change.



<img width="1123" height="680" alt="Image" src="https://github.com/user-attachments/assets/ebe8a7a2-c0df-439a-8c5b-d77ff144069d" />

## 📈 MA Plot Interpretation

The MA plot visualizes the relationship between average gene expression and log₂ fold change between hypoxic and normoxic conditions.

### Key Observations

- Most genes cluster around the zero line, indicating effective normalization using DESeq2.
- Significantly differentially expressed genes are distributed across a wide range of expression levels.
- Greater variability is observed among low-expression genes, which is typical due to higher statistical noise.

### Interpretation

The MA plot illustrates the overall distribution of differential expression across the transcriptome rather than highlighting individual genes. The symmetric distribution around zero and absence of strong expression-dependent bias indicate that the dataset is well normalized.

### Conclusion

Overall, the MA plot supports the reliability of the dataset and confirms that downstream differential expression results are not driven by technical artifacts.


---

### Heatmap of Top 50 DE Genes

Unsupervised clustering of the 50 most significant differentially expressed genes.
The heatmap shows clear clustering of samples by oxygen condition.
Hypoxia samples cluster together and display strong upregulation of multiple hypoxia-responsive genes, including **CA9, BNIP3, PDK1, LDHA, and PGK1**, which are well-known HIF1α targets.


<img width="1019" height="689" alt="Image" src="https://github.com/user-attachments/assets/83d717ca-70b2-4937-af0e-ed6f81a94ed0" />

## 🧬 Functional Categorization of Differentially Expressed Genes

To better understand the biological response to hypoxia, key differentially expressed genes were grouped based on their known functions.

**1. Glycolysis & Metabolic Reprogramming**
Genes such as **PFKFB4, PDK1, LDHA, PGK1, HK2, and SLC2A1** indicate a shift toward glycolysis for energy production.
*Interpretation:* Cells switch to aerobic glycolysis (Warburg effect) to maintain ATP production under low oxygen.

**2. Canonical Hypoxia (HIF1α) Targets**
Genes including **CA9, BNIP3, P4HA1, ERO1A, CITED2, and NDRG1** confirm activation of the hypoxia signaling pathway.
*Interpretation:* These genes regulate pH balance, mitochondrial turnover, extracellular matrix remodeling, and transcriptional feedback during hypoxia.

**3. Angiogenesis & Microenvironment Remodeling**
Genes such as **APLN and LOX** are associated with vascular remodeling and extracellular matrix changes.
*Interpretation:* Cells may promote angiogenesis and tissue remodeling to improve oxygen availability.

**4. Stress Adaptation & Survival**
Genes including **BNIP3, BNIP3L, NDRG1, and RORA** are involved in autophagy and stress-response pathways.
*Interpretation:* These mechanisms help maintain cellular homeostasis during oxygen deprivation.

**5. Transcriptional & Epigenetic Regulation**
Regulatory genes such as **BHLHE40, KDM3A, CITED2, and ZNF395** coordinate broader transcriptional responses to hypoxia.

### Overall Interpretation

Together, these gene groups reveal a coordinated hypoxia response characterized by:

* **Metabolic reprogramming** toward glycolysis
* **Activation of canonical HIF1α pathways**
* **Microenvironment remodeling and angiogenesis**
* **Cellular stress adaptation**

These findings reflect a comprehensive transcriptional program enabling prostate cancer cells to adapt to low-oxygen conditions.



## 🧬 Gene Set Enrichment Analysis (GSEA)

Gene Set Enrichment Analysis (GSEA) was performed using Hallmark gene sets to identify biological pathways altered by hypoxia.

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

The waterfall plots indicate that hypoxia induces a **coordinated transcriptional response** involving metabolic reprogramming, activation of canonical hypoxia pathways, and cellular stress adaptation. In contrast, pathways related to immune signaling and proliferation show reduced activity under hypoxic conditions. These pathway-level results further support the coordinated transcriptional response observed under hypoxia.
---

## 🛠️ Tools and Software

The following tools were used in this analysis pipeline:

- **SRA Toolkit** – downloading sequencing data
- **FastQC** – quality control of sequencing reads
- **MultiQC** – aggregation of QC reports
- **Trimmomatic** – read trimming
- **R / DESeq2** – differential expression analysis
- **clusterProfiler** – pathway enrichment analysis
- **ggplot2 , pheatmap** – data visualization

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

## 📌 Project Summary

This project demonstrates a reproducible RNA-seq analysis workflow to investigate transcriptional responses to hypoxia in prostate cancer cell lines.

Key findings include:

- Identification of **911 differentially expressed genes**
- Activation of canonical **HIF1α hypoxia pathways**
- Metabolic reprogramming toward **glycolysis**
- Enrichment of pathways related to **mTORC1 signaling and EMT**

Together, these results highlight a coordinated transcriptional program enabling prostate cancer cells to adapt to low-oxygen conditions.
