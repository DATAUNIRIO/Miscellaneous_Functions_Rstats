###CHAPTER 11: ADDITIONAL PROGRAMMING TOOLS###
###POLITICAL ANALYSIS USING R, BY JAMIE MONOGAN###

#clean up
rm(list=ls())

##SECTION 11.1: PROBABILITY DISTRIBUTIONS##
#standard normal cumulative distribution function
pnorm(1.645)

#random draw from standard normal
a <- rnorm(1)
a

#10 draws from a chi-squared distribution with 4 degrees of freedom
c <- rchisq(10,df=4)
c

#quantile function for a chi-squared distribution with 4 degrees of freedom
qchisq(.9,df=4)

#probability mass function for a Poisson distribution with intensity parameter 9
dpois(5,lambda=9)

#probability density function for a normal distribution with mean 4 and standard deviation 2
dnorm(1,mean=4,sd=2)

##SECTION 11.2: FUNCTIONS##
#define a simple function where y depends on x
first.fun<-function(x){
     y<-2+x^{-2}
     return(y)
     }

#return values of y given values of x
first.fun(1)
first.fun(3)

#graph the function given a range of values of x from -4 to 4
my.x<-seq(-4,4,by=.01)
plot(y=first.fun(my.x),x=my.x,type='l',xlab="x",ylab="y",ylim=c(0,10))

#define a more complicated function based on Equation 11.1
Quadratic.A<-function(m.1,m.2,p,delta,theta.A,theta.D){
    util.a<-plogis(-(m.1-theta.A)^2+(m.1-theta.D)^2+p)+delta*plogis(-(m.2-theta.A)^2+(m.2-theta.D)^2)
    return(util.a)
    }
    
#determine utility value given parameter values
Quadratic.A(m.1=.7,m.2=-.1,p=.1,delta=0,theta.A=.7,theta.D=.7)

#graph the utility function manipulating values of theta.Aj
positions<-seq(-1,1,.01)
util.A<-Quadratic.A(m.1=.7,m.2=-.1,p=.1,delta=0,theta.A=positions,theta.D=.7)
plot(x=positions,y=util.A,type='l',xlab="Party A's Position",ylab="Utility")

##SECTION 11.3: LOOPS##
#set random seed for reproducibility of experiment
set.seed(271828183)

#set a storage vector to store results from each trial
store <- matrix(NA,1000,1)

#create a loop in which samples from the standard normal are drawn and then the average is reported
for (i in 1:1000){
     a <- rnorm(i)
     store[i] <- mean(a)
     }
     
#plot the output to illustrate the law of large numbers     
plot(store, type="h",ylab="Sample Mean",xlab="Number of Observations")
abline(h=0,col='red',lwd=2)

##SECTION 11.4: BRANCHING##
#HOW OFTEN ARE TWO DRAWS FROM 1 TO 10 BOTH EVEN?
#initialize counter at zero
even.count<-0

#create a loop simulating 100 trials, include a branch that adds to the counter when statement is true
for (i in 1:100){
     a<-sample(c(1:10),2,replace=TRUE)
     if (sum(a%%2)==0){
          even.count<-even.count+1
          }
}

#view results     	
even.count

#HOW OFTEN ARE BOTH DRAWS EVEN, BOTH ODD, OR A SPLIT?
#initialize all three counters at zero
even.count<-0
odd.count<-0
split.count<-0

#create a loop simulating 100 trials, create three branches based on if...else statements
for (i in 1:100){
     a<-sample(c(1:10),2,replace=TRUE)
     if (sum(a%%2)==0){
          even.count<-even.count+1
          } else if (sum(a%%2)==2){
               odd.count<-odd.count+1
                    } else{
                         split.count<-split.count+1
                         }
}     	

#view results
even.count
odd.count
split.count

##SECTION 11.5: OPTIMIZATION AND MAXIMUM LIKELIHOOD ESTIMATION##
#define log-likelihood function
binomial.loglikelihood <- function(prob, y, n) {
   loglikelihood <- y*log(prob) + (n-y)*log(1-prob)
   return(loglikelihood)
}

