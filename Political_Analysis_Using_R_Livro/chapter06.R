###CHAPTER 6: LINEAR MODELS AND REGRESSION DIAGNOSTICS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILE: BPchap7.dta

##SECTION 6.1: ESTIMATION WITH ORDINARY LEAST SQUARES##
#clean up
rm(list=ls())

#load package
library(foreign)

#load data
evolution<-read.dta("BPchap7.dta",convert.factors=FALSE)
#evolution<-read.dta("http://j.mp/BPchap7",convert.factors=FALSE)

#quick view of descriptive statistics
summary(evolution)

#recode missing observations of sex
evolution$female[evolution$female==9]<-NA

#revised view of descriptive statistics
summary(evolution)

#subset our data to observed only
evolution<-subset(evolution,!is.na(female))
#evolution<-na.omit(evolution)

#estimate linear regression model of hours spent teaching evolution with ordinary least squares
mod.hours<-lm(hrs_allev~phase1*senior_c+phase1*notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident,data=evolution)
summary(mod.hours)

#create LaTeX table for results
#install.packages('xtable')
#library(xtable)
#xtable(mod.hours)

#confidence intervals for regression coefficients
confint(mod.hours,level=0.90)

##SECTION 6.2: REGRESSION DIAGNOSTICS##
#SECTION 6.2.1: FUNCTIONAL FORM#
#plot residuals against fitted values
plot(y=mod.hours$residuals,x=mod.hours$fitted.values,xlab="Fitted Values",ylab="Residuals")

#plot residuals against RAW VALUES of how much the teacher thinks of him or herself as a scientist
plot(y=mod.hours$residuals,x=evolution$idsci_trans,xlab="Identifies as Scientist",ylab="Residuals")

#plot residuals against JITTERED VALUES of how much the teacher thinks of him or herself as a scientist
plot(y=mod.hours$residuals,x=jitter(evolution$idsci_trans,amount=.01),xlab="Identifies as Scientist (Jittered)",ylab="Residuals")

#Ramsey's RESET test, considering a cubic functional form
evolution$fit<-mod.hours$fitted.values
reset.mod<-lm(hrs_allev~phase1*senior_c+phase1*notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident+I(fit^2)+I(fit^3),data=evolution)
anova(mod.hours, reset.mod)

#load 'lmtest' library
#install.packages('lmtest')
library(lmtest)

#Durbin-Watson test for whether residuals are similar at similar levels of rigor of evolution standards
dwtest(mod.hours,order.by=evolution$phase1)

#refitted linear regression model with cubic form of rigor of evolution standards
mod.cubic<-lm(hrs_allev~phase1*senior_c+phase1*notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident+I(phase1^2)*senior_c+I(phase1^3)*senior_c++I(phase1^2)*notest_p+I(phase1^3)*notest_p,data=evolution)
summary(mod.cubic)

#SECTION 6.2.2: HETEROSCEDASTICITY#
#Breusch-Pagan test
bptest(mod.hours, studentize=FALSE)

#load 'sandwich' package
#install.packages('sandwich')
library(sandwich)

#compute Huber-White standard errors and re-report results
coeftest(mod.hours,vcov=vcovHC)

#compute squared residuals and fit regression to compute weights
evolution$resid2<-mod.hours$residuals^2
weight.reg<-lm(log(resid2)~phase1*senior_c+phase1*notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident, data=evolution)
summary(weight.reg)

#re-estimate linear regression model with weighted least squares
wls.mod<-lm(hrs_allev~phase1*senior_c+phase1*notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident,data=evolution,weights=I(1/exp(weight.reg$fitted.values)))
summary(wls.mod)

#SECTION 6.2.3: NORMALITY#
#histogram of residuals
hist(mod.hours$residuals,xlab="Residuals",main="")

#quantile-quantile plot, with guide line added
qqnorm(mod.hours$residuals)
qqline(mod.hours$residuals,col='red')

#load 'tseries' package
#install.packages('tseries')
library(tseries)

#Jarque-Bera test of residual normality
jarque.bera.test(mod.hours$residuals)

#SECTION 6.2.4: MULTICOLLINEARITY#
#load 'car' package
library(car)

#compute variance inflation factors
vif(mod.hours)

#SECTION 6.2.5: OUTLIERS, LEVERAGE, AND INFLUENTIAL DATA POINTS#
#plot Cook's D, Studentized residuals, and hat values
influenceIndexPlot(mod.hours,vars=c("Cook","Studentized","hat"),id.n=5)

