library(ggplot2)
library(dplyr)

gwas.aud = tibble(read.csv("Alcohol_dependency_asso.tsv",
                           header = T,
                           sep = "\t"))
gwas.adhd = tibble(read.csv("ADHD_asso.tsv",
                           header = T,
                           sep = "\t"))


gwas.aud.gene = gwas.aud %>%
  filter(mappedGenes != "-") %>%
  select(riskAllele, mappedGenes, pValue) %>%
  mutate(gene = strsplit(mappedGenes, ","))
gwas.adhd.gene = gwas.adhd %>%
  filter(mappedGenes != "-") %>%
  select(riskAllele, mappedGenes, pValue) %>%
  mutate(gene = strsplit(mappedGenes, ","))

overlap_gene = intersect(unique(unlist(gwas.aud.gene$gene)),
                         unique(unlist(gwas.adhd.gene$gene)))

a = gwas.aud.gene %>%
  filter(gene %in% overlap_gene)
