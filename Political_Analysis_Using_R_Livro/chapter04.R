###CHAPTER 4: DESCRIPTIVE STATISTICS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILE: LL.csv, or open LL from the 'cem' package

#clean up
rm(list=ls())

##SECTION 4.1: MEASURES OF CENTRAL TENDENCY##
#load data via the 'cem' library, install 'cem' once on first use
#install.packages('cem')
library(cem)
data(LL)

#alternate data load
#LL<-read.csv('LL.csv')

#mean of participant income in 1974
mean(LL$re74)

#density plot of participant income in 1974, with vertical line at the mean
dens.74<-density(LL$re74,from=0)
plot(dens.74,main="Income in 1974")
abline(v=mean(LL$re74),col='red')

#median of participant income in 1974
median(LL$re74)

#inter-quartile range of participant income in 1974
summary(LL$re74)
IQR(LL$re74)

#increase number of digits
options(digits=9)

#summary statistics for participant income in 1974
summary(LL$re74)

#summary statistics for all variables in the dataset
summary(LL)

#SECTION 4.1.1: FREQUENCY TABLES#
#table of participant race, 1=African-American, 0 otherwise
table(LL$black)

#table of participant education in years
table(LL$education)

#modal number of years of education
which.max(table(LL$education))

#barplot of frequency of number of years of education
barplot(table(LL$education),xlab="Years of Education",ylab="Frequency",cex.axis=.9,cex.names=.9,ylim=c(0,200))
abline(h=0,col='gray60')
box()

#percent of respondents falling into each category of education
100*table(LL$education)/sum(table(LL$education))

##SECTION 4.2: MEASURES OF DISPERSION##
#variance of participant income in 1974
var(LL$re74)

#standard deviation of participant income in 1974
sd(LL$re74)

#median absolute deviation of participant income in 1974
mad(LL$re74)

#SECTION 4.2.1: QUANTILES AND PERCENTILES#
#quantiles (by default, quartiles) of participant income in 1974
quantile(LL$re74)

#deciles of participant income in 1974
quantile(LL$re74, c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1))

