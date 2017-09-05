

- - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat("\014")    #limpio consola.
rm(list = ls())   #borro todos los objetos de memoria.
update.packages() #para mantener los paquetes actualizados.
#para borrar fuentes: /Library/Frameworks/R.framework/Versions/3.4/Resources/library/XX
#para borrar fuentes: /private/var/folders/p8/XXXxxxxxxxxxxxxx
#para borrar librerías:  remove.packages() 
#  .libPaths()    Sys.getenv("R_LIBS_USER") 
available.packages()



#### EJERCICIO. 2.1. Introduction to the caret Package ####

#### 2.1. pruebo uno ya hecho ####
#### APRENDIENDO instalacion ####

install.packages("caret")
install.packages("mlbench")
install.packages("caret", dependencies = c("Depends", "Suggests")) 
# No preguntó sobre instalar los fuentes como en el Mac

install.packages("DiagrammeR") #porque lo necesitó Claudi.
install.packages("agricolae")  #porque lo necesitó Claudi más adelante.

library(caret)
library(mlbench)

data(Sonar)



#### APRENDIENDO caso 1 ####

set.seed(107)
inTrain <- createDataPartition(y = Sonar$Class,
                               ## the outcome data are needed
                               p = .75,
                               ## The percentage of data in the
                               ## training set
                               list = FALSE)
## The format of the results

## The output is a set of integers for the rows of Sonar
## that belong in the training set.
str(inTrain)

training <- Sonar[inTrain,]
testing <- Sonar[-inTrain,]

nrow(training)

nrow(testing)

plsFit <- train(Class ~ . ,
                data = training,
                method = "pls",
                preProc = c("center","scale") )

plsClasses <- predict(plsFit, newdata = testing)
str(plsClasses)

plot(plsFit)

plsProbs <- predict(plsFit, newdata = testing, type = "prob")
head(plsProbs)

confusionMatrix(data = plsClasses, testing$Class)

#### APRENDIENDO caso 2 ####

## To illustrate, a custom grid is used 
rdaGrid = data.frame(gamma = (0:4)/4, lambda = 3/4)
set.seed(123)
rdaFit <- train(Class ~ .,
                data = training,
                method = "rda",
                tuneGrid = rdaGrid,
                trControl = ctrl,
                metric = "ROC")
rdaFit

rdaClasses <- predict(rdaFit, newdata = testing)
confusionMatrix(rdaClasses, testing$Class)

resamps <- resamples(list(pls = plsFit, rda = rdaFit))
summary(resamps)






#### 2.2. pruebo yo solo uno ####
# Debo hacer un script (pipeline lo llaman aquí) que use estas funciones:
#   createDataPartition()
#   trainControl()
#   train()
#   predict()
#   postResample()

#### APRENDIENDO de https://rpubs.com/jesuscastagnetto/caret-knn-cancer-prediction de resources
uciurl <- "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data"
download.file(url=uciurl, destfile="wdbc.data", method="curl")
wdbc <- read.csv("wdbc.data", header=FALSE, stringsAsFactors=FALSE)[-1]
wdbc <- wdbc[sample(nrow(wdbc)),]
features <- c("radius", "texture", "perimeter", "area", "smoothness", 
              "compactness", "concavity", "concave_points", "symmetry",
              "fractal_dimension")
calcs <- c("mean", "se", "worst")
colnames(wdbc) <- c("diagnosis",
                    paste0(rep(features, 3), "_", rep(calcs, each=10)))




