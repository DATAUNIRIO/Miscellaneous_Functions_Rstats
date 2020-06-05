# Códigos em R

# Fonte? Rogerio Mattos
# http://www.ufjf.br/rogerio_mattos/ensino/codigos-em-r/

#Econometria III



#aula1.R

#=====================================================
# AULA 1: Exemplos de Séries Temporais
#=====================================================
# Series:
# IGPDI – 1995.1 a 2002.9 (Mensal)
# XKOREA – 1970.I a 1986.II (Trimestral)
# RETAIL – 1953.1 a 1964.12 (Mensal)
#
#=====================================================
# By RSM 13/01/2018

rm(list=ls())
graphics.off()

# Lendo dados: variaveis IGPDI, XKOREA e RETAIL
# obs: arquivo de dados de IGPI tem duas variáves,
# IGPDI e TXI (varição % do IGPDI)
#=====================================================
igpdi.data <- read.table(“igpdi.txt”,header=TRUE,sep = “”)
xkorea <- read.table(“xkorea.txt”,header=TRUE,sep = “”)
retail <- read.table(“retail.txt”,header=TRUE,sep = “”)

# Convertendo para séries temporais com função “ts()”:
#=====================================================
igpdi <- ts(igpdi.data[,1], start = c(1995,1), frequency = 12)
xkorea <- ts(xkorea, start = c(1970,1), frequency = 4)
retail <- ts(retail, start = c(1953,1), frequency = 12)

# Criando variável “infl”, correspondente à taxa de
# inflação brasileira:
#=====================================================

infl <- 100*diff(igpdi)/lag(igpdi)

# Fazendo gráficos usando função “plot()”:
#=====================================================
plot(infl)
plot(xkorea)
plot(retail)

#====== FIM ======================================================================





aula2.R

#======================================================================
# AULA 2: Modelo de Decomposição com Regressão
#======================================================================
#
# Serie-exemplo:
#
# RETAIL – 1953.1 a 1964.12 (Mensal)
# (Vendas do Comércio Varejista – EUA)
#
# MODELO ADITIVO
#
# Y(t) = T(t) + S(t) + e(t)
#
# T(t) = b0 + b1*t
#
# S(t) = a1*D1(t) + a2*D2(t) + … + a12*D12(t)
#
# Objetivo: Estimar componentes T(t), S(t) e e(t), através
# da estimação dos parâmetros do modelo de regressão linear;
#
# Y(t) = b0 + b1*t + a1*D1(t) + a2*D2(t) + … + a12*D12(t) + e(t)
#
# Este modelo não pode ser estimado diretamente por MQO porque
# as dummies sazonais somam 1 e isso cria colinearidade perfeita
# com a constante b0.
#
# Há 2 soluções para este problema:
#
# 1) estimar sem uma das dummies, por exemplo, sem D12(t). Isso
# não é o idela porque todos os estimadores dos parâmetros ficam
# enviesados, Por exemplo, E(^b0) = (b0+a12). Ou seja, os parâmetros
# b0 e a12 não podem ser estimados e os demais ficam enviesados.
#
# 2) estimar impondo a restriação de que a1 + a2 + … + a12 = 0.
# Isto resolve o problema e todos os parâmetros são estimados
# univocamente.
#
# MODELO MULTIPLICATIVO
#
# Y(t) = T(t) x S(t) x e(t)
#
# T(t) = exp(b0 + b1*t)
#
# S(t) = exp(a1*D1(t) + a2*D2(t) + … + a12*D12(t))
#
# Este modelo estima-se transformando a série em log neperiano e
# aplicando-se, então, a mesma metodologia para o modelo aditivo.
# Veja mais detalhes no materia didático do curso.
#======================================================================
# By RSM 15/01/2018; Atualizada 06/08/2019
#======================================================================

rm(list=ls())
graphics.off()

library(forecast)

# Lendo dados da variavel RETAIL, a partir do arquivo “retail.txt”
#======================================================================

