# gerando banco de dados com variáveis correlacionadas para exercicio

# gerando DUAS variáveis com uma correlação de 0,73
samples = 10000
r = 0.73

library('MASS')
data = mvrnorm(n=samples, mu=c(0, 0), Sigma=matrix(c(1, r, r, 1), nrow=2), empirical=TRUE)
X = data[, 1]  # standard normal (mu=0, sd=1)
Y = data[, 2]  # standard normal (mu=0, sd=1)

cor(X, Y)  # yay!
cor(X*0.01 + 42, Y*3 - 1)  # Linear transformations of X and Y won't change r.



# gerando DEZ variáveis correlacionadas
set.seed(12345)
library(clusterGeneration)
Sigma<-genPositiveDefMat("onion",dim=7)
Sigma$Sigma



library(Matrix)
#Sigma<-matrix(rnorm(49,mean = 100, sd = 5),7)
Sigma[lower.tri(Sigma)] = t(Sigma)[lower.tri(Sigma)]
Sigma <- nearPD(Sigma$Sigma, conv.tol = 1e-7, corr = TRUE)
mu<-rep(10,7)

variancia<-var(mvrnorm(n = 100, mu=mu, Sigma$mat, empirical = TRUE))

meu_banco_de_dados <- mvrnorm(n = 10000, mu=mu, Sigma$mat, empirical = TRUE)
cor(meu_banco_de_dados)




# Sigma<- <- Matrix(c(1,     0.477, 0.644, 0.478, 0.651, 0.826,
#                     0.477, 1,     0.516, 0.233, 0.682, 0.75,
#                     0.644, 0.516, 1,     0.599, 0.581, 0.742,
#                     0.478, 0.233, 0.599, 1,     0.741, 0.8,
#                     0.651, 0.682, 0.581, 0.741, 1,     0.798,
#                     0.826, 0.75,  0.742, 0.8,   0.798, 1),
#                     nrow = 6, ncol = 6)









