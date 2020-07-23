###CHAPTER 5: BASIC INFERENCES AND BIVARIATE ASSOCIATION###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILE: LL.csv, or open LL from the 'cem' package

#clean up
rm(list=ls())

##SECTION 5.1: SIGNIFICANCE TESTS FOR MEANS##
#load data via the 'cem' library, install 'cem' once on first use
#install.packages('cem')
library(cem)
data(LL)

#alternate data load
#LL<-read.csv('LL.csv')

#test whether population of long-term unemployed had lower average income than U.S. population in 1974
t.test(LL$re74, mu=6059, alternative="less")

#SECTION 5.1.1: TWO-SAMPLE DIFFERENCE OF MEANS TEST, INDEPENDENT SAMPLES
#test whether treated individuals earned more in 1978 than controls, assuming different income variance for each group
t.test(re78~treated,data=LL,alternative="less",var.equal=F)

#test whether treated individuals earned more in 1978 than controls, assuming the same income variance for both groups
t.test(re78~treated,data=LL,alternative="less",var.equal=T)

#SECTION 5.1.2: COMPARING MEANS WITH DEPENDENT SAMPLES#
#subset to control group only
LL.0<-subset(LL,treated==0)

#test whether control group income rose from 1974 to 1978
t.test(LL.0$re74,LL.0$re78,paired=T,alternative="less")

#subset to treated group only
LL.1<-subset(LL,treated==1)

#test whether treated group income rose from 1974 to 1978
t.test(LL.1$re74,LL.1$re78,paired=T,alternative="less")

##SECTION 5.2: CROSS-TABULATIONS##
#load 'gmodels' package, install on first use
install.packages('gmodels')
library(gmodels)

#cross-tabulation of unemployment in 1975 contingent on unemployment in 1974
CrossTable(y=LL$u75,x=LL$u74,prop.c=F,prop.t=F,prop.chisq=F,chisq=T,format="SPSS")

#cross-tabulation of unemployment in 1975 contingent on receiving the treatment
CrossTable(y=LL$u75,x=LL$treated,prop.c=F,prop.t=F,prop.chisq=F,chisq=T,format="SPSS")

##SECTION 5.3: CORRELATION COEFFICIENTS##
#correlation between education and income in 1974
cor(LL$education,LL$re74)

#variance explained by one predictor
cor(LL$education,LL$re74)^2

#correlation between income in 1975 and 1978
cor(LL$re75,LL$re78)

#variance explained by one predictor
cor(LL$re75,LL$re78)^2

#scatterplot of income in 1978 against income in 1975
plot(x=LL$re75,y=LL$re78,xlab="1975 Income",ylab="1978 Income",asp=1,xlim=c(0,60000),ylim=c(0,60000),pch=".")
