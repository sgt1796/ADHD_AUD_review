## Meta-analysis  
library(dplyr)
library(qqman)

data = tibble(read.table("studyData/plink/plink.meta", header = T)) %>%
  filter(P.R. != 0) %>%
  tidyr::drop_na()

data1 = filter(data, N >=7 & P.R. >= 1e-150 & P.R. != 0)%>%
  mutate(P.R. = P.R.^(1/8)) %>%
  #filter(P != 0) %>%
  tidyr::drop_na()
manhattan(data1,annotatePval = 1e-8, ylim = c(0, 10),  cex.axis = 0.9,
          col = c("blue4", "orange3"), p = "P.R.", highlight = c("rs149661977") )
manhattan(filter(data1, CHR==11),annotatePval = 1e-8, ylim = c(0, 10),  cex.axis = 0.9,
          col = c("blue4", "orange3"), p = "P.R.", highlight = c("rs149661977") )

## Q-Q plot for the selected data
qq(data1$P.R.^8)



data.high = data1 %>%
  filter(P.R. <= 5e-8)


## generate SNPdb query url
library(xml2)
library(httr)
library(stringr)

# query url, cannot query too many or will out of memory
response = GET(paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=snp&id=", paste(data.high$SNP, collapse = ",")))
xml_content <- content(response, as = "text")
xml_content <- sub("<?xml[^>]*?>", "", xml_content)
xml_content <- paste("<root>", xml_content, "</root>")

xml_doc <- read_xml(xml_content)
gnames = c()
for (record in xml_children(xml_doc)){
  gname <- xml_text(xml_find_first(record, ".//NAME"))
  gnames = c(gnames, gname)
}
data.gname = data.high %>%
  mutate(GENE = gnames) %>%
  select(CHR, BP, SNP, A1, A2, N, P = P.R., OR = OR.R., GENE)


a = tibble(arrange(data.gname, CHR))
write.csv(a, "result.csv")
