.libPaths(c("/home/harshitap/miniconda3/envs/r_env/lib/R/library", .libPaths()))

############################################################
# 0️⃣ Setup Libraries
############################################################
options(timeout = 1000)
options(download.file.method = "libcurl")
options(repos = BiocManager::repositories())

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("DESeq2","clusterProfiler","msigdbr","enrichplot","org.Hs.eg.db"), ask = FALSE)
install.packages(c("tidyverse","ggrepel","pheatmap","gridExtra","matrixStats"))



install.packages("ggridges")
library(ggridges)

library(DESeq2)
library(tidyverse)
library(ggrepel)
library(pheatmap)
library(gridExtra)
library(matrixStats)
library(clusterProfiler)
library(msigdbr)
library(enrichplot)
library(org.Hs.eg.db)
library(AnnotationDbi)

############################################################
# 1️⃣ Load counts and metadata
############################################################
counts_matrix <- read.csv("raw_counts.csv", header = TRUE, row.names = "ensembl_id")
samples <- colnames(counts_matrix)
split_names <- strsplit(samples, "_")
colData <- data.frame(
  CellLine  = sapply(split_names, `[`, 1),
  Condition = sapply(split_names, `[`, 2),
  Replicate = sapply(split_names, `[`, 3)
)
rownames(colData) <- samples
colData$CellLine <- factor(colData$CellLine)
colData$Condition <- factor(colData$Condition)
colData$Condition <- relevel(colData$Condition, ref = "Normoxia")

############################################################
# 2️⃣ DESeq2 normalization
############################################################
dds <- DESeqDataSetFromMatrix(countData = counts_matrix, colData = colData, design = ~ CellLine + Condition)
dds <- dds[rowSums(counts(dds)) > 10, ]
dds <- DESeq(dds)
normalized_counts <- counts(dds, normalized = TRUE)
vsd <- vst(dds, blind = TRUE)

############################################################
# 3️⃣ Differential Expression Hypoxia vs Normoxia
############################################################
res_hypoxia <- results(dds, contrast = c("Condition", "Hypoxia", "Normoxia"))
res_hypoxia_df <- as.data.frame(res_hypoxia)
res_hypoxia_df$EnsemblID <- rownames(res_hypoxia_df)
res_hypoxia_df$Gene.name <- mapIds(org.Hs.eg.db, keys=res_hypoxia_df$EnsemblID, column="SYMBOL", keytype="ENSEMBL", multiVals="first")
res_hypoxia_df <- res_hypoxia_df %>% filter(!is.na(Gene.name))
res_hypoxia_sig <- res_hypoxia_df %>% filter(!is.na(padj) & padj < 0.05 & abs(log2FoldChange) > 1)

############################################################
# 4️⃣ Summary stats & export top genes
############################################################
cat("Total genes analyzed: ", nrow(res_hypoxia_df), "\n")
cat("Significant DE genes: ", nrow(res_hypoxia_sig), "\n")
cat("Upregulated genes: ", sum(res_hypoxia_sig$log2FoldChange > 0), "\n")
cat("Downregulated genes: ", sum(res_hypoxia_sig$log2FoldChange < 0), "\n")
write.csv(res_hypoxia_sig %>% filter(log2FoldChange > 0) %>% arrange(padj) %>% head(20), "top20_up_genes.csv", row.names=FALSE)
write.csv(res_hypoxia_sig %>% filter(log2FoldChange < 0) %>% arrange(padj) %>% head(20), "top20_down_genes.csv", row.names=FALSE)

############################################################
# 5️⃣ Volcano plot
############################################################
plot_volcano_colors <- function(res, padj_cutoff=0.05, nlabel=10){
  res <- res %>% mutate(Significance = case_when(
    padj < padj_cutoff & log2FoldChange > 0  ~ "Up",
    padj < padj_cutoff & log2FoldChange < 0  ~ "Down",
    TRUE                                    ~ "Not Sig"))
  sig_genes <- res %>% filter(Significance != "Not Sig")
  top_up <- sig_genes %>% filter(Significance=="Up") %>% arrange(padj) %>% head(nlabel)
  top_down <- sig_genes %>% filter(Significance=="Down") %>% arrange(padj) %>% head(nlabel)
  
  ggplot(res, aes(x=log2FoldChange, y=-log10(padj), color=Significance)) +
    geom_point(alpha=0.6, size=1.8) +
    scale_color_manual(values=c("Up"="red","Down"="blue","Not Sig"="grey")) +
    geom_vline(xintercept=0, linetype="dotted") +
    geom_hline(yintercept=-log10(padj_cutoff), linetype="dashed") +
    ggrepel::geom_text_repel(data=top_up, aes(label=Gene.name), color="red", size=3, max.overlaps=50) +
    ggrepel::geom_text_repel(data=top_down, aes(label=Gene.name), color="blue", size=3, max.overlaps=50) +
    labs(x="Log2 Fold Change", y="-log10(padj)", title=paste0("Volcano Plot (padj<",padj_cutoff,")")) +
    theme_minimal(base_size=14)
}
plot_volcano_colors(res_hypoxia_df, nlabel=15)

############################################################
# 6️⃣ MA plot
############################################################
plotMA(res_hypoxia, main="MA Plot Hypoxia vs Normoxia", alpha=0.05)

