##================================================================================================
##                                                                                              
##    Nome: Função para criar rotulo para bases de dados                                           
##                                                    
##    prof. Steven Dutt-Ross                          
##    UNIRIO           
##================================================================================================

#You need to replace Table$Variable with Table[,Variable]. 
#When you pass Variable into your function it is as an object of type character. 
#Subsetting with $ requires a bare variable name, whereas square bracket notation will accept character objects. 

#Pass a character to Variable and stop using $, instead use Table[[Variable]]. 
# $ is for interactive use, [[ is for programming.
#CARROS$TipodeMarcha
#CARROS[,"TipodeMarcha"]
#CARROS[["TipodeMarcha"]]

#load("C:/Users/Hp/Documents/GitHub/Base_de_dados/Titanic.RData")
#load("C:/Users/Hp/Documents/GitHub/Base_de_dados/CARROS.RData")


library(dplyr)
criar_rotulos <-function(base,variavel){
  percentual <- base[[as.character(variavel)]] %>% 
    table() %>%
    prop.table()*100
  percentual <- round(percentual,digits = 1)
  rotulo <- paste0(percentual,"%")
  return(rotulo)
}

exemplo<-paste0('EXEMPLO DE FUNCIONAMENTO \n
source("https://raw.githubusercontent.com/DATAUNIRIO/Miscellaneous_Functions_Rstats/master/criar_rotulos_grafico_de_barras.R",encoding = "UTF-8")  \n
load(url("https://github.com/DATAUNIRIO/Base_de_dados/raw/master/CARROS.RData"))  \n
barras <- barplot(table(CARROS$TipodeMarcha),col=c("red","blue"))   \n
text(barras, 0, criar_rotulos(CARROS,"TipodeMarcha"),cex=1,pos=3,col = "white")'
)
message(exemplo)



#--------------------------------------------------------
# Teste de funcionamento
#--------------------------------------------------------
# criar_rotulos(CARROS,"TipodeMarcha")
# criar_rotulos(CARROS,"Tipodecombustivel")
# criar_rotulos(CARROS,"NumdeMarchas")
# 
# criar_rotulos(Titanic,"Sexo")
# criar_rotulos(Titanic,"Classe")
# criar_rotulos(Titanic,"Sobreviveu")
# 
# #GRÁFICO DE BARRA
# barra<- CARROS %>% 
#   pull(TipodeMarcha) %>%
#   table() %>%
#   barplot(ylab="Frequência",col=c("red","blue"),main="Gráfico 1")
# text(barra, 0, criar_rotulos(CARROS,"TipodeMarcha"),cex=1,pos=3,col = "white")
# 
# barra1<- CARROS %>% 
#   pull(NumdeMarchas) %>%
#   table() %>%
#   barplot(ylab="Frequência",col=c("red","blue","green"),main="Gráfico 1")
# text(barra1, 0, criar_rotulos(CARROS,"NumdeMarchas"),cex=1,pos=3,col = "white")
# 
# barra2<- Titanic %>% 
#   pull(Sexo) %>%
#   table() %>%
#   barplot(ylab="Frequência",col=c("red","blue","green"),main="Gráfico 1")
# text(barra2, 0, criar_rotulos(Titanic,"Sexo"),cex=1,pos=3,col = "white")
# 
# barra3<- Titanic %>% 
#   pull(Sobreviveu) %>%
#   table() %>%
#   barplot(ylab="Frequência",col=c("red","blue","green"),main="Gráfico 1")
# text(barra3, 0, criar_rotulos(Titanic,"Sobreviveu"),cex=1,pos=3,col = "white")
# 
