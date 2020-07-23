###CHAPTER 8: USING PACKAGES TO APPLY ADVANCED MODELS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILES: BPchap7.dta, SinghJTP.dta, LL.csv, and UN.csv

##SECTION 8.1: MULTILEVEL MODELS WITH lme4##
#clean up
rm(list=ls())

#load package
library(foreign)

#load and clean data
#evolution<-read.dta("http://j.mp/BPchap7")
evolution<-read.dta("BPchap7.dta")
evolution$female[evolution$female==9]<-NA
evolution<-subset(evolution,!is.na(female))

#load package
#install.packages("lme4")
library(lme4)

#estimate linear model of hours spent teaching evolution with random effects by state
hours.ml<-lmer(hrs_allev~phase1+senior_c+ph_senior+notest_p+ph_notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident+(1|st_fip),data=evolution)
summary(hours.ml)

#SECTION 8.1.2: MULTILEVEL LOGISTIC REGRESSION#
#load packages
library(lme4)
library(foreign)

#load data
#voting<-read.dta("http://j.mp/SINGHjtp")
voting<-read.dta("SinghJTP.dta")

#estimate logistic regression model of voting for incumbents with random effects by country-year
inc.linear.ml<-glmer(votedinc~distanceinc+(1|cntryyear),family=binomial(link="logit"),data=voting)
summary(inc.linear.ml)

#estimate logistic regression model of voting for incumbents with random intercepts and random coefficients on ideological distance by country-year
inc.linear.ml.2<-glmer(votedinc~distanceinc+(distanceinc|cntryyear),family=binomial(link="logit"),data=voting)
summary(inc.linear.ml.2)

##SECTION 8.2: BAYESIAN METHODS USING MCMCpack##
#SECTION 8.2.1: BAYESIAN LINEAR REGRESSION#
#clean up
rm(list=ls())

#load package
library(foreign)

#load and clean data
#evolution<-read.dta("http://j.mp/BPchap7")
evolution<-read.dta("BPchap7.dta")
evolution$female[evolution$female==9]<-NA
evolution<-subset(evolution,!is.na(female))

#load package
#install.packages("MCMCpack")
library(MCMCpack)

#Bayesian linear regression model of hours teaching evolution
mcmc.hours<-MCMCregress(hrs_allev~phase1+senior_c+ph_senior+notest_p+ph_notest_p+female+biocred3+degr3+evol_course+certified+idsci_trans+confident,data=evolution)
summary(mcmc.hours)

#LaTeX ouptut of Bayesian results
#library(xtable)
#xtable(cbind(summary(mcmc.hours)$statistics[,1:2],summary(mcmc.hours)$quantiles[,c(1,5)]),digits=4)

#Geweke diagnostic for non-convergence
geweke.diag(mcmc.hours, frac1=0.1, frac2=0.5)

#density plot for the effect of completing an evolution class
densplot(mcmc.hours[,10])

#density plot for the effect of self-rated expertise
densplot(mcmc.hours[,13])

#SECTION 8.2.2: BAYESIAN LOGISTIC REGRESSION#
#load packages
library(MCMCpack)
library(foreign)

#load data
#voting<-read.dta("http://j.mp/SINGHjtp")
voting<-read.dta("SinghJTP.dta")

#Bayesian logistic regression model of voting for the incumbent party
inc.linear.mcmc<-MCMClogit(votedinc~distanceinc,data=voting)

#Geweke diagnostic for non-convergence
geweke.diag(inc.linear.mcmc, frac1=0.1, frac2=0.5)

#increase number of iterations for Bayesian logistic regression model
inc.linear.mcmc.v2<-MCMClogit(votedinc~distanceinc,data=voting,burnin=2000,mcmc=20000)

#Geweke diagnositc for non-convergence
geweke.diag(inc.linear.mcmc.v2, frac1=0.1, frac2=0.5)

#summarize results of second run of logit model
summary(inc.linear.mcmc.v2)

##SECTION 8.3: CAUSAL INFERENCE WITH cem##
#SECTION 8.3.1: COVARIATE IMBALANCE, IMPLEMENTING CEM, AND THE ATT#
#clean up
rm(list=ls())

