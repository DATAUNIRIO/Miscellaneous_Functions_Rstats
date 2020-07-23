###CHAPTER 9: TIME SERIES ANALYSIS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILES: PESenergy.csv and levant.dta

#clean up
rm(list=ls())

##SECTION 9.1: THE BOX-JENKINS METHOD##
#load data
#pres.energy<-read.csv("http://j.mp/PRESenergy")
pres.energy<-read.csv("PESenergy.csv")

#autocorrelation and partial autocorrelation functions
acf(pres.energy$Energy,lag.max=24)
pacf(pres.energy$Energy,lag.max=24)

#estimate ARIMA model
ar1.mod<-arima(pres.energy$Energy,order=c(1,0,0))
ar1.mod

#diagnose model
tsdiag(ar1.mod,24)

#autocorrelation and partial autocorrelation functions on residuals
acf(ar1.mod$residuals,lag.max=24)
pacf(ar1.mod$residuals,lag.max=24)

#Ljung-Box Q test
Box.test(ar1.mod$residuals,lag=24,type='Ljung-Box')

#SECTION 9.1.1: TRANSFER FUNCTIONS VERSUS STATIC MODELS#
#static regression model with ARIMA error process
predictors<-as.matrix(subset(pres.energy,select=c(rmn1173,grf0175,grf575,jec477,jec1177,jec479,embargo,hostages,oilc,Approval,Unemploy)))
static.mod<-arima(pres.energy$Energy, order=c(1,0,0), xreg=predictors)
static.mod

#load package
#install.packages('TSA')
library(TSA)

#estimate transfer function
dynamic.mod<-arimax(pres.energy$Energy,order=c(1,0,0),xreg=predictors[,-1],xtransf=predictors[,1],transfer=list(c(1,0)))
dynamic.mod

#plot the dynamic effect of the intervention over the raw series
months<-c(1:180)
y.pred<-dynamic.mod$coef[2:12]%*%c(1,predictors[58,-1])+160.6241*predictors[,1]+160.6241*(.6087^(months-59))*as.numeric(months>59)
plot(y=pres.energy$Energy,x=months,xlab="Month",ylab="Energy Policy Stories",type="l",axes=F)
axis(1,at=c(1,37,73,109,145),labels=c('Jan. 1969','Jan. 1972','Jan. 1975','Jan. 1978','Jan. 1981'))
axis(2)
box()     
lines(y=y.pred,x=months,lty=2,col='blue',lwd=2)

#plot predicted values of the series with a line, with true values as points
months<-c(1:180)
full.pred<-pres.energy$Energy-dynamic.mod$residuals
plot(y=full.pred,x=months,xlab="Month",ylab="Energy Policy Stories",type="l",ylim=c(0,225),axes=F)
points(y=pres.energy$Energy,x=months,pch=20)
legend(x=0,y=200,legend=c("Predicted","True"),pch=c(NA,20),lty=c(1,NA))
axis(1,at=c(1,37,73,109,145),labels=c('Jan. 1969','Jan. 1972','Jan. 1975','Jan. 1978','Jan. 1981'))
axis(2)
box()  

##SECTION 9.2: EXTENSIONS TO LEAST SQUARES LINEAR REGRESSION MODELS##
#naive linear model fitted with OLS
static.ols<-lm(Energy~rmn1173+grf0175+grf575+jec477+jec1177+jec479+embargo+hostages+oilc+Approval+Unemploy,data=pres.energy)
summary(static.ols)

#load package
library(lmtest)

#Durbin-Watson test for residual autocorrelation
dwtest(static.ols)

#Breusch-Godfrey test for residual autocorrelation
bgtest(static.ols)

#load package
#install.packages('orcutt')
library(orcutt)

#feasible generalized least squares using Cochrane-Orcutt algorithm
cochrane.orcutt(static.ols)

#load package
#install.packages('dyn')
library(dyn)

#declare the data to be time series data
pres.energy<-ts(pres.energy)

