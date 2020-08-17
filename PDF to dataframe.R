

library(pdftools)
txt <- pdf_text("http://arxiv.org/pdf/1406.4806.pdf")
# some tables
cat(txt[18])

library("tabulizer")
pdf<-"C:/Users/Hp/Downloads/Qualis.pdf"
qualis <- extract_tables(pdf)
head(qualis)
str(out1)

banco_qualis <- data.frame(matrix(unlist(qualis), nrow=length(qualis), byrow=T),stringsAsFactors=FALSE)


