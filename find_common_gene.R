library(ggplot2)
library(dplyr)

# Read the GWAS association table for sud and ADHD

gwas.sud = tibble(read.csv("SUD_asso.tsv",
                           header = T,
                           sep = "\t"))
gwas.adhd = tibble(read.csv("ADHD_asso.tsv",
                           header = T,
                           sep = "\t"))


# split the genes in mappedGenes column
# get a list of intersection of genes btween sud and ADHD

gwas.sud.gene = gwas.sud %>%
  filter(MAPPED_GENE != "") %>%
  select(STRONGEST.SNP.RISK.ALLELE, MAPPED_GENE, P.VALUE, STUDY.ACCESSION) %>%
  mutate(gene = strsplit(MAPPED_GENE, ","))
names(gwas.sud.gene) = c("riskAllele", "mappedGenes", "pValue", "accessionId","gene")
gwas.adhd.gene = gwas.adhd %>%
  filter(mappedGenes != "-") %>%
  select(riskAllele, mappedGenes, pValue, accessionId) %>%
  mutate(gene = strsplit(mappedGenes, ","))

overlap_gene = intersect(unique(unlist(gwas.sud.gene$gene)),
                         unique(unlist(gwas.adhd.gene$gene)))

sud.overlap = gwas.sud.gene %>%
  filter(gene %in% overlap_gene) %>%
  mutate(disease = "SUD")
adhd.overlap = gwas.adhd.gene %>%
  filter(gene %in% overlap_gene) %>%
  mutate(disease = "ADHD")

data.overlap = rbind(sud.overlap, adhd.overlap)

write.csv(select(data.overlap, -gene), "data.overlap.csv")
write.csv(unique(data.overlap$accessionId),"studyID.csv")
## No need for p-val since all in data are significant