#estimate dynamic Koyck model with OLS
koyck.ols<-dyn$lm(Energy~lag(Energy,-1)+rmn1173+grf0175+grf575+jec477+jec1177+jec479+embargo+hostages+oilc+Approval+Unemploy,data=pres.energy)
summary(koyck.ols)

#long-term effect of a permanent percentage point rise in unemployment
koyck.ols$coefficients[13]/(1-koyck.ols$coefficients[2])

#unrestricted distributed lag model with four lags of the Nixon speech intervention
udl.mod<-dyn$lm(Energy~rmn1173+lag(rmn1173,-1)+lag(rmn1173,-2)+lag(rmn1173,-3)+lag(rmn1173,-4)+grf0175+grf575+jec477+jec1177+jec479+embargo+hostages+oilc+Approval+Unemploy,data=pres.energy)
summary(udl.mod)

##SECTION 9.3: VECTOR AUTOREGRESSION##
#load packages
#install.packages('vars')
library(vars)
library(foreign)

#load and subset data
#levant.0 <- read.dta("http://j.mp/levantData") 
levant.0 <- read.dta("levant.dta") 
levant<- subset(levant.0,select=c('a2i','a2p','i2p','i2a','p2i','p2a'))

#select appropriate lag length with fit indices
levant.select<-VARselect(levant,type="const",lag.max=104)
levant.select$selection
levant.select$criteria

#estimate 60 lag model
levant.AIC<-VAR(levant,type="const",p=60)

#plot VAR model diagnostics, interactive output with multiple plots
plot(levant.AIC,lag.acf=104,lag.pacf=104) 

#plot VAR model diagnostics for one endogenous variable
plot(levant.AIC,lag.acf=104,lag.pacf=104,names="i2p") 

#Granger causality test of whether each variable causes the others
causality(levant.AIC, cause="i2p")$Granger
causality(levant.AIC, cause="a2i")$Granger
causality(levant.AIC, cause="a2p")$Granger
causality(levant.AIC, cause="i2a")$Granger
causality(levant.AIC, cause="p2i")$Granger
causality(levant.AIC, cause="p2a")$Granger

#create and plot impulse response function with bootstrapped confidence intervals
levant.irf<-irf(levant.AIC,impulse="i2p",n.ahead=12,boot=TRUE)
plot(levant.irf)

##SECTION 9.5: ALTERNATIVE TIME SERIES CODE##
#set up necessary package and data again
library(TSA)
#pres.energy<-read.csv("http://j.mp/PRESenergy")
pres.energy<-read.csv("PESenergy.csv")
predictors<-as.matrix(subset(pres.energy,select=c(rmn1173,grf0175,grf575,jec477,jec1177,jec479,embargo,hostages,oilc,Approval,Unemploy)))

#new form of data management, encoding vectors as time series
months <- 1:180
static.predictors <- predictors[,-1]
dynamic.predictors <- predictors[,1, drop=FALSE]
y <- ts(pres.energy$Energy, frequency=12, start=c(1972, 1))

#refit model and save outputs
dynamic.mod<-arimax(y,order=c(1,0,0),xreg=static.predictors,xtransf=dynamic.predictors,transfer=list(c(1,0)))
b <- coef(dynamic.mod)
static.coefs <- b[match(colnames(static.predictors), names(b))]
ma.coefs <- b[grep("MA0", names(b))]
ar.coefs <- b[grep("AR1", names(b))]

#inputs for Figure 9.3
xreg.pred<-b["intercept"]+static.coefs%*%static.predictors[58,]
transf.pred <- as.numeric(dynamic.predictors%*%ma.coefs+ma.coefs*(ar.coefs^(months-59))*(months>59))
y.pred<-ts(xreg.pred+transf.pred,frequency=12,start=c(1972,1))

#plot Figure 9.3
plot(y,xlab="Month", ylab="Energy Policy Stories",type="l")
lines(y.pred, lty=2,col='blue',lwd=2)

#plot Figure 9.4
full.pred<-fitted(dynamic.mod)
plot(full.pred,ylab="Energy Policy Stories",type="l",ylim=c(0,225))
points(y, pch=20)

