# remotes::install_github("cienciadedatos/dados")
# https://cienciadedatos.github.io/dados/index.html
library(dados)
library(dplyr)

questionario_social_survey<-questionario
names(questionario_social_survey)
table(questionario_social_survey$partido)

nomes<-c("ano, Ano do questionário, 2000-2014",
"estado_civil, Estado civil",
"idade. Idade máxima limitada a 89 anos",
"raca, Categorias raciais segundo o questionário",
"renda, Renda respondida pelas pessoas entrevistadas (US$)",
"partido, Partido político com quem a pessoa entrevistada se identifica",
"religiao, Religião Denominação religiosa a que pertence",
"horas_tv, Horas de televisão assistidas por dia")
attr(questionario_social_survey, "variable.labels") <- nomes
attributes(questionario_social_survey)
names(questionario_social_survey)
summary(questionario_social_survey)

#--------------------------------------------------------------------
glimpse(diamante)

diamante<-diamante

nomes<- c("preco, Preço em dólares americanos (US$ 326-US$ 18.823)",
"quilate, Peso do diamante (0,2-5,01 ct)",
"corte, Qualidade de corte (Justo, Bom, Muito Bom, Premium, Ideal)",
"cor, Cor de diamante, de J (pior) a D (melhor)",
"transparencia, Quão transparente é o diamante (I1 (pior), SI1, SI2, VS1, VS2, VVS1, VVS2, IF (melhor))",
"profundidade, Porcentagem da profundidade total = z / mean(x, y) = 2 * z / (x + y) (43-79)",
"tabela, Largura do topo do diamante em relação ao seu ponto mais largo (43-95 mm)",
"x, Comprimento em milímetros",
"y, Largura em milímetros",
"z, Profundidade em milímetros")

attr(diamante, "variable.labels") <- nomes
attributes(diamante)
names(diamante)
summary(diamante)
#--------------------------------------------------------------------


avioes <- avioes
nomes<- c("codigo_cauda, Código da cauda do avião (empenagem)",
"ano, Ano de fabricação",
"tipo, Tipo de avião",
"fabricante, Fabricante do avião",
"modelo, Modelo de avião",
"motores, Quantidade de motores",
"assentos, quantidade de assentos",
"velocidade, Velocidade média de cruzeiro em milhas por hora",
"tipo_motor, Tipo de motor do avião")
attr(avioes, "variable.labels") <- nomes
attributes(avioes)
names(avioes)
summary(avioes)

#--------------------------------------------------------------------
dados_gapminder_pt_br<-dados_gapminder

nomes<- c("pais, Países incluídos (fator com 142 níveis)",
"continente, Continentes (fator com 5 níveis)",
"ano,De 1952 a 2007, dados a cada 5 anos",
"expectativa_de_vida, Expectativa de vida ao nascer, em anos",
"populacao, População",
"pib_per_capita, PIB per capita (em dólares americanos, ajustados pela inflação)")
attr(dados_gapminder_pt_br, "variable.labels") <- nomes
attributes(dados_gapminder_pt_br)
names(dados_gapminder_pt_br)
summary(dados_gapminder_pt_br)

#--------------------------------------------------------------------

CARROS_cat<- milhas

nomes<- c("fabricante, Nome do fabricante",
"modelo, Nome do modelo",
"cilindrada, Capacidade do motor, em litros",
"ano, Ano de fabricação",
"cilindros, Número de cilindros",
"transmissao, Tipo de transmissão",
"tracao, Tipo de tração (d = dianteira, t = traseira, 4 = 4x4)",
"cidade, Milhas da cidade por galão",
"rodovia, Milhas rodoviárias por galão",
"combustivel, Tipo de combustível (p = premium, r = regular, e = etanol, d = diesel, g = gás natural comprimido)",
"classe, tipo de carro")

attr(CARROS_cat, "variable.labels") <- nomes
attributes(CARROS_cat)
names(CARROS_cat)
summary(CARROS_cat)

#--------------------------------------------------------------------


save(diamante,file = "diamante.RData")
save(questionario_social_survey,file = "questionario_social_survey.RData")
save(avioes,file = "avioes.RData")
save(dados_gapminder_pt_br,file = "dados_gapminder_pt_br.RData")
save(CARROS_cat,file = "CARROS_cat.RData")


pie(table(CARROS_cat$classe))
pie(table(CARROS_cat$fabricante))
