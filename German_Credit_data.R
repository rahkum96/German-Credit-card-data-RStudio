##############################################################################
############################################################################
##############################Classification case study##########################

#step1...... load the data
ger_credit<- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\Data_practice\\logistic_regression\\German_Credit_data.csv", na.strings = c(""," ","NA","NULL") )

head(ger_credit,10)
dim(ger_credit)
str(ger_credit)
class(ger_credit)
names(ger_credit)
summary(ger_credit)
tail(ger_credit)

#step-2
#lets see how many feature we have convert to factor
lapply(ger_credit,function(x)length(unique(x)))

##Status_of_existing_account--->#4 unique values and also it can help to predict.

##Duration_of_Credit_month--->It will also help , to see whether the duration of month is very much shorter or longer.

##Payment_Status_of_Previous_Credit.Credit_history.--->5 , what is their status of payment can help to predict.

##Purpose_of_loan--->As here too many unique labels and also it can't help

##"Credit_Amount","Value_of_Savings_account.bonds","Years_of_Present_Employment","Percentage_of_disposable_income","Sex_._Marital_Status",                            
##"Guarantors.Debtors","Duration_in_Present_Residence","Property","Age_in_years","Concurrent_Credits","Housing",
##"No_of_Credits_at_this__Bank","Occupation","No_of_dependents","Telephone" ,"Foreign_Worker"
## As we don't have proper definition of all the variable so lets explore on the basis of statistical test

#"Creditability"---> will check the customer is trustworthiness or not #Factor#2


#Purpose_of_loan- it is not usefull for us. useless column and factor label is 10
ger_credit$Purpose_of_loan<-NULL
head(ger_credit)
str(ger_credit)


###check if all the categorical variables are factor or not
#by using loop we will convert to factor 
cols<-c("Creditability","Status_of_existing_account","Payment_Status_of_Previous_Credit.Credit_history.",
        "Value_of_Savings_account.bonds","Years_of_Present_Employment",
        "Percentage_of_disposable_income","Sex_._Marital_Status","Guarantors.Debtors",
        "Duration_in_Present_Residence","Property","Concurrent_Credits","Housing",
        "No_of_Credits_at_this__Bank","Occupation","No_of_dependents", "Telephone","Foreign_Worker")
for (i in cols){
  ger_credit[,i]<-as.factor(ger_credit[,i])
}

str(ger_credit)


#step3....... data pre-processing

#check missing values
colSums(is.na(ger_credit))
colSums(ger_credit=="")


#Step-4..........Data visualization
#Explore each "Potential" predictor for distribution and Quality

#for continuous variables we will plot it by histogram graph
#for categorical variables  we will plot it by bar graph

# Exploring MULTIPLE CONTINUOUS features
hist_con<- c("Duration_of_Credit_month","Credit_Amount","Age_in_years")

#splitting the plot window into 2 parts
par(mfrow=c(2,3))

# library to generate professional colors
library(RColorBrewer) 

# looping to create the histograms for each column
for(i in hist_con){
  hist(ger_credit[,c(i)],main=paste('Histogram of:',i),
       col = brewer.pal(8,"Paired"))
}

############################################################
# Exploring MULTIPLE CATEGORICAL features
bar_cols<- c("Creditability","Status_of_existing_account","Payment_Status_of_Previous_Credit.Credit_history.",
             "Value_of_Savings_account.bonds","Years_of_Present_Employment",
             "Percentage_of_disposable_income","Sex_._Marital_Status","Guarantors.Debtors",
             "Duration_in_Present_Residence","Property","Concurrent_Credits","Housing",
             "No_of_Credits_at_this__Bank","Occupation","No_of_dependents", "Telephone","Foreign_Worker")

#Splitting the plot window into four parts
par=(mfrow=c(3,9))


# looping to create the Bar-Plots for each column
for(i in bar_cols){
  barplot(table(ger_credit[,c(i)]),main=paste("Barplot of:",i),
                col=brewer.pal(8,"Paired"))
}

#Step-5

############################################################# 
# Statistical Relationship between target variable (Categorical) and predictors

# now we will check the relationship strength:
#contentious vs continuous-------> correlation test
#categorical vs contentious-------> ANOVA test
#categorical vs categorical-------> Chi-square test

# Continuous Vs Categorical relationship strength: ANOVA
# Analysis of Variance(ANOVA)
# H0: Variables are NOT correlated
# Small P-Value <5%--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)

summary(aov(Duration_of_Credit_month~Creditability,data = ger_credit))
summary(aov(Credit_Amount~Creditability,data = ger_credit))
summary(aov(Age_in_years~Creditability,data = ger_credit))

#All these variables are good

#### Categorical Vs Categorical relationship strength: Chi-Square test
# H0: Variables are NOT correlated
# Small P-Value--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)

##It takes crosstabulation as the input and gives you the result

