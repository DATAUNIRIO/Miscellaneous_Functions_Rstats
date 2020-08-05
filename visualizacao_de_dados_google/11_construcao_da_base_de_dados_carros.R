##================================================================================================
##                                                                                              
##    Nome: Construcao de Base de dados e Dicionario de dados                                           
##                                                    
##                                                                                                                                                     ##
##    Objetivo: Construcao de Base de dados paraa aula de estatistica e regressao linear
##    prof. Steven Dutt-Ross                          
##    UNIRIO           
##================================================================================================

data(mtcars)
CARROS<-mtcars
colnames(CARROS) <- c("Kmporlitro","Cilindros","Preco","HP","Amperagem_circ_eletrico",
                      "Peso","RPM","Tipodecombustivel","TipodeMarcha","NumdeMarchas","NumdeValvulas")

CARROS <- within(CARROS, {TipodeMarcha <- factor(TipodeMarcha, labels = c('Auto','Manual'))})
CARROS <- within(CARROS, {Tipodecombustivel <- factor(Tipodecombustivel, labels = c('Gas','Alc'))})
nomes<-c("Km por litro","Número de Cilindros","Preço","HP = Horse Power (potência do motor)","Amperagem_circ_eletrico = Amperagem média (o principal indicador da bateria)","Peso (em toneladas) do Carro",
         "RPM = Rotações Por Minuto","Tipo de combustível (0 = Gasolina, 1 = Álcool)","Tipo de Câmbio (0 = Automático, 1 = Manual)",
         "Número de Marchas","Número de Válvulas")
attr(CARROS, "variable.labels") <- nomes
remove(mtcars)
#attributes(CARROS)
#names(CARROS)
#summary(CARROS)
