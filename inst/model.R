library(xgboost)
library(tidyverse)
library(DiagrammeR)
library(data.table)

#Needs numeric inputs. Need to make categorical numeric
y=as.numeric(iris$Species)-1
#dropping the y
x<-select(iris, -Species)
#Saving the names
var.names=names(x)
#Creating a matrix
x<-as.matrix(x)

#Making a list

param <- list(
  "objective" = "multi:softprob"
  ,"eval_metric" = "mlogloss"
  ,"num_class" = length(table(y))
  ,"eta" = .05
  ,"max_depth" = 7
  # ,"lambda" = 1
  #,"alpha" = .8
  #,"min_child_weight" = 3
  #,"subsample" = .9
  # ,"colsample_bytree" = .6
)

#150 rounds 
cv.nround = 250

## setting up cross validation. Function to fit the model
#Label is your Y value. 
#Folds: number of iterations
#Missing: deals with missing data. It creates decision trees for NA's
#Prediction: The last tree probabilities that are cross validated
#lower log loss the better. Does training and test set. 
bst.cv <- xgb.cv(param = param, data = x, label = y
                 ,nfold = 3, nrounds = cv.nround
                 ,missing = NA, prediction = TRUE)
#probabilites 
#bst.cv$pred
#shows for each tree the test and train log loss
#bst.cv$evaluation_log


## select the number of rounds based on the best logloss on the test set from the cross validation
nround = which(bst.cv$evaluation_log$test_mlogloss_mean == min(bst.cv$evaluation_log$test_mlogloss_mean))


## Lets check in on overfitting
ggplot(bst.cv$evaluation_log, aes(x = iter)) +
  geom_line(aes(y = train_mlogloss_mean), color = "blue") +
  geom_line(aes(y = test_mlogloss_mean), color = 'red') +
  geom_vline(xintercept = nround, linetype = 3)


## Building the main classifier
IrisClassifier <- xgboost(params = param, data = x, label = y
                          ,nrounds = nround, missing = NA)


xgb.importance(feature_names = var.names, model = IrisClassifier)


xgboost::xgb.plot.tree(IrisClassifier, feature_names = var.names, n_first_tree = 1)

## Generating predictions
p<-predict(IrisClassifier,x)
matrix(p,ncol=length(table(y)),byrow=TRUE)

## Dataframe with all trees
#treeDF <- xgb.model.dt.tree(var.names, IrisClassifier)

#graphTree(var.names, IrisClassifier, 1)

#xgb.plot.tree(var.names, model=IrisClassifier, n_first_tree=3)
#looks at model complexity 
#xgb.plot.deepness(IrisClassifier)
xgb.save(model=IrisClassifier,fname='iris.model')
