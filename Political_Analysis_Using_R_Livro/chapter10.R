###CHAPTER 10: LINEAR ALGEBRA WITH PROGRAMMING APPLICATIONS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

#clean up
rm(list=ls())

##SECTION 10.1: CREATING VECTORS AND MATRICES##
#simple vector of length three
a <- c(3,4,5)
a

#data of interest: 2010 GOP vote share, 2008 Obama vote share, and GOP financial advantage
Y<-c(.808,.817,.568,.571,.421,.673,.724,.590,.251)
X2<-c(.29,.34,.37,.34,.56,.37,.34,.43,.77)
X3<-c(4.984,5.073,12.620,-6.443,-5.758,15.603,14.148,0.502,-9.048)

#check length of all vectors
length(Y); length(X2); length(X3)

#view each vector
Y
X2
X3

#create a vector of a constant
X1 <- rep(1, 9)
X1

#create index vector
index <- c(1:9)
index

#create a vector with an incremental sequence
e <- seq(-2, 1, by=0.25)
e

#SECTION 10.1.1: CREATING MATRICES#
#create a matrix filled with a constant
b <- matrix(3, ncol=4, nrow=4, byrow=FALSE)
b

#create a matrix by treating several vectors as columns
X<-cbind(1,X2,X3)
X

#create a matrix by treating several vectors as rows
T<-rbind(1,X2,X3)
T

#create a blank matrix
blank <- matrix(NA, ncol=3, nrow=3)

#fill in values of the blank matrix piecewise
blank[1,3] <- 8
blank[2,1] <- pi
blank[,2] <- a

#check our progress
blank

#create a matrix by listing all element, filling column-by-column
W <- matrix(c(1,2,3,4), ncol=2, nrow=2)
W

#create a matrix by listing all element, filling row-by-row
Z <- matrix(c(1,2,3,4), ncol=2, nrow=2, byrow=TRUE)
Z

#create a matrix with random draws from a normal distribution
N <- matrix(rnorm(100, mean=10, sd=2), nrow=10, ncol=10)
N

#create a diagonal matrix
D <- diag(c(1:4))
D

#SECTION 10.1.2: CONVERTING MATRICES AND DATA FRAMES#
#convert predictor matrix into a data frame
X.df <- as.data.frame(X)

#create complete Tennessee data frame using vectors
tennessee <- as.data.frame(cbind(index,Y,X1,X2,X3))

#SECTION 10.1.3: SUBSCRIPTING#
#view an element of a vector
Y[3]

#view a column of a matrix
X[,2]

#use column name to call a matrix column
X[,"X2"]

#view a row of a matrix
X[1,]

#create row names for a matrix
rownames(X)<-c('Dist. 1','Dist. 2','Dist. 3','Dist. 4','Dist. 5','Dist. 6','Dist. 7','Dist. 8','Dist. 9')

#view row and column names of a matrix
rownames(X)
colnames(X)

##SECTION 10.2: VECTOR AND MATRIX COMMANDS##
#length of a vector
length(a)

#dimensions of a matrix
dim(X)

#add the elements of a vector
sum(X2)

#compute the mean of a vector's elements
mean(X2)

#compute the variance of a vector's elements
var(X2)

#set the seed for random number generation
set.seed(271828183)

#create matrix of normal draws, then create a smaller sample from it
N <- matrix(rnorm(100, mean=10, sd=2), nrow=10, ncol=10)
s <- sample(N,10)
s

#use the apply function to compute a statistic for all columns at once
apply(X, 2, mean)

#SECTION 10.2.1: MATRIX ALGEBRA#
#compute the difference of two vectors
m <- Y - X2
m

#create the sum of two vectors (WARNING: this is an example of what R will do when you attempt to add incompatible vectors)
s + X2

#square the entries of a matrix
X.sq <- X^2
X.sq

#element-by-element multiplication for two vectors
x2.x3 <- X2*X3
x2.x3

#inner product of two vectors
x2.x3.inner <- X2%*%X3
x2.x3.inner

#outer product of two vectors
x2.x3.outer <- X2%*%t(X3)
x2.x3.outer

#multiply two matrices
P <- T%*%X
P

#determinant of a matrix
det(P)

#compute inverse of a matrix
invP <- solve(P)
invP

#postmultiply inverse by original matrix
invP%*%P

##SECTION 10.3: APPLIED EXAMPLE: PROGRAMMING OLS REGRESSION##
#SECTION 10.3.2: WRITING AN OLS ESTIMATOR IN R#
#reload data, if not loaded
Y<-c(.808,.817,.568,.571,.421,.673,.724,.590,.251)
X1 <- rep(1, 9)
X2<-c(.29,.34,.37,.34,.56,.37,.34,.43,.77)
X3<-c(4.984,5.073,12.620,-6.443,-5.758,15.603,14.148,0.502,-9.048)
X<-cbind(X1,X2,X3)

#apply formula for OLS estimator
beta.hat<-solve(t(X)%*%X)%*%t(X)%*%Y
beta.hat

#compare programmed results to results from the 'lm' command
tennessee <- as.data.frame(cbind(Y,X2,X3))
lm(Y~X2+X3, data=tennessee)