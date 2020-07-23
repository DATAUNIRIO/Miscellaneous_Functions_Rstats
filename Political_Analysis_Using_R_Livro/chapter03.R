###CHAPTER 3: VISUALIZING DATA###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILES: constructionData.dta and PESenergy.csv

#clean up
rm(list=ls())

##SECTION 3.1: UNIVARIATE GRAPHS IN THE base PACKAGE##
#load energy policy coverage data
pres.energy<-read.csv("PESenergy.csv")
#pres.energy<-read.csv("http://j.mp/PRESenergy")

#draw a histogram of TV coverage
hist(pres.energy$Energy,xlab="Television Stories",main="")
abline(h=0,col='gray60')
box()

#box-and-whisker plot of TV coverage
boxplot(pres.energy$Energy,ylab="Television Stories")

#box-and-whisker plots before and after Nixon speech
pres.energy$post.nixon<-c(rep(0,58),rep(1,122))
boxplot(pres.energy$Energy~pres.energy$post.nixon,axes=F,ylab="Television Stories")
axis(1,at=c(1,2),labels=c('Before Nov. 1973','After Nov. 1973'))
axis(2)
box()

#SECTION 3.1.1: BAR GRAPHS#
#load state health lobbying data
library(foreign)
health.fin<-read.dta("constructionData.dta")
#health.fin<-read.dta("http://j.mp/HEALTHfinance")

#create subset of lobbying data of percentage registration by sector
part.rates<-subset(health.fin,select=c(partratetotalhealth,partratedpc,partratepharmprod,partrateprofessionals,partrateadvo,partratebusness,partrategov,rnmedschoolpartrate))

#compute average registration across all states
lobby.means<-apply(part.rates,2,mean)

#label vector of averages
names(lobby.means)<-c('Total Health Care','Direct Patient Care','Drugs/Health Products','Health Professionals','Health Advocacy','Health Finance','Local Government','Health Education')

#draw the bar graph
par(mar=c(5.1, 10 ,4.1 ,2.1))
barplot(lobby.means,xlab='Percent Lobby Registration',xlim=c(0,26),horiz=T,cex.names=.8,las=1)
text(x=lobby.means,y=c(.75,1.75,3,4.25,5.5,6.75,8,9),labels=paste(round(lobby.means,2)),pos=4)
box()

##SECTION 3.2: THE plot FUNCTION##
#view the plot function's arguments
args(plot.default)

#plot participation rate of health finance firms in order recorded
plot(health.fin$partratebusness,ylab="Lobby Participation Rate")

#plot participation rate of health finance firms by number of firms
plot(y=health.fin$partratebusness,x=health.fin$supplybusiness,ylab="Lobby Participation Rate",xlab="Number of Health Establishments")

#estimate linear regression model of health finance participation rate as a linear function of number of firms
finance.linear<-lm(partratebusness~supplybusiness,data=health.fin)
summary(finance.linear)

#estimate linear regression model of health finance participation rate as a quadratic function of number of firms
finance.quadratic<-lm(partratebusness~supplybusiness+I(supplybusiness^2),data=health.fin)
summary(finance.quadratic)

#plot linear relationship within scatterplot
plot(y=health.fin$partratebusness,x=health.fin$supplybusiness,ylab="Lobby Participation Rate",xlab="Number of Health Establishments")
abline(finance.linear)

#plot quadratic relationship within scatterplot
plot(y=health.fin$partratebusness,x=health.fin$supplybusiness,ylab="Lobby Participation Rate",xlab="Number of Health Establishments")
finance.quadratic<-lm(partratebusness~supplybusiness+I(supplybusiness^2), data=health.fin)
health.fin$quad.fit<-finance.quadratic$fitted.values
health.fin<-health.fin[order(health.fin$supplybusiness),]
lines(y=health.fin$quad.fit,x=health.fin$supplybusiness)

#SECTION 3.2.1: LINE GRAPHS WITH plot#
#line plot of energy coverage by month
plot(x=pres.energy$Energy,type="l",axes=F,xlab='Month', ylab='Television Stories on Energy')
axis(1,at=c(1,37,73,109,145),labels=c('Jan. 1969','Jan. 1972','Jan. 1975','Jan. 1978','Jan. 1981'),cex.axis=.7)
axis(2)
abline(h=0,col='gray60')
box()

#alternative version of the line plot of monthly energy coverage
pres.energy$Time<-1:180
plot(y=pres.energy$Energy,x=pres.energy$Time,type="l")

#line plot of oil price per barrel by month
plot(x=pres.energy$oilc,type='l',axes=F,xlab='Month',ylab='Cost of Oil')
axis(1,at=c(1,37,73,109,145),labels=c('Jan. 1969','Jan. 1972','Jan. 1975','Jan. 1978','Jan. 1981'),cex.axis=.7)
axis(2)
box()

##SECTION 3.3: USING lattice GRAPHICS IN R##
#load the lattice library, install on the first use only
#install.packages('lattice')
library(lattice)

#scatterplot of participation rate of health finance firms against number of firms
xyplot(partratebusness~supplybusiness,data=health.fin,col="black",ylab="Lobby Participation Rate",xlab="Number of Health Establishments")

#dotplot of participation rate of health finance firms against number of firms
dotplot(partratebusness~supplybusiness,data=health.fin,col='black',ylab="Lobby Participation Rate (Rank Order)",xlab="Number of Health Establishments")

#density plot of TV coverage of energy policy
densityplot(~Energy,data=pres.energy,xlab="Television Stories",col="black")

#histogram of TV coverage of energy policy
histogram(~Energy, data=pres.energy,xlab="Television Stories", col="gray60")

#histogram of TV coverage pre and post Nixon speech
histogram(~Energy|post.nixon,data=pres.energy)

##SECTION 3.4: GRAPHIC OUTPUT##
#write out scatterplot of business lobbying from "base" package in a postscript file
postscript("lin.partrate.eps",horizontal=FALSE,width=3,height=3,onefile=FALSE,paper='special',pointsize=7)
plot(y=health.fin$partratebusness,x=health.fin$supplybusiness,ylab="Lobby Participation Rate",xlab="Number of Health Establishments")
abline(finance.linear)
dev.off()

#write out dotplot of business lobbying from "lattice" package in a postscript file
trellis.device("postscript",file="dotplot.partrate.eps",theme=list(fontsize=list(text=7,points=7)),horizontal=FALSE,width=3,height=3,onefile=FALSE,paper='special')
dotplot(partratebusness~supplybusiness,data=health.fin,col='black',ylab="Lobby Participation Rate (Rank Order)",xlab="Number of Health Establishments")
dev.off()
