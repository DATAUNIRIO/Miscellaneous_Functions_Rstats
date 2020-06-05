#--------------------------------------------------------------------------
#         Wooldridge
#--------------------------------------------------------------------------

#A documentação indica que estes são dados da Pesquisa de População Atual de 1976, coletada por Henry Farber quando ele e Wooldridge eram colegas do MIT em 1988.

library(wooldridge)
data("wage1")
?wage1
summary(wage1)
names(wage1)
dicionario<-c("salario: salário médio por hora",
"educacao: anos de educação",
"experiencia: anos de experiência em potencial",
"anos_emprego: anos de trabalho no emprego atual",
"não_branco: = 1 se não branco",
"feminino: = 1 se feminino",
"casado: = 1 se casado",
"num_dep: número de dependentes",
"nordeste: = 1 se estiver no nordeste",
"centro_oeste: = 1 se mora no centro oeste",
"sul: = 1 se mora na região sul",
"sudeste: = 1 se mora na região oeste",
"construcao: = 1 se trabalhar em construção. industria.",
"emprego_não_durável: = 1 se não for emprego durável na manufatura e indistria.",
"transporte: = 1 se for emprego no transporte",
"comércio: = 1 se for emprego no atacado ou varejo",
"servicos: = 1 se for emprego em serviços industriais.",
"profissional: = 1 se for emprego especializado em serviços industriais.",
"professor: = 1 se for emprego de professor",
"escritorio: = 1 se for emprego de escritório",
"servicos: = 1 se for emprego de serviços",
"log_salario: log(salário) logaritmo do salário médio por hora",
"experenciasq: experiência ao quadrado",
"anos_empregosq: anos empregos atual ao quadrado")

variaveis<-c("salario", "educacao", "experiencia", "anos_emprego", "nao_branco", "feminino", "casado", "num_dep", "nordeste", "centro_oeste", "sul", "sudeste", "construcao", "emprego_nao_duravel", "transporte", "comercio", "servicos", "profissional", "professor", "escritorio", "servicos", "log_salario", "experenciasq", "anos_empregosq")

#----------------------------------------------------------------
# Retirar os caracteres especiais
#----------------------------------------------------------------

dicionario<-chartr("áéíóúÁÉÍÓÚýÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛãõÃÕñÑäëïöüÄËÏÖÜÿçÇ",
                                  "aeiouaeiouyyaeiouaeiouaeiouaeiouaoaonnaeiouaeiouycc",dicionario)
head(dicionario)

colnames(wage1)<-variaveis
head(wage1)
attr(wage1, "variable.labels") <- dicionario
salarios1<-wage1
remove(wage1,dicionario,variaveis)  
summary(salarios1)

save(salarios1,file = "C:/Users/steve/OneDrive/Documents/GitHub/Base_de_dados/salarios1.RData")
write.csv(salarios1,file = "C:/Users/steve/OneDrive/Documents/GitHub/Base_de_dados/salarios1.csv")


#----------------------------------------------------------------------------------------------------------------------

# From H. Holzer, R. Block, M. Cheatham, and J. Knott (1993), Are Training Subsidies Effective? The Michigan Experience, Industrial and Labor Relations Review 46, 625-636. The authors kindly provided the data.


data("jtrain")
?jtrain
str(jtrain)

dicionario<-c("ano: 1987, 1988 ou 1989",
  "codigo: codigo da empresa",
  "empregados: numero de funcionarios na fábrica",
  "vendas: vendas anuais, em reais",
  "sal_medio: salário médio dos funcionários",
  "sucata: taxa de sucata (por 100 itens)",
  "retrabalho: taxa de retrabalho (por 100 itens)",
  "total_horas: total de horas de treinamento",
  "sindicato: = 1 se sindicalizado",
  "grant: = 1 se recebido bonus",
  "ano89: = 1 se ano = 1989",
  "ano88: = 1 se ano = 1988",
  "total_treino: total de funcionários treinados",
  "hora_treino = total_horas / total_treino", 
  "log_sucata: log(sucata)",
  "log_empregados: log(empregados)", 
  "log_vendas: log(vendas)",
  "log_retrabalho: log(retrabalho)",
  "log_hora_treino: log(1 + hora_treino)",
  "sucata_defasada: sucata lagged, sucata atrasada",
  "bonus_defasado: bonus lagged, bonus atrasado",
  "diff_sucata: sucata - sucata_t-1",
  "diff_bonus: bonus - bonus_t-1",
  "diff_empregados: empregados - empregados_t-1",
  "diff_vendas: vendas - vendas_t-1",
  "log_sal: log(salario)",
  "diff_salario: salario - salario_t-1",
  "diff_bonus_1: diff_bonus_n-1",
  "hora_treino_defasada",
  "hora_treino_defasado_normalizada")
  

dicionario<-chartr("áéíóúÁÉÍÓÚýÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛãõÃÕñÑäëïöüÄËÏÖÜÿçÇ",
                   "aeiouaeiouyyaeiouaeiouaeiouaeiouaoaonnaeiouaeiouycc",dicionario)
head(dicionario)



