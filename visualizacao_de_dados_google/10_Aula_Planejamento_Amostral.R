

Questionario_Estresse$numero<-1:95

numero<-1:95


amostra<-sample(numero,10)
amostra<-data.frame(amostra)
colnames(amostra)<-"numero"



library(dplyr)
amostra<-left_join(amostra, Questionario_Estresse)


library(dplyr)
amostra2<-sample_n(Questionario_Estresse, 10)

###########################################################

library(TeachingSampling)
# Uses the Lucy data to draw a stratified random sample
data(Lucy)
# Level is the stratifying variable
summary(Lucy$Level)
# Defines the size of each stratum
N1<-summary(Lucy$Level)[[1]]
N2<-summary(Lucy$Level)[[2]]
N3<-summary(Lucy$Level)[[3]]
N1;N2;N3
Nh <- c(N1,N2,N3)
# Defines the sample size at each stratum
n1<-70
n2<-100
n3<-200
nh<-c(n1,n2,n3)
# Draws a stratified sample
sam <- S.STSI(Lucy$Level, Nh, nh)
# The information about the units in the sample is stored in an object called data
data <- Lucy[sam,]
data
dim(data)


Questionario_Estresse$Turma<-as.factor(Questionario_Estresse$Turma)
summary(Questionario_Estresse$Turma)
# Defines the size of each stratum
N1<-summary(Questionario_Estresse$Turma)[[1]]
N2<-summary(Questionario_Estresse$Turma)[[2]]
N3<-summary(Questionario_Estresse$Turma)[[3]]
N1;N2;N3
Nh <- c(N1,N2,N3)
# Defines the sample size at each stratum
n1<-10
n2<-10
n3<-15
nh<-c(n1,n2,n3)
# Draws a stratified sample
sam <- S.STSI(Questionario_Estresse$Turma, Nh, nh)
# The information about the units in the sample is stored in an object called data
data <- Questionario_Estresse[sam,]
data
dim(data)

###################################################################################
data(Lucy)
# The selection probability of each unit is proportional to the variable Income
res <- S.piPS(400,Lucy$Income)
# The selected sample
sam <- res[,1]
# The inclusion probabilities of the units in the sample
Pik.s <- res[,2]
# The information about the units in the sample is stored in an object called data
data <- Lucy[sam,]
data
dim(data)

# The selection probability of each unit is proportional to the Desempenho
res <- S.piPS(30,Questionario_Estresse$Desempenho)
# The selected sample
sam <- res[,1]
# The inclusion probabilities of the units in the sample
Pik.s <- res[,2]
# The information about the units in the sample is stored in an object called data
data <- Questionario_Estresse[sam,]
data
dim(data)


##############################################################
##############################################################
# Uses the Lucy data to draw a Systematic sample
data(Lucy)

N <- dim(Lucy)[1]
# The population is divided in 6 groups
# The selected sample
sam <- S.SY(N,6)
# The information about the units in the sample is stored in an object called data
data <- Lucy[sam,]
data
dim(data)


N <- dim(Questionario_Estresse)[1]
# The population is divided in 6 groups
# The selected sample
sam <- S.SY(N,10)
# The information about the units in the sample is stored in an object called data
data <- Questionario_Estresse[sam,]
data
dim(data)