retail <- read.table(“retail.txt”,header=TRUE,sep = “”)
retail <- ts(retail, start = c(1953,1), frequency = 12)

# Fazendo Gráfico da Série Temporal
#======================================================================

#log_retail <- log(retail)
#retail.data <- ts(data.frame(retail,log_retail))
plot(retail, main = “Vendas do Comércio Varejista dos EUA”)

# Criando variáveis tempo (‘t’) e dummies sazonais D1,…,D11
#======================================================================

t <- seq(1, length(retail))
t <- ts(t, start = c(1953,1), frequency = 12)

DUM <- seasonaldummy(retail)
d1 <- DUM[,1]
d2 <- DUM[,2]
d3 <- DUM[,3]
d4 <- DUM[,4]
d5 <- DUM[,5]
d6 <- DUM[,6]
d7 <- DUM[,7]
d8 <- DUM[,8]
d9 <- DUM[,9]
d10 <- DUM[,10]
d11 <- DUM[,11]

# MODELO ADITIVO 1 (MA1)
# (incorreto porque enviesa o intercepto b0 da tendencia)
#======================================================================

# MA1: Estimação do MDR
#======================================================================
fit.ma1 <- tslm(retail ~ t + d1 + d2 + d3 + d4 + d5 + d6 +
                  d7 + d8 + d9 + d10 + d11)
print(summary(fit.ma1))

# MA1: Tendência Estimada
#======================================================================
b0_ma1 <- fit.ma1$coef[1]
b1_ma1 <- fit.ma1$coef[2]
Tchap_ma1 <- b0_ma1 + b1_ma1*t

# MA1: Verificando o erro na modelagem da tendência
#======================================================================
ts.plot(retail, Tchap_ma1, gpars=list(col=c(1,2)))

# MA1: Sazonalidade Estimada
#======================================================================
# Fatores Sazonais Aditivos Estimados

a1_ma1 <- fit.ma1$coef[3]
a2_ma1 <- fit.ma1$coef[4]
a3_ma1 <- fit.ma1$coef[5]
a4_ma1 <- fit.ma1$coef[6]
a5_ma1 <- fit.ma1$coef[7]
a6_ma1 <- fit.ma1$coef[8]
a7_ma1 <- fit.ma1$coef[9]
a8_ma1 <- fit.ma1$coef[10]
a9_ma1 <- fit.ma1$coef[11]
a10_ma1 <- fit.ma1$coef[12]
a11_ma1 <- fit.ma1$coef[13]

barplot(c(a1_ma1,a2_ma1,a3_ma1,a4_ma1,a5_ma1,a6_ma1,
          a7_ma1,a8_ma1,a9_ma1,a10_ma1,a11_ma1),
        main = “MA1: Fatores Sazonais Aditivos”)

# Componente Sazonal
Schap_ma1 <- a1_ma1*d1 + a2_ma1*d2 + a3_ma1*d3 + a4_ma1*d4 +
  a5_ma1*d5 + a6_ma1*d6 + a7_ma1*d7 + a8_ma1*d8 + a9_ma1*d9 +
  a10_ma1*d10 + a11_ma1*d11
Schap_ma1 <- ts(Schap_ma1, start = c(1953,1), frequency = 12)
ts.plot(Schap_ma1)

# MA1: Ajustado vs Realizado
#======================================================================
ts.plot(retail, Tchap_ma1 + Schap_ma1, gpars=list(col=c(1,2)), main = “Ajustado vs Realizado”)

# MA1: RETAIL e seus componentes
#======================================================================
echap_ma1 <- retail – Tchap_ma1 – Schap_ma1
fit.tudoma1 <- data.frame(retail, Tchap_ma1, Schap_ma1, echap_ma1)
colnames(fit.tudoma1) <- c(‘retail’,’T’,’S’,’e’)
fit.tudoma1 <- ts(fit.tudoma1, start=c(1953,1), frequency=12)
plot.ts(fit.tudoma1, main = “Decomposição via Modelo Aditivo com Restrição”)

