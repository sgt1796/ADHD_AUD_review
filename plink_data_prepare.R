#!/usr/bin/env RScript

library(dplyr)
library(stringr)
data1 = tibble(read.csv("studyData/files/PGC30482948_pgc_alcdep.discovery.aug2018_release.txt", sep = " "))
data2 = tibble(read.csv("studyData/files/PGC32099098_OD_cases_vs._opioid-exposed_controls_in_the_trans-ancestry_meta-analysis", sep = "\t"))








formatted_data1 = data1 %>%
  filter(str_detect(.$rsid, "^rs")) %>%
  dplyr::select(
    SNP = rsid,
    CHR = chr,
    #BP = base_pair_location,
    A1 = a_1,
    A2 = a_0,
    OR = beta_P,  # assuming that 'beta' represents the odds ratio here
    SE = se_P,
    P = p_P
  )





formatted_data2 = data2 %>%
  rowwise() %>%
  mutate(SNP = unlist(strsplit(SNP,":"))[1]) %>%
  dplyr::select(
    SNP = SNP,
    CHR = CHR,
    BP = BP,
    A1 = A1,
    A2 = A2,
    OR = Z,  # assuming that 'beta' represents the odds ratio here
    SE = Weight,
    P = P
  )

# Save the formatted data
write.table(formatted_data1, "studyData/processed_files/PGC30336701_AUDIT_UKB_2018_AJP_processed.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(formatted_data2, "studyData/processed_files/PGC30482948_pgc_alcdep.discovery.aug2018_release_processed.txt", sep = "\t", row.names = FALSE, quote = FALSE)

list.files("studyData/processed_files")







data2.sm = data2[1:10,]

data2.sm 
















