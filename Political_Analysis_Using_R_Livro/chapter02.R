###CHAPTER 2: LOADING AND MANIPULATING DATA###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

##REQUIRED DATA FILES: hmnrghts.txt, sen113kh.ord, hmnrghts.dta, pts1994.csv, pts1995.csv

#clean up
rm(list=ls())

##SECTION 2.1: READING IN DATA##
#load human rights data in space-separated format, three methods: web, local file, and file browser
#hmnrghts<-read.table("http://j.mp/PTK1999", header=TRUE, na="NA")
hmnrghts<-read.table("hmnrghts.txt", header=TRUE, na="NA")
#hmnrghts<-read.table(file.choose(),header=TRUE,na="NA")

#example of fixed-width data loading: 113th U.S. Senate roll calls
senate.113<-read.fwf('sen113kh.ord', widths=c(3,5,2,2,8,3,1,1,11,rep(1,657)))

#format Senate roll call data
colnames(senate.113)[1:9]<-c('congress','icpsr','state.code', 'cd','state.name','party','occupancy','attaining','name')
for(i in 1:657){colnames(senate.113)[i+9]<-paste('RC',i,sep='')}

#SECTION 2.1.1: READING DATA FROM OTHER PROGRAMS#
#load human rights data in Stata format
library(foreign)
#hmnrghts.2 <- read.dta("http://j.mp/PTKstata")
#setwd("C:/temp/")
hmnrghts.2 <- read.dta("hmnrghts.dta")

#SECTION 2.1.2: DATA FRAMES IN R#
#print the countries variable
hmnrghts$country

#practice using a variable with attached data, detach immediately
attach(hmnrghts)
country
detach(hmnrghts)

#SECTION 2.1.3: WRITING OUT DATA#
#create a simple matrix
x <- matrix(1:24, nrow=4)

#write into CSV format
write.csv(x, file="sample.csv")

#write into space-delimited format
write.table(x, file="sample.txt")

#write into Stata format
write.dta(as.data.frame(x), file="sample.dta")

#find the working directory
getwd()

##SECTION 2.2: VIEWING ATTRIBUTES OF THE DATA##
#print all of the data
hmnrghts

#print the top of the data
head(hmnrghts)

#get the variable names
names(hmnrghts)

#view a spreadsheet
fix(hmnrghts)

#another way to view a spreadsheet
View(hmnrghts)

#descriptive statistics for full dataset
summary(hmnrghts)

#descriptive statistics for log of population
summary(hmnrghts$lpop)

##SECTION 2.3: LOGICAL STATEMENTS AND VARIABLE GENERATION##
#create indicator for more democratic societies in a civil war
hmnrghts$dem.civ <- as.numeric(hmnrghts$civ_war==1 & hmnrghts$democ>5.3)

#view the frequency of values on this indicator
table(hmnrghts$dem.civ)

#view which countries fit both criteria
hmnrghts$country[hmnrghts$dem.civ==1]

#How many values of democracy are missing?
table(is.na(hmnrghts$democ))

#Is our dataset saved as a matrix?
is.matrix(hmnrghts)

#Is our dataset saved as a data frame?
is.data.frame(hmnrghts)

##SECTION 2.4: CLEANING DATA##
#listwise deletion of any observation missing any variable
hmnrghts.trim <- na.omit(hmnrghts)

#recode missing values of democracy as -9999
hmnrghts$democ[is.na(hmnrghts$democ)]<- -9999

#SECTION 2.4.1: SUBSETTING DATA#
#subset to countries with a democracy score of 6-10
dem.rights <- subset(hmnrghts, subset=democ>5)

#subset to country, democracy, and wealth as only variables
dem.wealth<-subset(hmnrghts,select=c(country, democ, gnpcats))

#subset to all variables except the war indicators
no.war <- subset(hmnrghts,select=-c(civ_war,int_war))

#SECTION 2.4.2: RECODING VARIABLES#
#convert logged population to raw population
hmnrghts$pop <- exp(hmnrghts$lpop)

#ordinal variable of how many types of wars a country is involved in
hmnrghts$war.ord<-hmnrghts$civ_war+hmnrghts$int_war

#create numeric ordinal scale of national wealth in six lines
hmnrghts$gnp.ord <- NA
hmnrghts$gnp.ord[hmnrghts$gnpcats=="<1000"]<-1
hmnrghts$gnp.ord[hmnrghts$gnpcats=="1000-1999"]<-2
hmnrghts$gnp.ord[hmnrghts$gnpcats=="2000-2999"]<-3
hmnrghts$gnp.ord[hmnrghts$gnpcats=="3000-3999"]<-4
hmnrghts$gnp.ord[hmnrghts$gnpcats==">4000"]<-5

#install and load the "car" package
#install.packages("car")
library(car)

#create numeric ordinal scale of national wealth with recode command (car package)
hmnrghts$gnp.ord.2<-recode(hmnrghts$gnpcats,'"<1000"=1;"1000-1999"=2;"2000-2999"=3;"3000-3999"=4;">4000"=5')

#indicator of highest level of wealth
hmnrghts$gnp.dummy<-as.numeric(hmnrghts$gnpcats==">4000")

#designate country as a factor
hmnrghts$country <- as.factor(hmnrghts$country)

#observe the levels of country
levels(hmnrghts$country)

#change the reference category for country, observe levels again
hmnrghts$country<-relevel(hmnrghts$country,"united states")
levels(hmnrghts$country)

##SECTION 2.5: MERGING AND RESHAPING DATA##
#load 1994 and 1995 data in CSV format
#hmnrghts.94<-read.csv("http://j.mp/PTS1994")
#hmnrghts.95<-read.csv("http://j.mp/PTS1995")
hmnrghts.94<-read.csv("pts1994.csv")
hmnrghts.95<-read.csv("pts1995.csv")

#view the top of each data set
head(hmnrghts.94)
head(hmnrghts.95)

#subset 1995 data to necessary variables only
hmnrghts.95<-subset(hmnrghts.95,select=c(COW,Amnesty.1995,StateDept.1995))

#merge 1994 and 1995 data
hmnrghts.wide<-merge(x=hmnrghts.94,y=hmnrghts.95,by=c("COW"))

#view merged data
head(hmnrghts.wide)

#number of observations and variables of 1994, 1995, and merged data
dim(hmnrghts.94); dim(hmnrghts.95); dim(hmnrghts.wide)

#reshape merged data into long format
hmnrghts.long<-reshape(hmnrghts.wide,varying=c("Amnesty.1994","StateDept.1994","Amnesty.1995","StateDept.1995"),timevar="year",idvar="COW",direction="long",sep=".")

#view the top of the long data, then the first few 1995 observations
head(hmnrghts.long)
head(hmnrghts.long[hmnrghts.long$year==1995,])

#reshape long data into wide form
hmnrghts.wide.2<-reshape(hmnrghts.long,v.names=c("Amnesty","StateDept"),timevar="year",idvar="COW",direction="wide",sep=".")

#view top of new wide data
head(hmnrghts.wide.2)