chisq_cols<-c("Creditability","Status_of_existing_account","Payment_Status_of_Previous_Credit.Credit_history.",
              "Value_of_Savings_account.bonds","Years_of_Present_Employment",
              "Percentage_of_disposable_income","Sex_._Marital_Status","Guarantors.Debtors",
              "Duration_in_Present_Residence","Property","Concurrent_Credits","Housing",
              "No_of_Credits_at_this__Bank","Occupation","No_of_dependents", "Telephone","Foreign_Worker")
for(i in Chisqcols){
  CrossTabResult=table(ger_credit[,c('Creditability',i)])
  ChiResult=chisq.test(CrossTabResult)
  print(i)
  print(ChiResult)
}
#we will reject the columns
#c("Sex_._Marital_Status","Guarantors.Debtors","Occupation","Telephone","Foreign_Worker")

ger_credit[,c("Sex_._Marital_Status","Guarantors.Debtors","Occupation","Telephone","Foreign_Worker")]<- list(NULL)
str(ger_credit)
class(ger_credit)


###############################################################################
############## Checking for balance data or not ###############################

table(ger_credit$Creditability)/nrow(ger_credit)

library(ggplot2)
barplot<- ggplot(ger_credit,aes(ger_credit$Creditability, fill=I("red")))+ geom_bar()
barplot

# we could say that 30% data are negative case and 70%- are positive case
#so we conclude that this balance data;




###############################################################################
##############################split the data into training and testing########

#library for splitting the train and test data
library(caTools)

#it will fixed the training data
set.seed(123)

# Sampling | Splitting data into 70% for training 30% for testing
split<- sample.split(ger_credit$Creditability,SplitRatio = 0.8)
split
table(split)

training<- subset(ger_credit,split==T)
test<- subset(ger_credit,split==F)

nrow(training)
nrow(test)

#############################################################################################
#############################################################################################
# Creating Predictive models on training data to check the accuracy on test data
###### Logistic Regression #######

##we are predicting TV based on all other variables
##glm() is used for wide variety of modeling activities. Logistic regression
#is one of the models that you can create using glm()
##in order to tell glm() that you have to perform logistic regression,
#you have to say family= 'binomial"


lg_model<- glm(Creditability~.,data = training,family = "binomial")
summary(lg_model)

#For better model we reduce the value of AIC: 823.52, we will use step function;

step(lg_model)

lg_model1<- glm(formula = Creditability ~ Status_of_existing_account + Payment_Status_of_Previous_Credit.Credit_history. + 
                  Credit_Amount + Value_of_Savings_account.bonds + Years_of_Present_Employment + 
                  Percentage_of_disposable_income + Property + Housing + No_of_Credits_at_this__Bank, 
                family = "binomial", data = training)

summary(lg_model1)


#Null deviance: 977.38  on 799  degrees of freedom
#Residual deviance: 773.16  on 777  degrees of freedom
#AIC: 819.16

#For the better model we have to check
#1. Residual deviance should less than Null deviance
#2. AIC: 819.16 should be minimum

###############################################################################


# Checking Accuracy of model on Testing data
pred<- predict(lg_model1,newdata = test,type = 'response')
pred

##considering a threshold of 0.50
pred_thres_50<-ifelse(pred>=0.5,1,0)
pred_thres_50

# Now we have create confusion matrix table
cm<-table(test$Creditability,pred_thres_50) 
cm

# Creating the Confusion Matrix to calculate overall accuracy, precision and recall on TESTING data
##install.packages('caret', dependencies = TRUE)
library(caret)

confusionMatrix(cm)

#Now you can see that model is around 73.5% and based on 95% confidence interval 
#accuracy is lies between 66 & to 79%.


#############################################################################
###############################################################################
########### Checking the variance of the data ###############################


pred_train<- predict(lg_model1,newdata = training,type = 'response')
pred_train

##considering a threshold of 0.50
pred_train<-ifelse(pred_train>=0.5,1,0)
pred_train

# Now we have create confusion matrix table
cm_train<-table(training$Creditability,pred_train) 

length(training$Creditability)
length(pred_train)

confusionMatrix(cm_train)

#Accuracy : 0.765  :training dataset
#Accuracy : 0.73  :test dataset

#it means our model has low variance not a overfitting problem;




### You can increase the accuracy by changing the threshold value.
#############################################################################################

#now we will change the thershold value to increase the accuracy
pred_thres_60<-ifelse(pred>0.6,1,0) #71.1%
cm1<-table(test$Creditability,pred_thres_60)
confusionMatrix(cm1)

pred_thres_40<-ifelse(pred>0.4,1,0) #73.1%
cm2<-table(test$Creditability,pred_thres_40)
confusionMatrix(cm2)

## so the threshold value at 0.5 will give us better accuracy as compare to other threshold values.

# we will use roc and Auc curve for the right threshold value;

library(ROCR)
str(ger_credit)
### all should be in numeric for the prediction ############################

roc_pred = prediction(test$Creditability,pred_thres_50)
roc_perf = performance(roc_pred,"tpr","fpr")
plot(roc_perf, colorize = T, lwd = 2)
abline(a = 0, b = 1) 

