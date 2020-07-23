###CHAPTER 7: GENERALIZED LINEAR MODELS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILES: SinghJTP.dta, SinghEJPR.dta, and PESenergy.csv

##SECTION 7.1: BINARY OUTCOMES##
#clean up
rm(list=ls())

#load package
library(foreign)

#load data
voting<-read.dta("SinghJTP.dta",convert.factors=FALSE)
#voting<-read.dta("http://j.mp/SINGHjtp",convert.factors=FALSE)

#SECTION 7.1.1: LOGIT MODELS#
#estimate logistic regression model of whether respondents voted for incumbent party based on LINEAR ideological distance
inc.linear<-glm(votedinc~distanceinc,family=binomial(link="logit"),data=voting)
summary(inc.linear)

#LaTeX code for results table
#library(xtable)
#xtable(inc.linear)

#compute predicted outcomes
predicted<-as.numeric(predict.glm(inc.linear,type="response")>.5)

#save vector of whether voters voted for the incumbent
true<-voting$votedinc[voting$voted==1]

#record whether predicted vote matches actual vote and compute percentage correct
correct<-as.numeric(predicted==true)
100*table(correct)/sum(table(correct))

#estimate logistic regression model of whether respondents voted for incumbent party based on QUADRATIC ideological distance
inc.squared<-glm(votedinc~distanceincsq,family=binomial(link="logit"),data=voting)
summary(inc.squared)

#SECTION 7.1.2: PROBIT MODELS#
#estimate probit regression model of whether respondents voted at all based on linear distance to nearset party
turnout.linear<-glm(voted~distanceweighted,family=binomial(link="probit"),data=voting)
summary(turnout.linear)

#SECTION 7.1.3: INTERPRETING LOGIT AND PROBIT RESULTS#
#odds ratio from logistic model of incumbent vote based on linear distance
exp(inc.linear$coefficients[-1])

#interpreting odds ratio in percentage terms
100*(exp(inc.linear$coefficients[-1])-1)

#create predicted probabilities of whether voters chose the incumbent party based on LINEAR ideological distance
distances<-seq(0,10,by=.1)
inputs<-cbind(1,distances)
colnames(inputs)<-c("constant","distanceinc")
inputs<-as.data.frame(inputs)
forecast.linear<-predict(inc.linear,newdata=inputs,type="response")

#create predicted probabilities of whether voters chose the incumbent party based on QUADRATIC ideological distance
inputs2<-cbind(1,distances^2)
colnames(inputs2)<-c("constant","distanceincsq")
inputs2<-as.data.frame(inputs2)
forecast.squared<-predict(inc.squared,newdata=inputs2,type="response")

#plot predicted probabilities based on linear and quadratic functional forms
plot(y=forecast.linear,x=distances,ylim=c(0,.6),type="l",lwd=2,xlab="",ylab="")
lines(y=forecast.squared,x=distances,lty=2,col="blue",lwd=2)
legend(x=6,y=.5,legend=c("linear","squared"),lty=c(1,2),col=c("black","blue"),lwd=2)
mtext("Ideological Distance",side=1,line=2.75,cex=1.2)
mtext("Probability of Voting for Incumbent",side=2,line=2.5,cex=1.2)

#compute predicted probabilities of turnout based on probit model
wght.dist<-seq(0,4,by=.1)
inputs.3<-cbind(1,wght.dist)
colnames(inputs.3)<-c("constant","distanceweighted")
inputs.3<-as.data.frame(inputs.3)
forecast.probit<-predict(turnout.linear,newdata=inputs.3,type="link",se.fit=TRUE)

#compute confidence intervals of predicted probabilities of turnout
lower.ci<-forecast.probit$fit-1.95996399*forecast.probit$se.fit
upper.ci<-forecast.probit$fit+1.95996399*forecast.probit$se.fit

#plot predicted probabilities of turnout with confidence intervals
plot(y=pnorm(forecast.probit$fit),x=wght.dist,ylim=c(.7,.9),type="l",lwd=2,xlab="Weighted Ideological Distance",ylab="Probability of Turnout")
lines(y=pnorm(lower.ci),x=wght.dist,lty=3,col="red",lwd=2)
lines(y=pnorm(upper.ci),x=wght.dist,lty=3,col="red",lwd=2)