# MODELO ADITIVO 2
# (correto: usa dummies sazonais trinarias ao inves das binarias)
#======================================================================

# Criação das dummies sazonais trinárias
#======================================================================
ll <- ts(rep(1,length(retail)), start = c(1953,1), frequency = 12) # vetor de 1s para criar Dummy Sazonal de Dezembro
d12 <- ll – d1 – d2 – d3 – d4 – d5 – d6 – d7 – d8 – d9 – d10 – d11 #<- Dummy Sazonal de Dezembro
dt1 <- d1 – d12 #
dt2 <- d2 – d12 #
dt3 <- d3 – d12 # <- É preciso criar aqui as 11 dummies trinarias:
dt4 <- d4 – d12 #
dt5 <- d5 – d12 # Dj_ = (1 se t~1, -1 se t~12, 0 outro)
dt6 <- d6 – d12 #
dt7 <- d7 – d12 #
dt8 <- d8 – d12 #
dt9 <- d9 – d12 #
dt10 <- d10 – d12 #
dt11 <- d11 – d12 #

# MA2: Estimando o MDR
#======================================================================
fit.ma2 <- lm(retail ~ t + dt1 + dt2 + dt3 + dt4 + dt5 + dt6 + dt7 + dt8 + dt9 + dt10 + dt11)
print(summary(fit.ma2))

# MA2: Tendência Estimada
#======================================================================
b0_ma2 <- fit.ma2$coef[1]
b1_ma2 <- fit.ma2$coef[2]
Tchap_ma2 <- b0_ma2 + b1_ma2*t

# MA2: Verificando que a tendencia foi corretamente modelada desta vez
#======================================================================
ts.plot(retail, Tchap_ma2, gpars=list(col=c(1,2)))

# MA2: Sazonalidade Estimada
#======================================================================
# Fatores Sazonais

a1_ma2 <- fit.ma2$coef[3]
a2_ma2 <- fit.ma2$coef[4]
a3_ma2 <- fit.ma2$coef[5]
a4_ma2 <- fit.ma2$coef[6]
a5_ma2 <- fit.ma2$coef[7]
a6_ma2 <- fit.ma2$coef[8]
a7_ma2 <- fit.ma2$coef[9]
a8_ma2 <- fit.ma2$coef[10]
a9_ma2 <- fit.ma2$coef[11]
a10_ma2 <- fit.ma2$coef[12]
a11_ma2 <- fit.ma2$coef[13]
# Computa-se também o 12o fator sazonal
a12_ma2 <- -(a1_ma2 + a2_ma2 + a3_ma2 + a4_ma2 + a5_ma2 + a6_ma2 +
               a7_ma2 + a8_ma2 + a9_ma2 + a10_ma2 + a11_ma2)

barplot(c(a1_ma2,a2_ma2,a3_ma2,a4_ma2,a5_ma2,a6_ma2,
          a7_ma2,a8_ma2,a9_ma2,a10_ma2,a11_ma2,a12_ma2),
        main = “MA2: Fatores Sazonais Aditivos”)

# Componente Sazonal
#
# Obs: note que a seguir o CS é calculado usando-se as dummies sazonais binárias

Schap_ma2 <- a1_ma2*d1 + a2_ma2*d2 + a3_ma2*d3 + a4_ma2*d4 +
  a5_ma2*d5 + a6_ma2*d6 + a7_ma2*d7 + a8_ma2*d8 + a9_ma2*d9 +
  a10_ma2*d10 + a11_ma2*d11 + a12_ma2*d12
Schap_ma2 <- ts(Schap_ma2, start = c(1953,1), frequency = 12)
ts.plot(Schap_ma2)

# MA2: Ajustado vs Realizado
#======================================================================
ts.plot(retail, Tchap_ma2 + Schap_ma2, gpars=list(col=c(1,2)),
        main = “Ajustado vs Realizado”)