###############################################################################
###############################################################################

################## considered Imbalance dataset ################################

#We'll use the sampling techniques and try to improve this prediction accuracy. 
#This package provides a function named "ovun.sample" which enables oversampling, 
#undersampling in one go.

#Let's start with oversampling and balance the data.

library(ROSE)
names(ger_credit)
table(ger_credit$Creditability)

over_sampling<- ovun.sample(Creditability~.,data = ger_credit,method = "over",N=1400)$data

table(over_sampling$Creditability)

#In the code above, method over instructs the algorithm to perform over sampling. 
#N refers to number of observations in the resulting balanced set. 
#In this case, originally we had 700 positive observations. 
#So, I instructed this line of code to over sample minority class until it reaches 
# 700 and the total data set comprises of 1400 samples.


#Similarly, we can perform undersampling as well. Remember, undersampling is done without replacement.
under_sampling <- ovun.sample(Creditability~.,data = ger_credit,method = "under",N=600, seed = 1)$data
table(under_sampling$Creditability)

#Now the data set is balanced. But, you see that we've lost significant information from the sample. 
#Let's do both undersampling and oversampling on this imbalanced data. This can be achieved using method = "both". 
#In this case, the minority class is oversampled with replacement and majority class is undersampled without replacement.

both<- ovun.sample(Creditability~ ., data = ger_credit, method = "both", p=0.5)$data
table(both$Creditability)

#p refers to the probability of positive class in newly generated sample.

#The data generated from oversampling have expected amount of repeated observations.
#Data generated from undersampling is deprived of important information from the original data. 
#This leads to inaccuracies in the resulting performance. 
#To encounter these issues, ROSE helps us to generate data synthetically as well. 
#The data generated using ROSE is considered to provide better estimate of original data.

# this will give us better:
balance_rose<- ROSE(Creditability~.,data =ger_credit,seed = 1)$data
table(balance_rose$Creditability)

#This generated data has size equal to the original data set (1000 observations). 
#Now, we've balanced data sets using 4 techniques. 
#Let's compute the model using each data and evaluate its accuracy.

nrow(ger_credit)

#build decision tree models
library(rpart)
tree_rose <- rpart(Creditability ~ ., data = balance_rose)
tree_over <- rpart(Creditability ~ ., data = over_sampling)
tree_under <- rpart(Creditability~ ., data = under_sampling)
tree_both <- rpart(Creditability~ ., data = both)

##make predictions on unseen data
pred_tree_rose <- predict(tree_rose, newdata = test)
pred_tree_over <- predict(tree_over, newdata =test)
pred_tree_under <- predict(tree_under, newdata = test)
pred_tree_both <- predict(tree_both, newdata = test)

#It's time to evaluate the accuracy of respective predictions. 
#Using inbuilt function roc.curve allows us to capture roc metric.

#AUC ROSE
roc.curve(test$Creditability, pred_tree_rose)

#AUC oversampling
roc.curve(test$Creditability,pred_tree_over)

#AUC Undersampling
roc.curve(test$Creditability,pred_tree_under)

#AUC Both
roc.curve(test$Creditability,pred_tree_both)


################################################################################
################################################################################
################# K- fold "cross-validation" Method ############################

library(caret)
library(naivebayes)



# Define training control
set.seed(123) 
train.control <- trainControl(method = "cv", number = 10)
# Train the model
model <- train(factor(Creditability) ~., data = ger_credit, method = "naive_bayes",
               trControl = train.control)
# Summarize the results
print(model)

#The first line is to set the seed of the pseudo-random so that the same result can be reproduced. 
#You can use any number for the seed value.

#Next, we can set the k-Fold setting in trainControl() function. 
#Set the method parameter to "cv" and number parameter to 10. 
#It means that we set the cross-validation with ten folds. 
#We can set the number of the fold with any number, but the most common way is to set it to five or ten.

#The train() function is used to determine the method we use. 
#Here we use the Naive Bayes method. 


#RMSE       Rsquared   MAE      
#0.4101413  0.2057379  0.3432896


#we can use model like - "lm", "glm", "naive_bayes", "rpart"


###############################################################################
######################## Repeatedcross-validation ###########################

# Define training control
set.seed(123)
train.control <- trainControl(method = "repeatedcv", 
                              number = 10, repeats = 3)
# Train the model
model <- train(Creditability ~., data = ger_credit, method = "glm",
               trControl = train.control)
# Summarize the results
print(model)

# Train the model by naive_bayes theorem 
model <- train(factor(Creditability) ~., data = ger_credit, method = "naive_bayes",
               trControl = train.control)
# Summarize the results
print(model)

#RMSE      Rsquared   MAE      
#0.410076  0.2091876  0.3431877

#The process of splitting the data into k-folds can be repeated a number of times, 
#this is called repeated k-fold cross validation.
#The final model error is taken as the mean error from the number of repeats.
#The above model has used 10-fold cross validation with 3 repeats: