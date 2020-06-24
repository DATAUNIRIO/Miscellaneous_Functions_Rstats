library(odr)

# unconstrained optimal design
myod1 <- od.2(icc = 0.2, r12 = 0.5, r22 = 0.5, c1 = 1, c2 = 5, c1t = 1, c2t = 50, 
              varlim = c(0.01, 0.02))

## The optimal level-1 sample size per level-2 unit (n) is 8.878572.
## The optimal proportion of level-2 units in treatment (p) is 0.326828.

# constrained optimal design with p = 0.5
myod3 <- od.2(icc = 0.2, r12 = 0.5, r22 = 0.5, c1 = 1, c2 = 5, c1t = 1, c2t = 50, 
              p = 0.5, varlim = c(0.005, 0.020))