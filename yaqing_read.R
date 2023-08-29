library(dplyr)
library(tidyverse)
library(ggplot2)
genotyping = tibble(read.table("yaqing.txt", skip = 17)) %>%
  rename(all_of(c(rsid = "V1",
           chromosome = "V2",
           position = "V3",
           genotype = "V4")))


# Distribution of the genotype
genotyping %>%
  ggplot(aes(x = genotype)) +
  geom_bar() +
  ggtitle("Distribution of Genotypes") +
  xlab("Genotype") +
  ylab("Count")

# scatter plot
ggplot(genotyping, aes(x = position, y = chromosome, color = genotype)) + 
  geom_point() +
  labs(title = "Genotype Distribution", 
       x = "Position", y = "Chromosome") +
  scale_color_manual(values = c('--' = 'grey', 'TT' = 'red', 'CT' = 'blue', 'GG' = 'green', 
                                'AA' = 'purple', 'CC' = 'orange', 'AG' = 'pink', 'GT' = 'brown',
                                'II' = 'yellow', 'DD' = 'black', 'DI' = 'cyan', 'AC' = 'magenta',
                                'CG' = 'limegreen', 'AT' = 'gold')) +
  theme_minimal()


library(stringr)
## read the 27 important loci that identified by GWAS on ADHD
gwas_loci = tibble(read.table("27_ADHD_loci.txt", header = FALSE, sep = " "))
colnames(gwas_loci) = c("Genomic_locus",
                        "Chr.", 
                        "Position", 
                        "rsID", 
                        "A1", 
                        "A2", 
                        "Nearby_genes", 
                        "Freq.cases", 
                        "Freq.controls", 
                        "OR", 
                        "s.e.", 
                        "P_value", 
                        "New")

## find if rsID exist in the genotype
gwas_loci$rsID %in% genotyping$rsid
# No
genotyping.ADHD = tibble()
## find genotypes within n = 10000 bp of the gwas result loci
n = 10000

for (i in 1:nrow(gwas_loci)){
  genotyping.ADHD = rbind(genotyping.ADHD,
                          filter(genotyping, 
                                 chromosome == gwas_loci$Chr.[i], 
                                 (gwas_loci$Position[i] - n) < position & position <= (gwas_loci$Position[i] + n)))
}
# remove those rsid with "mf" prefix -- those are internal data
genotyping.ADHD = filter(genotyping.ADHD, !stringr::str_detect(rsid, "mf"))
write.csv(genotyping.ADHD, "genotype_ADHD.csv")
rsid_list = genotyping.ADHD$rsid



## mass query the rsid by the NCBI's bathentrez (https://www.ncbi.nlm.nih.gov/sites/batchentrez)
## and download the result as "NCBI_query_result.txt"
data.SNP = tibble(read.table("NCBI_query_result.txt", sep = "\t"))
colnames(data.SNP) = c("chr",
                       "pos",
                       "variation",
                       "variant_type",
                       "rsid",
                       "clinical_significance",
                       "validation_status",
                       "function_class",
                       "gene",
                       "frequency")
data.SNP$rsid = paste0("rs", data.SNP$rsid)
data.SNP = data.SNP %>%
  left_join(genotyping.ADHD)
data.SNP = data.SNP %>%
  select(chr, pos, variation, variant_type, rsid, function_class, gene, frequency, genotype)
write.csv(data.SNP, "data_ADHD_SNP.csv")
