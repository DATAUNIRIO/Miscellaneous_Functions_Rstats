# parte 1
numero_de_caras <- 0:1000
numero_de_caras <- 470:610
#numero_de_caras <- 470:610
plot(numero_de_caras, dbinom(numero_de_caras, size=1000, prob=.541),type='h')
prop.test(541, 1000, p = 0.5)


Um professor disse que 40% dos alunos do CCJP votaram no Crivella,
para verificar essa afirmação entrevistamos ALEATORIAMENTE 100 alunos (amostra).
Nessa pesquisa, descobrimos que 32 alunos entrevistados afirmaram ter votado no Crivella.
O professor está certo ou errado?
crivela_intervalo <- 20:60
plot(crivela_intervalo, dbinom(crivela_intervalo, size=100, prob=.32),type='h')

prop.test(32, 100, p = 0.4)

# parte 2
# https://cran.r-project.org/web/packages/smss/smss.pdf
library(smss)
library("smss")          
data(anorexia)

library(dplyr)
set.seed(12345)
amostra<-sample_n(anorexia,29)
amostra$diff<-(amostra$after-amostra$before)

mean(amostra$diff)
sd(amostra$diff)
erro<-sd(amostra$diff)/sqrt(29)
# Pressuposto: Amostra aleatoria
# Hipoteses H0: mu =0 e H1: mu>0
t<- mean(amostra$diff)/erro

t.test(amostra$diff,mu = 0,alternative = "greater")

# parte 3 - questionario estresse
# nota = 7
# HE =30
# cred = 25
# estresse 30



data(birth.rates)
summary(birth.rates)

data(crime2005)
summary(crime2005)

data(fertility.gdp)
summary(fertility.gdp)

data(fl.crime)
summary(fl.crime)

data(house.selling.price)
summary(house.selling.price)

data(house.selling.price.2)
summary(house.selling.price.2)

data(inc.ed.race.13p1)
summary(inc.ed.race.13p1)

data(income.credit)
summary(income.credit)

data(mental.impairment)
summary(mental.impairment)

data(oecd.data)
summary(oecd.data)

data(statewide.crime.2)
summary(statewide.crime.2)

data(student.survey)
summary(student.survey)

data(UNdata)
summary(UNdata)

data(us.pop.size)
summary(us.pop.size)

data(zagat)
summary(zagat)




summary(anorexia)
cor(anorexia$before,anorexia$after)
boxplot(anorexia$after~anorexia$therapy)
