# eduardo.keller@gmail.com

#https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/censo-escolar
library(ffbase)
library(ff)


escolas2019<-read.csv.ffdf(file="C:/Users/Hp/Downloads/microdados_educacao_basica_2019/DADOS/escolas.CSV", header=TRUE,sep="|", first.rows=1000000, colClasses=NA)
alunos2020<-read.csv.ffdf(file="C:/Users/Hp/Downloads/microdados_censo_escolar_2020/microdados_educacao_basica_2020/DADOS/MATRICULA_SUDESTE.CSV", header=TRUE,sep="|", first.rows=1000000, colClasses=NA)

escolas2020[1:5,10:15]



