#****  Fonte dos dados ************************************
#****  http://data.princeton.edu/wws509/notes/c3.pdf  *****
  
#**** Analisar os fatores associados a probabilidade de mulheres utilizarem contraceptivos *********
dados_mulheres<-data.frame(
    faixa_de_idade = c("Menos_de_25","Menos_de_25",
                       "Menos_de_25","Menos_de_25","25_a_29","25_a_29",
                       "25_a_29","25_a_29","30_a_39","30_a_39","30_a_39",
                       "30_a_39","40_a_49","40_a_49","40_a_49","40_a_49"),
      escolaridade = c("baixa","baixa","alta",
                       "alta","baixa","baixa","alta","alta","baixa","baixa",
                       "alta","alta","baixa","baixa","alta","alta"),
     deseja_filhos = c("sim","nao","sim","nao",
                       "sim","nao","sim","nao","sim","nao","sim","nao",
                       "sim","nao","sim","nao"),
               usa = c(6L,4L,52L,10L,14L,10L,54L,
                       27L,33L,80L,46L,78L,6L,48L,8L,31L),
             total = c(59L,14L,264L,60L,74L,29L,
                       209L,92L,145L,157L,164L,146L,41L,94L,16L,43L)
)