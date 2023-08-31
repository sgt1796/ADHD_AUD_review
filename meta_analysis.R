## Meta-analysis  
library(dplyr)
library(qqman)

data = tibble(read.table("studyData/plink.meta", header = T))

gwas.data = data %>%
  filter(!is.na(P) & !is.infinite(P)) %>%
  filter(P.R. <= 1e-23)
gwas.data$P[gwas.data$P == 0] = 1e-300

manhattan(gwas.data, P = "P.R.", logp = T)
manhattan(filter(gwas.data, P.R. <= 1e-300, I <= 50, N >= 3))

data1 = filter(data, N >=5 & P.R. <= 1e-5 & P.R. != 0)%>%
  tidyr::drop_na()
manhattan(data1, p = "P.R.", annotatePval = 1e-250)

## generate SNPdb query url
library(xml2)
library(httr)
library(stringr)

# query url, cannot query too many or will out of memory
response = GET(paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=snp&id=", paste(data1$SNP, collapse = ",")))
xml_content <- content(response, as = "text")
xml_content <- sub("<?xml[^>]*?>", "", xml_content)
xml_content <- paste("<root>", xml_content, "</root>")

xml_doc <- read_xml(xml_content)
gnames = c()
for (record in xml_children(xml_doc)){
  gname <- xml_text(xml_find_first(record, ".//NAME"))
  gnames = c(gnames, gname)
}
data.gname = data1 %>%
  mutate(GENE = gnames)


