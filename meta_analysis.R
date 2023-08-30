## Meta-analysis  
library(dplyr)
library(metafor)
data1 = tibble(read.csv("studyData/GCST90016595_buildGRCh37.tsv", sep = "\t"))
data2 = tibble(read.csv("studyData/GCST90016604_buildGRCh37.tsv", sep = "\t"))
