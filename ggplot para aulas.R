

data(mtcars)
CARROS<-mtcars
remove(mtcars)
colnames(CARROS) <- c("Kmporlitro","Cilindros","Preco","HP","Amperagem_circ_eletrico",
"Peso","RPM","Tipodecombustivel","TipodeMarcha","NumdeMarchas","NumdeValvulas")
CARROS$TipodeMarcha<-as.factor(CARROS$TipodeMarcha)
CARROS$Tipodecombustivel<-as.factor(CARROS$Tipodecombustivel)
levels(CARROS$Tipodecombustivel) <- c('Gasolina','Álcool')
levels(CARROS$TipodeMarcha) <- c('Automático', 'Manual')
nomes<-c("Km por litro","Número de Cilindros","Preço",
"HP = Horse Power (potência do motor)","Amperagem_circ_eletrico = Amperagem média (o principal indicador da bateria)","Peso (em toneladas) do Carro",
"RPM = Rotações Por Minuto","Tipo de combustível (0 = Gasolina, 1 = Álcool)","Tipo de Câmbio (0 = Automático, 1 = Manual)",
"Número de Marchas","Número de Válvulas")
attr(CARROS, "variable.labels") <- nomes
attributes(CARROS)
names(CARROS)

CARROS$Tipodecombustivel <-as.factor(CARROS$Tipodecombustivel)
CARROS$TipodeMarcha<-as.factor(CARROS$TipodeMarcha)

library(ggplot2)

names(CARROS)
ggplot(CARROS, aes(x = Tipodecombustivel)) + geom_bar()
ggplot(CARROS, aes(x = Cilindros)) + geom_dotplot(dotsize = 1)
ggplot(CARROS, aes(x = HP)) + geom_histogram()

ggplot(CARROS, aes(x = Tipodecombustivel,fill=TipodeMarcha)) + geom_bar(position="dodge")
ggplot(CARROS, aes(x = Tipodecombustivel, y = Kmporlitro)) + geom_boxplot(fill = "#0c4c8a") 
ggplot(CARROS, aes(x = Kmporlitro, y = Preco)) +  geom_point(colour = "#0c4c8a") 

ggplot(CARROS, aes(x = Cilindros)) + 
  geom_dotplot(fill="red")+
  scale_y_continuous(NULL, breaks = NULL)

ggplot(CARROS, aes(x = Tipodecombustivel,fill=TipodeMarcha))+ 
  geom_bar(position="dodge") +
  scale_fill_brewer(palette="Paired")
  #scale_fill_brewer(palette="Reds")
  #scale_fill_brewer(palette="Blues")
  #scale_fill_brewer(palette="Set1")

#BrBG, PiYG, PRGn, PuOr, RdBu, RdGy, RdYlBu, RdYlGn, Spectral
#Accent, Dark2, Paired, Pastel1, Pastel2, Set1, Set2, Set3
#Blues, BuGn, BuPu, GnBu, Greens, Greys, Oranges, OrRd, PuBu, PuBuGn, PuRd, Purples, RdPu, Reds, YlGn, YlGnBu, YlOrBr, YlOrRd