#load package
#install.packages('cem')
library(cem)

#load data
data(LL)
#LL<-read.csv('LL.csv')

#increase number of digits in printout
options(scipen=8)

#assess imbalance in covariates
todrop <- c("treated","re78")
imbalance(group=LL$treated, data=LL, drop=todrop)

#conduct coarsened exact matching on the data
cem.match.1 <- cem(treatment="treated", data=LL, drop="re78")
cem.match.1

#view breaks from coarsening
cem.match.1$breaks

#assess imbalance in matched sample
imbalance(LL$treated[cem.match.1$matched],LL[cem.match.1$matched,], drop=todrop)

#compute average treatment effect on the treated for the matched data
est.att.1 <- att(obj=cem.match.1, formula=re78~treated, data=LL)
est.att.1

#SECTION 8.3.2: EXPLORING DIFFERENT CEM SOLUTIONS#
#visual exploration of 250 coarsenings
cem.explore<-cemspace(treatment="treated",data=LL,drop="re78")

#bins for one level of coarsening
age.cut<-c(17, 26.5, 36, 45.5, 55)
education.cut<-c(3, 6.25, 9.5, 12.75, 16)
black.cut<-c(0, 0.5, 1)
married.cut<-c(0, 0.5, 1)
nodegree.cut<-c(0, 0.5, 1)
re74.cut<-c(0, 19785.34, 39570.68)
re75.cut<-c(0, 9357.92, 18715.83, 28073.75, 37431.66)
hispanic.cut<-c(0, 0.5, 1)
u74.cut<-c(0, 0.5, 1)
u75.cut<-c(0, 1)
new.cuts<-list(age=age.cut, education=education.cut, black=black.cut, married=married.cut, nodegree=nodegree.cut, re74=re74.cut, re75=re75.cut, hispanic=hispanic.cut, u74=u74.cut, u75=u75.cut)

#alternative coarsened exact matching with newly specified cutpoints
cem.match.2 <- cem(treatment="treated", data=LL, drop="re78", cutpoints=new.cuts)

#view qualities of the new matched sample and the ATT
cem.match.2
imbalance(LL$treated[cem.match.2$matched], LL[cem.match.2$matched,], drop=todrop)
est.att.2 <- att(obj=cem.match.2, formula=re78~treated, data=LL)
est.att.2

##SECTION 8.4: LEGISLATIVE ROLL CALL ANALYSIS WITH wnominate##
#clean up
rm(list=ls())

#load package
#install.packages('wnominate')
library(wnominate)

#load data
data(UN)
#UN<-read.csv('UN.csv')

#view of data structure
head(UN[,1:15])

#split data into three separate parts
UN<-as.matrix(UN)
UN.2<-UN[,-c(1,2)]
UNnames<-UN[,1]
legData<-matrix(UN[,2],length(UN[,2]),1)

#create rollcall-class object
rc<-rollcall(data=UN.2,yea=c(1,2,3),nay=c(4,5,6),missing=c(7,8,9),notInLegis=0,legis.names=UNnames,legis.data=legData,desc="UN Votes",source="voteview.com")

#apply the W-NOMINATE model
result<-wnominate(rcObject=rc,polarity=c(1,1))
summary(result)

#figure of estimates and diagnostics
plot(result)

#output scores
scores<-result$legislators
write.csv(scores,"UNscores.csv")

#create subsets of Warsaw Pact countries versus all others
wp.scores<-subset(scores, V1=="WP")
other.scores<-subset(scores, V1=="Other")

#plot graph of Warsaw Pact scores versus all others
plot(x=other.scores$coord1D, y=other.scores$coord2D, xlab="First Dimension", ylab="Second Dimension", xlim=c(-1,1), ylim=c(-1,1), asp=1)
points(x=wp.scores$coord1D, y=wp.scores$coord2D, pch=3, col='red')
legend(x=-1,y=-.75,legend=c("Other","Warsaw Pact"),col=c("black","red"),pch=c(1,3))
