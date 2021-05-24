

library(naivebayes)
library(dplyr)
library(ggplot2)
library(psych)
# https://finnstats.com/index.php/2021/04/08/naive-bayes-classification-in-r/
data <- read.csv("C:/Users/Hp/Documents/GitHub/Base_de_dados/finnstats/binary-Naive.csv", header = T)
head(data)
#Launch- Response variable, 0 indicates product not launched and 1 indicates product is launched
#Thickness-product thickness score
#Appearance-product appearance score
#Spreading- product spreading score
#Rank-Rank of the product

#Let’s calculate the frequency of response variable under each rank. 
#The minimum frequency of each class is 5 required for analysis.
xtabs(~Launch+Rank, data = data)
str(data)
data$Rank <- as.factor(data$Rank)
data$Launch <- as.factor(data$Launch)
#When we are doing naïve Bayes classification one of the assumptions 
#is to independent variables are not highly correlated. 
#In this case, remove the rank column and test the correlation of the predictor variables.

#Visualization

pairs.panels(data[-1])
#Low correlation was observed between independent variables.


data %>%
  ggplot(aes(x=Launch, y=Thickness, fill = Launch)) +
  geom_boxplot() +theme_bw()+
  ggtitle("Box Plot")
#Product got highest score in the thickness got launched in the market.

data %>%   
  ggplot(aes(x=Launch, y=Appearance, fill = Launch)) +  
  geom_boxplot() +theme_bw()+   
  ggtitle("Box Plot")

data %>%
  ggplot(aes(x=Launch, y=Spreading, fill = Launch)) +
  geom_boxplot() +theme_bw()+
  ggtitle("Box Plot")


#Data Partition
#Let’s create train and test data sets for training the model and testing.
set.seed(1234)
ind <- sample(2, nrow(data), replace = T, prob = c(0.8, 0.2))
train <- data[ind == 1,]
test <- data[ind == 2,]

#Naive Bayes Classification
#Naive Bayes Classification in R

model <- naive_bayes(Launch ~ ., data = train, usekernel = T) 
model 
plot(model) 

#You can try usekernel = T without also, based on model accuracy you can adjust the same.
#Product received rank 1 score launch chances are very high and products received rank 3 also have some chances to a successful launch.

# Prediction
p <- predict(model, train, type = 'prob')
head(cbind(p, train))

#Basis first row, Low thickness, high appearance, Spreading and Rank score 2, has very low chance of product launch.

#Confusion Matrix – train data
p1 <- predict(model, train)
(tab1 <- table(p1, train$Launch))

1 - sum(diag(tab1)) / sum(tab1)
#Misclassification is around 14%.

#Training model accuracy is around 86% not bad!.

#Confusion Matrix – test data

p2 <- predict(model, test)
(tab2 <- table(p2, test$Launch))

1 - sum(diag(tab2)) / sum(tab2)
0.1428571

#Conclusion
#Based on Naive Bayes Classification in R, misclassification is around 14% in test data. You can increase model accuracy in the train test while adding more observations.