#find the maximum likelihood estimate using 'optim'
test <- optim(c(.5),            # starting value for prob
   binomial.loglikelihood,      # the log-likelihood function
   method="BFGS",               # optimization method
   hessian=TRUE,                # return numerical Hessian
   control=list(fnscale=-1),    # maximize instead of minimize
   y=43, n=100)                 # the data
print(test)

#standard error of probability parameter
sqrt(diag(solve(-test$hessian)))

#plot the log-likelihood function against possible values of the probability parameter
ruler <- seq(0,1,0.01)
loglikelihood <- binomial.loglikelihood(ruler, y=43, n=100)
plot(ruler, loglikelihood, type="l", lwd=2, col="blue",xlab=expression(pi),ylab="Log-Likelihood",ylim=c(-300,-70),main="Log-Likelihood for Binomial Model")
abline(v=.43)

##SECTION 11.6: OBJECT-ORIENTED PROGRAMMING##
#SECTION 11.6.1: SIMULATING A GAME#
#clean up
rm(list=ls())

#define utility functions
Quadratic.A<-function(m.1,m.2,p,delta,theta.A,theta.D){
    util.a<-plogis(-(m.1-theta.A)^2+(m.1-theta.D)^2+p)+delta*plogis(-(m.2-theta.A)^2+(m.2-theta.D)^2)
    return(util.a)
    }
Quadratic.D<-function(m.1,m.2,p,delta,theta.A,theta.D){
    util.d<-(1-plogis(-(m.1-theta.A)^2+(m.1-theta.D)^2+p))+delta*(1-plogis(-(m.2-theta.A)^2+(m.2-theta.D)^2))
    return(util.d)
    }

#define "simulate" command that runs a simulation
simulate<-function(v,delta,m.2,m.1=0.7,theta=seq(-1,1,.1)){
     
    #define internal parameters, matrices, and vectors
    precision<-length(theta)
    outcomeA<-matrix(NA,precision,precision)
    outcomeD<-matrix(NA,precision,precision)
    bestResponseA<-rep(NA,precision) 
    bestResponseD<-rep(NA,precision)
    equilibriumA<- 'NA'
    equilibriumD<- 'NA'

    #matrix attributes
    rownames(outcomeA)<-colnames(outcomeA)<-rownames(outcomeD)<-
         colnames(outcomeD)<-names(bestResponseA)<-
         names(bestResponseD)<-theta

    #fill-in the utilities for all strategies for party A
    for (i in 1:precision){
            for (j in 1:precision){
                outcomeA[i,j]<-Quadratic.A(m.1,m.2,v,delta,
                     theta[i],theta[j])
                }
        }

    #utilities for party D
    for (i in 1:precision){
            for (j in 1:precision){
                outcomeD[i,j]<-Quadratic.D(m.1,m.2,v,delta,
                     theta[i],theta[j])
                }
        }

    #best responses for party A
    for (i in 1:precision){
        bestResponseA[i]<-which.max(outcomeA[,i])
        }

    #best responses for party D
    for (i in 1:precision){
        bestResponseD[i]<-which.max(outcomeD[i,])
        }

    #find the equilibria
    for (i in 1:precision){
        if (bestResponseD[bestResponseA[i]]==i){
            equilibriumA<-dimnames(outcomeA)[[1]][
                 bestResponseA[i]]
            equilibriumD<-dimnames(outcomeD)[[2]][
                 bestResponseD[bestResponseA[i]]]                  
                }
    }

    #save the output
    result<-list(outcomeA=outcomeA,outcomeD=outcomeD, 
        bestResponseA=bestResponseA,bestResponseD=bestResponseD,
        equilibriumA=equilibriumA,equilibriumD=equilibriumD)
    class(result)<-'game.simulation'
    invisible(result)
}