# MA2: RETAIL e seus componentes
#======================================================================
echap_ma2 <- retail – Tchap_ma2 – Schap_ma2
fit.tudoma2 <- data.frame(retail, Tchap_ma2, Schap_ma2, echap_ma2)
colnames(fit.tudoma2) <- c(‘retail’,’T’,’S’,’e’)
fit.tudoma2 <- ts(fit.tudoma2, start=c(1953,1), frequency=12)
plot.ts(fit.tudoma2, main = “Decomposição via Modelo Aditivo com Restrição”)

#=======================================================================

# MODELO MULTPLICATIVO
# (versão correta, usando-se dummies sazonais trinárias)

# MM: Estimando o MDR
#======================================================================
lretail <- log(retail)
fit.mm <- lm(lretail ~ t + dt1 + dt2 + dt3 + dt4 + dt5 + dt6 +
               dt7 + dt8 + dt9 + dt10 + dt11)
print(summary(fit.mm))

# MM: Tendência Estimada
#======================================================================
b0_mm <- fit.mm$coef[1]
b1_mm <- fit.mm$coef[2]
Tchap_mm <- exp(b0_mm + b1_mm*t) #<== repare aqui o uso da função ‘exp()’

# MM: Verificando que a tendencia foi corretamente modelada desta vez
#======================================================================
ts.plot(retail, Tchap_mm, gpars=list(col=c(1,2)))

# MM: Sazonalidade Estimada
#======================================================================
# Fatores Sazonais Multiplicativos

a1_mm <- fit.mm$coef[3]
a2_mm <- fit.mm$coef[4]
a3_mm <- fit.mm$coef[5]
a4_mm <- fit.mm$coef[6]
a5_mm <- fit.mm$coef[7]
a6_mm <- fit.mm$coef[8]
a7_mm <- fit.mm$coef[9]
a8_mm <- fit.mm$coef[10]
a9_mm <- fit.mm$coef[11]
a10_mm <- fit.mm$coef[12]
a11_mm <- fit.mm$coef[13]
# Computa-se também o 12o fator sazonal
a12_mm <- -(a1_mm + a2_mm + a3_mm + a4_mm + a5_mm + a6_mm +
              a7_mm + a8_mm + a9_mm + a10_mm + a11_mm)

barplot(exp(c(a1_mm,a2_mm,a3_mm,a4_mm,a5_mm,a6_mm,
              a7_mm,a8_mm,a9_mm,a10_mm,a11_mm,a12_mm)),
        main = “MM: Fatores Sazonais Multiplicativos”)

# Componente Sazonal
Schap_mm <- exp(a1_mm*d1 + a2_mm*d2 + a3_mm*d3 + a4_mm*d4 +
                  a5_mm*d5 + a6_mm*d6 + a7_mm*d7 + a8_mm*d8 + a9_mm*d9 +
                  a10_mm*d10 + a11_mm*d11 + a12_mm*d12) #<== novamente o uso de ‘exp()’

Schap_mm <- ts(Schap_mm, start = c(1953,1), frequency = 12)
ts.plot(Schap_mm, main = “MM: Componente Sazonal”)

# MM: Ajustado vs Realizado
#=================================================================================
ts.plot(retail, Tchap_mm * Schap_mm, gpars=list(col=c(1,2)),
        main = “Ajustado vs Realizado”)

# MM: RETAIL e seus componentes
#=================================================================================
echap_mm <- retail/(Tchap_mm*Schap_mm)
fit.tudomm <- data.frame(retail, Tchap_mm, Schap_mm, echap_mm)
colnames(fit.tudomm) <- c(‘retail’,’T’,’S’,’e’)
fit.tudomm <- ts(fit.tudomm, start=c(1953,1), frequency=12)
plot.ts(fit.tudomm, main = “Decomposição via Modelo Multiplicativo com Restrição”)

#====== FIM ======================================================================