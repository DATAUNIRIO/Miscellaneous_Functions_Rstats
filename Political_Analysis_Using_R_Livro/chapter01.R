###CHAPTER 1: OBTAINING R AND DOWNLOADING PACKAGES###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

#clean up
rm(list=ls())

##SECTION 1.2: GETTING STARTED: A FIRST SESSION IN R##
#arithmetic commands
(3+5/78)^3*7
89%%13
89%/%13

#increase the number of digits
options(digits=16)

#geometric constant pi
pi

#trigonometry example
sin(pi/2)

##SECTION 1.3: SAVING INPUT AND OUTPUT##
#check working directory
getwd()

#set working directory (may need to change for your own purposes)
#PC example
setwd("C:/temp/")
#Mac example
setwd("/Volumes/flashdisk/temp")

#create an output file
sink("Rintro.txt")
#alternate code
#sink("C:/myproject/code/Rintro.txt")

#print a line of output into our output file
print("The mean of variable x is...")

#simulate 1000 draws from a standard normal distribution
x <- rnorm(1000)

#print the mean of our 1000 draws to our output
cat("The mean of variable x is...", mean(x), "\n")

#close output file
sink()

##SECTION 1.4: WORK SESSION MANAGEMENT##
#check objects in memory
objects()

#list objects in memory another way
ls()

#remove everything in memory
rm(list=ls(all=TRUE))

#when ready to quit, type the following
#q()

#install the MCMCpack package (only need to run once)
install.packages("MCMCpack")

#load the MCMCpack library
library(MCMCpack)