#run a simulation when the second election does not matter
treatment.1<-simulate(v=0.1,delta=0.0,m.2=-0.1)
treatment.1

#equilibirum from treatment 1
treatment.1$equilibriumA
treatment.1$equilibriumD

#run a simulation when the second election is worth one tenth of the first, add extra precision to party positions
treatment.2<-simulate(v=0.1,delta=0.1,m.2=-0.1,theta=seq(-1,1,.01))

#equilibrium
treatment.2$equilibriumA
treatment.2$equilibriumD

##SECTION 11.7: MONTE CARLO ANALYSIS: AN APPLIED EXAMPLE##
#SECTION 11.7.1: STRATEGIC DETERRENCE LOG-LIKELIHOOD FUNCTION#
#clean up
rm(list=ls())

#define log-likelihood function
llik=function(B,X,Y) {
  #Separate data matrices to individual variables:
  sq=as.matrix(Y[,1])             
  cap=as.matrix(Y[,2])
  war=as.matrix(Y[,3])
  X13=as.matrix(X[,1])
  X14=as.matrix(X[,2])
  X24=as.matrix(X[,3:4])
  
  #Separate coefficients for each equation:
  B13=as.matrix(B[1])
  B14=as.matrix(B[2])
  B24=as.matrix(B[3:4])
  
  #Define utilities as variables times coefficients:
  U13=X13 %*% B13
  U14=X14 %*% B14
  U24=X24 %*% B24
  
  #Compute probability 2 will fight (P4) or not (P3):
  P4=pnorm(U24)                 
  P3=1-P4                               
  
  #Compute probability 1 will attack (P2) or not (P1):
  P2=pnorm((P3*U13+P4*U14))     
  P1=1-P2                               
  
  #Define and return log-likelihood function:
  lnpsq=log(P1)
  lnpcap=log(P2*P3)
  lnpwar=log(P2*P4)
  llik=sq*lnpsq+cap*lnpcap+war*lnpwar   
  return(sum(llik))
}

#SECTION 11.7.2: EVALUATING THE ESTIMATOR#
#set the random seed for reproducibility
set.seed(3141593)

#define number of experiments and cases per experiment
i<-100     #number of experiments
n<-1000    #number of cases per experiment
#n<-5000    #second treatment for number of cases per experiment

#set up matrices for outputs of each experiment
beta.qre<-matrix(NA,i,4)
stder.qre<-matrix(NA,i,4)

#create a loop to simulate data according to the populationmodel described and estimate the model over each sample
for(j in 1:i){
     #Simulate Causal Variables
     x1<-rnorm(n)
     x2<-rnorm(n)
     x3<-rnorm(n)
     x4<-rnorm(n)

     #Create Utilities and Error Terms
     u11<-rnorm(n,sd=sqrt(.5))
     u13<-x1
     u23<-rnorm(n,sd=sqrt(.5))
     u14<-x2
     u24<-x3+x4+rnorm(n,sd=sqrt(.5))
     pR<-pnorm(x3+x4)
     uA<-(pR*u14)+((1-pR)*u13)+rnorm(n,sd=sqrt(.5))

     #Create Dependent Variables
     sq<-rep(0,n)
     capit<-rep(0,n)
     war<-rep(0,n)
     sq[u11>=uA]<-1
     capit[u11<uA & u23>=u24]<-1
     war[u11<uA & u23<u24]<-1
     Nsq<-abs(1-sq)

     #Matrices for Input
     stval<-rep(.1,4)                         
     depvar<-cbind(sq,capit,war)              
     indvar<-cbind(x1,x2,x3,x4)        

     #Fit Model
     strat.mle<-optim(stval,llik,hessian=TRUE,method="BFGS",
          control=list(maxit=2000,fnscale=-1,trace=1),
          X=indvar,Y=depvar)

     #Save Results
     beta.qre[j,]<-strat.mle$par
     stder.qre[j,]<-sqrt(diag(solve(-strat.mle$hessian)))
}

