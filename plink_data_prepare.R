#!/usr/bin/env RScript

library(dplyr)
data1 = tibble(read.csv("studyData/GCST90016595_buildGRCh37.tsv", sep = "\t"))
data2 = tibble(read.csv("studyData/GCST90016604_buildGRCh37.tsv", sep = "\t"))

formatted_data1 = data1 %>%
  select(
    SNP = variant_id,
    CHR = chromosome,
    BP = base_pair_location,
    A1 = effect_allele,
    A2 = other_allele,
    OR = beta,  # assuming that 'beta' represents the odds ratio here
    SE = standard_error,
    P = p_value
  )
formatted_data2 = data2 %>%
  select(
    SNP = variant_id,
    CHR = chromosome,
    BP = base_pair_location,
    A1 = effect_allele,
    A2 = other_allele,
    OR = beta,  # assuming that 'beta' represents the odds ratio here
    SE = standard_error,
    P = p_value
  )

# Save the formatted data
write.table(formatted_data1, "studyData/GCST90016595_buildGRCh37.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(formatted_data2, "studyData/GCST90016604_buildGRCh37.txt", sep = "\t", row.names = FALSE, quote = FALSE)