############################################################
# 7️⃣ Heatmap top 50 DE genes
############################################################
top50_genes <- res_hypoxia_sig %>% arrange(padj) %>% head(50) %>% pull(Gene.name)
mat <- assay(vsd)[rownames(vsd) %in% res_hypoxia_df$EnsemblID[match(top50_genes, res_hypoxia_df$Gene.name)], ]
rownames(mat) <- top50_genes
pheatmap(mat, scale="row", clustering_distance_rows="correlation", clustering_distance_cols="correlation",
         clustering_method="complete", show_rownames=TRUE, show_colnames=TRUE, main="Top 50 DE Genes Heatmap")

############################################################
# 8️⃣ GSEA Preparation
############################################################
gene_list <- res_hypoxia_df$log2FoldChange
names(gene_list) <- res_hypoxia_df$Gene.name
gene_list <- sort(gene_list, decreasing=TRUE)
hallmark_sets <- msigdbr(species="Homo sapiens", category="H") %>% dplyr::select(gs_name, gene_symbol)

############################################################
# 9️⃣ Run GSEA LNCaP
############################################################
gsea_res <- GSEA(geneList=gene_list, TERM2GENE=hallmark_sets, pvalueCutoff=0.05, verbose=FALSE)
gsea_res_sim <- pairwise_termsim(gsea_res)
write.csv(gsea_res@result, "GSEA_hallmark_LNCaP.csv", row.names=FALSE)

############################################################
# 10️⃣ LNCaP plots
############################################################
dotplot(gsea_res, showCategory=10) + ggtitle("GSEA Hallmark Dotplot LNCaP")
emapplot(gsea_res_sim)
ridgeplot(gsea_res)
waterfall_plot <- function(gsea_results, graph_title){
  df <- gsea_results@result
  df$short_name <- sub("HALLMARK_","",df$ID)
  ggplot(df, aes(x=reorder(short_name,NES), y=NES)) +
    geom_bar(stat="identity", aes(fill=p.adjust<0.05)) +
    coord_flip() +
    labs(x="Hallmark Pathway", y="Normalized Enrichment Score (NES)", title=graph_title) +
    scale_fill_manual(values=c("TRUE"="red","FALSE"="grey"), labels=c("Significant","Not Significant")) +
    theme_minimal(base_size=12) +
    theme(axis.text.y=element_text(size=7), plot.title=element_text(hjust=0.5))
}
waterfall_plot(gsea_res, "Hallmark Pathways Altered by Hypoxia in LNCaP Cells")

############################################################
# 11️⃣ PC3 Analysis (subset samples)
############################################################
counts_PC3 <- counts_matrix[, colData$CellLine=="PC3"]
colData_PC3 <- colData[colData$CellLine=="PC3", ]
dds_PC3 <- DESeqDataSetFromMatrix(countData=counts_PC3, colData=colData_PC3, design=~Condition)
dds_PC3 <- dds_PC3[rowSums(counts(dds_PC3))>10, ]
dds_PC3 <- DESeq(dds_PC3)
res_PC3 <- results(dds_PC3, contrast=c("Condition","Hypoxia","Normoxia"))
res_PC3_df <- as.data.frame(res_PC3)
res_PC3_df$EnsemblID <- rownames(res_PC3_df)
res_PC3_df$Gene.name <- mapIds(org.Hs.eg.db, keys=res_PC3_df$EnsemblID, column="SYMBOL", keytype="ENSEMBL", multiVals="first")
res_PC3_df <- res_PC3_df %>% filter(!is.na(Gene.name))

gene_list_PC3 <- res_PC3_df$log2FoldChange
names(gene_list_PC3) <- res_PC3_df$Gene.name
gene_list_PC3 <- sort(gene_list_PC3, decreasing=TRUE)
gsea_PC3 <- GSEA(geneList=gene_list_PC3, TERM2GENE=hallmark_sets, pvalueCutoff=0.05, verbose=FALSE)
gsea_PC3_sim <- pairwise_termsim(gsea_PC3)

############################################################
# 12️⃣ PC3 plots
############################################################
dotplot(gsea_PC3, showCategory=10) + ggtitle("GSEA Hallmark Dotplot PC3")
emapplot(gsea_PC3_sim)
ridgeplot(gsea_PC3)
waterfall_plot(gsea_PC3, "Hallmark Pathways Altered by Hypoxia in PC3 Cells")

############################################################
# ✅ Pipeline Complete
############################################################
cat("Pipeline complete! Volcano, heatmap, GSEA, and waterfall plots for both LNCaP & PC3 are done.\n")



#PCA Plot
vsd <- vst(dds, blind = TRUE)

############################################################
# 2️⃣5️⃣ PCA Analysis (Global Expression Patterns)
############################################################

# Extract PCA data
pca_data <- plotPCA(vsd, intgroup = c("CellLine","Condition"), returnData = TRUE)

# Percentage variance explained
percentVar <- round(100 * attr(pca_data, "percentVar"))

# PCA Plot
ggplot(pca_data, aes(PC1, PC2, color = Condition, shape = CellLine)) +
  geom_point(size = 4) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  ggtitle("PCA: Global Gene Expression Patterns") +
  theme_minimal(base_size = 14)



# res_hypoxia_df[res_hypoxia_df$Gene.name == "VEGFA", ]


# res_hypoxia_df[res_hypoxia_df$Gene.name %in% c("PDK1","LDHA","PGK1","VEGFA","CA9"), 
#                c("Gene.name","log2FoldChange","padj")]




cat("Total genes analyzed: ", nrow(res_hypoxia_df), "\n")
cat("Significant DE genes: ", nrow(res_hypoxia_sig), "\n")
cat("Upregulated genes: ", sum(res_hypoxia_sig$log2FoldChange > 0), "\n")
cat("Downregulated genes: ", sum(res_hypoxia_sig$log2FoldChange < 0), "\n")