#quick view of average coefficients (population values all set to 1)
apply(beta.qre,2,mean)

#compute level of bias in estimates
deviate <- sweep(beta.qre, 2, c(1,1,1,1))
colMeans(deviate) 

#compute mean absolute errors in estimates
colMeans(abs(deviate)) 

##END OF CHAPTER##



##ALTERNATIVE CODE FOR SECTION 11.6: USING THE S4 OBJECT FAMILY TO ACCOMPLISH THE SAME GOAL##
#clean up
rm(list=ls())

#define utility functions
Quadratic.A<-function(m.1,m.2,p,delta,theta.A,theta.D){
    util.a<-plogis(-(m.1-theta.A)^2+(m.1-theta.D)^2+p)+delta*plogis(-(m.2-theta.A)^2+(m.2-theta.D)^2)
    return(util.a)
    }
Quadratic.D<-function(m.1,m.2,p,delta,theta.A,theta.D){
    util.d<-(1-plogis(-(m.1-theta.A)^2+(m.1-theta.D)^2+p))+delta*(1-plogis(-(m.2-theta.A)^2+(m.2-theta.D)^2))
    return(util.d)
    }

#define class within the S4 object system
setClass("simulation", representation(outcomeA="matrix", outcomeD="matrix", bestResponseA="numeric", bestResponseD="numeric", equilibriumA="character", equilibriumD="character"))

#define "simulate" command that runs a simulation
simulate<-function(v,delta,m.2,m.1=0.7,theta=seq(-1,1,.1)){
     
    #define internal parameters, matrices, and vectors
    precision<-length(theta)
    outcomeA<-matrix(NA,precision,precision)
    outcomeD<-matrix(NA,precision,precision)
    bestResponseA<-rep(NA,precision) 
    bestResponseD<-rep(NA,precision)
    equilibriumA<- 'NA'
    equilibriumD<- 'NA'

    #matrix attributes
    rownames(outcomeA)<-colnames(outcomeA)<-rownames(outcomeD)<-
         colnames(outcomeD)<-names(bestResponseA)<-
         names(bestResponseD)<-theta

    #fill-in the utilities for all strategies for party A
    for (i in 1:precision){
            for (j in 1:precision){
                outcomeA[i,j]<-Quadratic.A(m.1,m.2,v,delta,
                     theta[i],theta[j])
                }
        }

    #utilities for party D
    for (i in 1:precision){
            for (j in 1:precision){
                outcomeD[i,j]<-Quadratic.D(m.1,m.2,v,delta,
                     theta[i],theta[j])
                }
        }

    #best responses for party A
    for (i in 1:precision){
        bestResponseA[i]<-which.max(outcomeA[,i])
        }

    #best responses for party D
    for (i in 1:precision){
        bestResponseD[i]<-which.max(outcomeD[i,])
        }

    #find the equilibria
    for (i in 1:precision){
        if (bestResponseD[bestResponseA[i]]==i){
            equilibriumA<-dimnames(outcomeA)[[1]][
                 bestResponseA[i]]
            equilibriumD<-dimnames(outcomeD)[[2]][
                 bestResponseD[bestResponseA[i]]]                  
                }
    }

    #save the output as the S4-type object
	result<-new("simulation",outcomeA=outcomeA, outcomeD=outcomeD,
		bestResponseA=bestResponseA, bestResponseD=bestResponseD, equilibriumA=equilibriumA, equilibriumD=equilibriumD)    
    invisible(result)
}

#run a simulation when the second election does not matter
treatment.1<-simulate(v=0.1,delta=0.0,m.2=-0.1)
treatment.1

#equilibirum from treatment 1
treatment.1@equilibriumA
treatment.1@equilibriumD

#run a simulation when the second election is worth one tenth of the first, add extra precision to party positions
treatment.2<-simulate(v=0.1,delta=0.1,m.2=-0.1,theta=seq(-1,1,.01))

#equilibrium
treatment.2@equilibriumA
treatment.2@equilibriumD