variaveis<-c("ano", "codigo", "empregados", "vendas", "sal_medio", "sucata", "retrabalho", "total_horas", "sindicato", "grant", "ano89", "ano88", "total_treino", "hora_treino", "log_sucata", "log_empregados", "log_vendas", "log_retrabalho", "log_hora_treino", "sucata_defasada", "bonus_defasado", "diff_sucata", "diff_bonus", "diff_empregados", "diff_vendas", "log_sal", "diff_salario", "diff_bonus_1", "hora_treino_defasada", "hora_treino_defasado_normalizada")

colnames(jtrain)<-variaveis
head(jtrain)
attr(jtrain, "variable.labels") <- dicionario
treinamento_emprego <-jtrain
remove(jtrain,dicionario,variaveis)  
summary(treinamento_emprego)
head(treinamento_emprego)

save(treinamento_emprego,file = "C:/Users/steve/OneDrive/Documents/GitHub/Base_de_dados/treinamento_emprego.RData")
write.csv(treinamento_emprego,file = "C:/Users/steve/OneDrive/Documents/GitHub/Base_de_dados/treinamento_emprego.csv")




#----------------------------------------------------------------------------------------------------------------------
data("hprice3")
?hprice3
head(hprice3)

dicionario<-c("ano: 1978, 1981",
  "idade: idade da casa",
"idade_quad: idade ao quadrado",
"bairro: 1-6",
"distancia: distancia ao centro da cidade",
"distancia2: distancia até a interestadual",
"log_distancia2: log(distancia2)",
"preço: preço de venda",
"quartos: numero de quartos em casa",
"area: metragem quadrada da casa",
"terreno: metragem quadrada do terreno",
"banheiros: numero de banheiros",
"distancia:distancia até o deposito da comlurb",
"log_distancia: log(distancia)",
"log_preco",
"y81: = 1 se ano = 1981",
"log_area: log(area)",
"log_terreno: log(terreno)",
"log_distancia2_2: quadrado do log da distancia")

variaveis<-c("ano", "idade", "idade_quad", "bairro", "distancia", "distancia2", "log_distancia2", "preço", "quartos", "area", "terreno", "banheiros", "distancia", "log_distancia", "log_preco,", "y81", "log_area", "log_terreno", "log_distancia2_2")


#----------------------------------------------------------------------------------------------------------------------

# Data from Hedonic Housing Prices and the Demand for Clean Air, by Harrison, D. and D.L.Rubinfeld, Journal of Environmental Economics and Management 5, 81-102. Diego Garcia, a former Ph.D. student in economics at MIT, kindly provided these data, which he obtained from the book Regression Diagnostics: Identifying Influential Data and Sources of Collinearity, by D.A. Belsey, E. Kuh, and R. Welsch, 1990. New York: Wiley.

data("hprice2")
?hprice2

#----------------------------------------------------------------------------------------------------------------------

# Data collected from the real estate pages of the Boston Globe during 1990. These are homes that sold in the Boston, MA area.

data("hprice1")
?hprice1
dicionario<-c("preço: preço de venda da casa, $ 1000s",
"preco_avaliado: valor avaliado, $ 1000s",
"quartos: número de quartos",
"terreno: tamanho do lote em pés quadrados",
"area: tamanho da casa em pés quadrados",
"colonial: = 1 se o lar for do estilo colonial",
"log_preco: log(preço)",
"log_preco_avaliado: log(preco_avaliado)",
"log_terreno: log (lotes)",
"log_area: log (sqrft)")

variaveis<-c("preço","preco_avaliado",
              "quartos","terreno",
              "area","colonial",
              "log_preco",
              "log_preco_avaliado",
              "log_terreno",
              "log_area")

#--------------------------------------------------------------------------
#         DOBSON
#--------------------------------------------------------------------------
library(dobson)

#--------------------------------------------------------------------------
#         Hosmer, Lemeshow and Sturdivant, "Applied Logistic Regression"
#--------------------------------------------------------------------------

Pacote do R com as Bases do livro "Applied Logistic Regression"
aplore3: Datasets from Hosmer, Lemeshow and Sturdivant, "Applied Logistic Regression" (3rd Ed., 2013)
https://cran.r-project.org/web/packages/aplore3/index.html
install.packages("aplore3")
Pacote do R com as Bases do livro Introductory Econometrics: A Modern Approach, 6e by Jeffrey M. Wooldridge.
https://cran.r-project.org/web/packages/wooldridge/index.html
install.packages("wooldridge")
library(wooldridge)
#https://cran.r-project.org/web/packages/wooldridge/vignettes/Introductory-Econometrics-Examples.html
data("wage1")
?wage1
summary(wage1)
#aplore3: Datasets from Hosmer, Lemeshow and Sturdivant, "Applied Logistic Regression" (3rd Ed., 2013)
library(aplore3)
example(burn1000)                                 
burn13m                                 
burneval1                               
burneval2                               
chdage
glowdatasets
glow500                        
glowbonemed                    
glowmiscomp                    
glowmiswmissing                           
glowrand                                
icu
lowbwt
myopia
example(nhanes)
example(polypharm)
example(scale_example)
http://archive.ics.uci.edu/ml/datasets/Automobile
http://archive.ics.uci.edu/ml/datasets/Car+Evaluation
http://archive.ics.uci.edu/ml/datasets/University
http://archive.ics.uci.edu/ml/datasets/Audit+Data#
http://archive.ics.uci.edu/ml/datasets/Real+estate+valuation+data+set
https://www.youtube.com/watch?v=C4N3_XJJ-jU&t=67s
https://statquest.org/video-index/
