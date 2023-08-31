#!/usr/bin/env RScript

library(dplyr)
data1 = tibble(read.csv("studyData/files/GCST007543_daner_meta_filtered_NA_iPSYCH23_PGC11_sigPCs_woSEX_2ell6sd_EUR_Neff_70.meta", sep = "\t"))
data2 = tibble(read.csv("studyData/files/GCST008414_CUD_GWAS_iPSYCH_June2019.tsv", sep = " "))

formatted_data1 = data1 %>%
  dplyr::select(
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
  dplyr::select(
    SNP = MarkerName,
    CHR = chromosome,
    BP = base_pair_location,
    A1 = effect_allele,
    A2 = other_allele,
    OR = beta,  # assuming that 'beta' represents the odds ratio here
    SE = standard_error,
    P = p_value
  )

# Save the formatted data
write.table(formatted_data1, "studyData/processed_files/GCST007543_daner_meta_filtered_NA_iPSYCH23_PGC11_sigPCs_woSEX_2ell6sd_EUR_Neff_70_processed.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(formatted_data2, "studyData/processed_files/GCST008414_CUD_GWAS_iPSYCH_June2019_processed.txt", sep = "\t", row.names = FALSE, quote = FALSE)

list.files("studyData/processed_files")
