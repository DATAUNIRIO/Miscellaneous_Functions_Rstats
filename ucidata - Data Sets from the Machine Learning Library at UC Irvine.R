#ucidata - Data Sets from UC the Machine Learning Library at UC Irvine. 
#The following is an R data package that features certain data sets from the Machine Learning Library at UC Irvine. 

# devtools::install_github("coatless/ucidata")

library(ucidata)

# See the first 10 observations of the `autompg` dataset
head(autompg)

# Loading `autompg` without a `library(ucidata)` call
data("autompg", package = "ucidata")

# See the first 10 observations of the `autompg` dataset
head(autompg)

#Included Data Sets
#abalone
# adult
# autoimports
# autompg
# Breast Cancer Wisconsin:
# bcw_original (Breast Cancer Wisconsin Original)
# Heart Disease
# heart_disease_cl
# heart_disease_hu
# heart_disease_va
# heart_disease_ch
# bike_sharing_daily
# bridges
# car_eval
# forest_fires
# glass
# hepatitis
# wine
