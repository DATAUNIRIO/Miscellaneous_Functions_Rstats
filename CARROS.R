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
remove(nomes)