##SECTION 7.2: ORDINAL OUTCOMES##
#clean up
rm(list=ls())

#load package
library(foreign)

#load data
satisfaction<-read.dta("SinghEJPR.dta")
#satisfaction<-read.dta("http://j.mp/SINGHejpr")

#load package
library(MASS)

#convert satisfaction with democracy into an ordered factor
satisfaction$satisfaction<-ordered(as.factor(satisfaction$satisfaction))

#estimate ordered logit model of satisfaction with democracy based on voting for ideologically proximate party
ideol.satisfaction<-polr(satisfaction~voted_ideo*winner+abstained+educ+efficacy+majoritarian_prez+freedom+gdppercapPPP+gdpgrowth+CPI+prez,method="logistic",data=satisfaction)
summary(ideol.satisfaction)

#LaTeX code for table
#coef<-c(ideol.satisfaction$coefficients,ideol.satisfaction$zeta)
#se<-sqrt(diag(vcov(ideol.satisfaction)))
#z<-coef/se
#p<-2*(1-pnorm(abs(z)))
#xtable(cbind(coef,se,z,p),digits=4)

#one-tailed p-value testing whether the interaction between voting for the proximate party, which also won, is positive
1-pnorm(5.0957)

#odds ratios for ordered logit of satisfaction, with percentage changes as well
exp(-ideol.satisfaction$coefficients)
100*(exp(-ideol.satisfaction$coefficients)-1)

#estimate ordered probit model of satisfaction with democracy based on voting for party regarded with highest affect
affect.satisfaction<-polr(satisfaction~voted_affect*winner+abstained+educ+efficacy+majoritarian_prez+freedom+gdppercapPPP+gdpgrowth+CPI+prez,method="probit",data=satisfaction)
summary(affect.satisfaction)

##SECTION 7.3: EVENT COUNTS##
#clean up
rm(list=ls())

#load data
pres.energy<-read.csv("PESenergy.csv")
#pres.energy<-read.csv("http://j.mp/PRESenergy")

#SECTION 7.3.1: POISSON REGRESSION#
#estimate Poisson regression model of monthly energy policy coverage
energy.poisson<-glm(Energy~rmn1173+grf0175+grf575+jec477+jec1177+jec479+embargo+hostages+oilc+Approval+Unemploy,family=poisson(link=log),data=pres.energy)
summary(energy.poisson)

#count ratio of the effect of presidential approval
exp(-.034096)

#count ratios of all predictors, with percentage changes as well
exp(energy.poisson$coefficients[-1])
100*(exp(energy.poisson$coefficients[-1])-1)

#SECTION 7.3.2: NEGATIVE BINOMIAL REGRESSION#
#negative binomial regression model of monthly energy policy coverage
energy.nb<-glm.nb(Energy~rmn1173+grf0175+grf575+jec477+jec1177+jec479+embargo+hostages+oilc+Approval+Unemploy,data=pres.energy)
summary(energy.nb)

#SECTION 7.3.3: PLOTTING PREDICTED COUNTS#
#create a vector of possible values of approval
approval<-seq(24,72.3,by=.1)

#create a data frame of predictor values for forecast, using typical values of predictors and vector of possible approval values
inputs.4<-cbind(1,0,0,0,0,0,0,0,0,mean(pres.energy$oilc),approval,mean(pres.energy$Unemploy))
colnames(inputs.4)<-c("constant","rmn1173","grf0175","grf575","jec477","jec1177","jec479","embargo","hostages","oilc","Approval","Unemploy")
inputs.4<-as.data.frame(inputs.4)

#create predicted counts for Poisson and negative binomial regression models based on data frame of typical values, manipulating approval
forecast.poisson<-predict(energy.poisson,newdata=inputs.4,type="response")
forecast.nb<-predict(energy.nb,newdata=inputs.4,type="response")

#plot predicted counts for Poisson and negative binomial regressions
plot(y=forecast.poisson,x=approval,type="l",lwd=2,ylim=c(0,60),xlab="Presidential Approval",ylab="Predicted Count of Energy Policy Stories")
lines(y=forecast.nb,x=approval,lty=2,col="blue",lwd=2)
legend(x=50,y=50,legend=c("Poisson","Negative Binomial"),lty=c(1,2),col=c("black","blue"),lwd=2)
