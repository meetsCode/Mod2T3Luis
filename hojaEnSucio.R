

- - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat("\014")    #limpio consola.
rm(list = ls())   #borro todos los objetos de memoria.
update.packages() #para mantener los paquetes actualizados.
#para borrar fuentes: /Library/Frameworks/R.framework/Versions/3.4/Resources/library/XX
#para borrar fuentes: /private/var/folders/p8/XXXxxxxxxxxxxxxx
#para borrar librerías:  remove.packages() 
#  .libPaths()    Sys.getenv("R_LIBS_USER") 
available.packages()

dev.off(dev.list()["RStudioGD"])  #pone a cero las ventanas de plot?
plot(dataRaw)
dev.off() #closes the current graphical device
dev.list()  #pone a cero las ventanas de plot?
graphics.off()   #pone a cero las ventanas de plot?
if(!is.null(dev.list())) dev.off()   #pone a cero las ventanas de plot y si no hay ninguna no da error

dataRaw <- read.csv(file.choose())
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

library(caret)     # para usar Knn
library(pander)    # para disponer de un visualizador bueno
library(doMC)      #install.packages("doMC")   para poder usar los dos cores del procesador
registerDoMC(cores=2) #En el ejercicio son 4 pero yo solo tengo 2 en este Mac



#### Funciones  ####
# a utility function for % freq tables
frqtab <- function(x, caption) {
  round(100*prop.table(table(x)), 1)
}

# utility function to round values in a list
# but only if they are numeric
round_numeric <- function(lst, decimals=2) {
  lapply(lst, function(x) {
    if (is.numeric(x)) {
      x <- round(x, decimals)
    }
    x
  })
}

# utility function to summarize model comparison results
summod <- function(cm, fit) {
  summ <- list(k=fit$finalModel$k,
               metric=fit$metric,
               value=fit$results[fit$results$k == fit$finalModel$k, fit$metric],
               TN=cm$table[1,1],  # true negatives
               TP=cm$table[2,2],  # true positives
               FN=cm$table[1,2],  # false negatives
               FP=cm$table[2,1],  # false positives
               acc=cm$overall["Accuracy"],  # accuracy
               sens=cm$byClass["Sensitivity"],  # sensitivity
               spec=cm$byClass["Specificity"],  # specificity
               PPV=cm$byClass["Pos Pred Value"], # positive predictive value
               NPV=cm$byClass["Neg Pred Value"]) # negative predictive value
  round_numeric(summ)
}

# You may want to omit the next line if using the UCI dataset
#   wdbc <- read.csv("wisc_bc_data.csv", stringsAsFactors = FALSE)[-1]
# recode diagnosis as a factor -- as done in the book example
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c("B", "M"),
                         labels = c("Benign", "Malignant"))
str(wdbc)

ft_orig <- frqtab(wdbc$diagnosis)
pander(ft_orig, style="rmarkdown", caption="Original diagnosis frequencies (%)")

# prop.table(table(wdbc$diagnosis), 1)
# str(table(wdbc$diagnosis))
# m <- matrix(1:4, 2)
# m
# prop.table(m, 1)

# m <- matrix(1:4, 2)
# margin.table(m, 1)
# margin.table(m, 2)

#### vamos con el K-nn  ####


#### separamos train y test data  ####
wdbc_train <- wdbc[1:469,]
wdbc_test <- wdbc[470:569,]

ft_train <- frqtab(wdbc_train$diagnosis)
ft_test <- frqtab(wdbc_test$diagnosis)

ftcmp_df <- as.data.frame(cbind(ft_orig, ft_train, ft_test))
colnames(ftcmp_df) <- c("Original", "Training set", "Test set")
pander(ftcmp_df, style="rmarkdown",
       caption="Comparison of diagnosis frequencies (in %)")


#### entrenamos con accuracy  ####
ctrl <- trainControl(method="repeatedcv", number=10, repeats=3)
set.seed(12345)
knnFit1 <- train(diagnosis ~ ., data=wdbc_train, method="knn",
                 trControl=ctrl, metric="Accuracy", tuneLength=20,
                 preProc=c("range"))

knnFit1 #aquí se ve como el mejor accuracy es 4ª posicion = K=11. 
        #en knnFit1 están todas las 20 pruebas y marcado el elegido.

plot(knnFit1) # Puedo ver como el 4º punto es el más alto--> K=11 --> 11 vecinos es ideal



#### examinamos con accuracy ####
knnPredict1 <- predict(knnFit1, newdata=wdbc_test)
cmat1 <- confusionMatrix(knnPredict1, wdbc_test$diagnosis, positive="Malignant")
cmat1
#Esta matriz está muy bien. Tengo 0 mal diagnosticados como benignos no siendolo.
#Tengo 2 malignos que se predijeron como Benignos.
#Eso significa que  si digo que es maligno igual es maligno seguro pero 
#si digo que es benigno puede ser maligno


#### entrenamos con kappa  ####
# ctrl <- trainControl(method="repeatedcv", number=10, repeats=3)
set.seed(12345) #importante porque sino no podemos comparar.
knnFit2 <- train(diagnosis ~ ., data=wdbc_train, method="knn",
                 trControl=ctrl, metric="Kappa", tuneLength=20,
                 preProc=c("range"))
knnFit2 #aquí se ve como el mejor accuracy es 4ª posicion <==> K=11. 
#en knnFit1 están todas las 20 pruebas y marcado el elegido.

plot(knnFit2) # Puedo ver como el 4º punto es el más alto--> K=11 --> 11 vecinos es ideal



#### examinamos con kappa ####
knnPredict2 <- predict(knnFit2, newdata=wdbc_test)
cmat2 <- confusionMatrix(knnPredict2, wdbc_test$diagnosis, positive="Malignant")
cmat2
#Esta matriz está muy bien. Tengo 0 mal diagnosticados como benignos no siendolo.
#Tengo 2 malignos que se predijeron como Benignos.
#Eso significa que  si digo que es maligno igual es maligno seguro pero 
#si digo que es benigno puede ser maligno

#### conclusión:   ####

#Me da igual si lo hago por accuracy o por Kappa. el modelo es el mismo.
# K=11 --> 11 vecinos es ideal la matriz de confusión sale igual:
#0 falsos malignos y 2 falsos benignos


#### entrenamos con ROS   ####
ctrl <- trainControl(method="repeatedcv", number=10, repeats=3,
                     classProbs=TRUE, summaryFunction=twoClassSummary)
knnFit3 <- train(diagnosis ~ ., data=wdbc_train, method="knn",
                 trControl=ctrl, metric="ROC", tuneLength=30,
                 preProc=c("range"))
knnFit3  #aquí se ve como el mejor accuracy es 3ª posicion <==> K=9. 
#en knnFit1 están todas las 20 pruebas y marcado el elegido.

plot(knnFit3) # Puedo ver como el 3º punto es el más alto--> K=9 --> 9 vecinos es ideal

#### examinamos con ROS   ####
knnPredict3 <- predict(knnFit3, newdata=wdbc_test)
cmat3 <- confusionMatrix(knnPredict3, wdbc_test$diagnosis, positive="Malignant")
cmat3
#Encuentro aquí que hay 2 falsos benignos y 0 falsos malignos.




#### comparación los tres modelos from the book's table in page 83 ####
tn=61
tp=37
fn=2
fp=0
book_example <- list(
  k=21,
  metric=NA,
  value=NA,
  TN=tn,
  TP=tp,
  FN=fn,
  FP=fp,
  acc=(tp + tn)/(tp + tn + fp + fn),
  sens=tp/(tp + fn),
  spec=tn/(tn + fp),
  PPV=tp/(tp + fp),
  NPV=tn/(tn + fn))

model_comp <- as.data.frame(
  rbind(round_numeric(book_example),
        summod(cmat1, knnFit1),
        summod(cmat2, knnFit2),
        summod(cmat3, knnFit3)))
rownames(model_comp) <- c("Book model", "Model 1", "Model 2", "Model 3")
pander(model_comp[,-3], split.tables=Inf, keep.trailing.zeros=TRUE,
       style="rmarkdown",
       caption="Model results when comparing predictions and test set")

#### la comparación Quedó sin hacer apartado: Changing the data partition strategy ####
#### la comparación Quedó sin hacer apartado: Changing the data partition strategy ####
https://rpubs.com/jesuscastagnetto/caret-knn-cancer-prediction
#### la comparación Quedó sin hacer apartado: Changing the data partition strategy ####
#### Resources:  strategy ####


#caret models
#http://topepo.github.io/caret/bytag.html
#model training: http://topepo.github.io/caret/training.html
#model measurement: http://topepo.github.io/caret/other.html

#dataframe = WholeYear
#Y Value = TotalSolarRad
WholeYear <- read.csv(file.choose())

colnames(WholeYear) <- c("num", "TimeofDay", "AirTemp", "Humidity", "Dewpoint", "BarPres", "WindSpeed", "TotalSolarRad") 
set.seed(998)


# define an 75%/25% train/test split of the dataset
inTraining <- createDataPartition(WholeYear$TotalSolarRad, p = .75, list = FALSE)
training <- WholeYear[inTraining,]
testing <- WholeYear[-inTraining,]


#10 fold cross validation
fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

#train Stepwise Linear regression model
LMFit1 <- train(TotalSolarRad~., data = training, method = "leapSeq", trControl=fitControl)

#predictor variables
predictors(LMFit1)


#make predictions
testPredLM1 <- predict(LMFit1, testing)


#performace measurment
postResample(testPredLM1, testing$TotalSolarRad)

#plot predicted verses actual
plot(testPredLM1,testing$TotalSolarRad)









# separador de punto ------------------------------------------------------



#### 3. Create Predictive Model Using k-Nearest-Neighbor ####

#### 3.1 Import and familiarize yourself with the training set.  ####
# The file Survey_Responses_Complete is an CSV file that includes answers to 
# all the questions in the market research survey, including which brand of 
# computer products the customer prefers. You will be using this data set to 
# train and test the classifier to make predictions. You will notice that there 
# is a mix of numeric and nominal values; some might need to be converted to factors. 
# Consult the Survey Coding Key tab in Survey Key and Complete Responses to gain an 
# understanding of what the survey response values mean. The coding key’s primary function 
# is to help you understand the coding of the survey – you only need the coding key 
# to prepare the labels in your final preferences graph. 

dataRaw <- read.csv("/Users/luis/Desktop/Mooc Pharo/dd/Modulo 2/Mod2Task3/Mi trabajo/Mod2T3Luis/Survey_Key_and_Complete_Responses_excel.csv", 
#            header=FALSE, 
            stringsAsFactors=FALSE)
str(dataRaw)
dataFormated <- dataRaw


dataFormated$salary <- round(dataRaw$salary, digits = 2)
#dataFormated$age <- factor(dataRaw$age) #Lo hago???

dataFormated$elevel <- factor(dataRaw$elevel, levels = c(0, 1, 2, 3, 4),
                              labels = c("Less_than_High_School_Degree", "High_School_Degree", 
                                         "Some_College", "x4_Year_College_Degree", 
                                         "Master_s_Doctoral_or_Professional_Degree"))

dataFormated$car <- factor(dataRaw$car, levels = 1:20,
                              labels = c("BMW", "Buick", "Cadillac", "Chevrolet",
                                         "Chrysler", "Dodge", "Ford", "Honda", "Hyundai", 
                                         "Jeep", "Kia", "Lincoln", "Mazda",
                                         "Mercedes_Benz", "Mitsubishi", "Nissan", "Ram", 
                                         "Subaru", "Toyota", "None_of_the_above"))

dataFormated$zipcode <- factor(dataRaw$zipcode, levels = 0:8,
                              labels = c("New_England", "Mid-Atlantic", "East_North_Central", 
                                         "West_North_Central", "South_Atlantic", "East_South_Central", 
                                         "West_South_Central", "Mountain", "Pacific"))

dataFormated$credit <- as.integer(dataRaw$credit)


dataFormated$brand <- factor(dataRaw$brand, levels = 0:1,
                               labels = c("Acer", "Sony"))
	





#### Las instancias son correctas? #### 
#debo buscar datos raros o fuera de lo común. No debo fiarme: líneas que están repetidas o con NA
str(dataFormated) # parece en orden el formato
summary(dataFormated) # parece en orden el formato y las cifras
boxplot(dataFormated)  # Esto qué hace? Algo muestra pero no veo el qué.
which(!complete.cases(dataFormated) )  # Esto qué hace? Algo muestra pero no veo el qué.
which(is.na(dataFormated)) # Bien! da 0 valores

#busco los outliers de cada columna. Los busco en comparación con el dato a adivinar: 
plot(dataFormated) # no me aclaro con esta gráfica. Tarda mucho en pintarla.
plot(dataFormated$salary) #homogéneo distribución
plot(dataFormated$age) #homogéneo distribución
plot(dataFormated$elevel) #homogénea distribución
plot(dataFormated$car)  #homogénea distribución
plot(dataFormated$zipcode) #homogénea distribución
plot(dataFormated$credit) #homogénea distribución
plot(dataFormated$brand) # hay muchas más sony que Acer pero de ambos suficientes instancias.

#Filas tramposas. 
# No sé cómo detectarlas. Como es un número tan grande lo dejo estar.

#Operaciones correctas.
# En estos datos no hay operaciones que sean resultados de las columnas

#Outliers
# Compararé todos los campos con la variable dependiente a ver si veo algo sospechoso.
plot(dataFormated, dataFormated$brand) # no me aclaro con esta gráfica. Tarda mucho en pintarla.
plot(dataFormated$salary, dataFormated$brand) #homogéneo distribución
plot(dataFormated$age, dataFormated$brand) #homogéneo distribución
plot(dataFormated$eleve, dataFormated$brandl) #homogénea distribución
plot(dataFormated$car, dataFormated$brand)  #homogénea distribución. más sony que Acer pero de ambos suficientes instancias
plot(dataFormated$zipcode, dataFormated$brand) #homogénea distribución
plot(dataFormated$credit, dataFormated$brand) #homogénea distribución
plot(dataFormated$brand, dataFormated$brand) # Porqué esta no me da una diagonal o algo así? No entiendo la representación.

#hay colunmas correlacionadas?
cor(dataFormated[c(-3, -4, -5, -7)])  #limpia. No hay columnas correlacionadas.



#### 3.2 Using createDataPartition create training and testing sets.  ####

# These will be created from the Survey Responses Complete.csv file. The 
# training data should represent 75% of the total data and the remaining 25% 
# will be used for testing. After optimizing your model you'll later use it to 
# make predictions on the incomplete surveys.
#creo el train y test Set:
# define an 75%/25% train/test split of the dataset
set.seed(1234)
trainPosition <- createDataPartition(dataFormated$brand, p = .75, list = FALSE)
trainSet <- dataFormated[trainPosition,]
testSet <- dataFormated[-trainPosition,]
#Lo chulo sería aquí comprobar si se ha repartido equitativamente las dos clases dependientes.

#Me hubiera gustado usar Random Forest porque usa árboles de clasificación y eso es justo lo que 
# aprendí a usar para predecir el tipo de clientes. Sin embargo quieren que usemo KNN porque también 
# sirve para predecir valores contínuos (como hice en la práctica anterior) sino discretos.

#10 fold cross validation
set.seed(1234)
fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
knnModel <- train(brand ~.,
                  data=trainSet,
                  method="knn",
                  trControl=fitControl,
                  preProcess=c("center","scale"),
                  tuneLength=10)
knnModel
#predictor variables
predictors(knnModel)


# ctrl <- trainControl(method="repeatedcv", number=10, repeats=3)
# set.seed(12345)
# knnFit1 <- train(diagnosis ~ ., data=wdbc_train, method="knn",
#                  trControl=ctrl, metric="Accuracy", tuneLength=20,
#                  preProc=c("range"))
# knnFit1


# 
# library(randomForest)
# model <- randomForest(formula = dataFormated$Volume ~ . , 
#                       data = trainSet, 
#                       importance=TRUE,
#                       proximity=TRUE)
# 
# summary(model)
# return(model)



#Compruebo ¿Cómo incluyo los datos en el modelo?

#¿Cómo incluyo los datos en el modelo?

#Creo un modelo para poder rellenar las que faltan del otro fichero


# 
# ctrl <- trainControl(method="repeatedcv", number=10, repeats=3)
# set.seed(12345)
# knnFit1 <- train(diagnosis ~ ., data=wdbc_train, method="knn",
#                  trControl=ctrl, metric="Accuracy", tuneLength=20,
#                  preProc=c("range"))
# knnFit1



#### 3.3 Run the KNN classifier on the training set with 10-fold cross validation.  ####
# In the task one, you used KNN to predict a specific numeric value (the sales volume of a 
# new product); in this task you will use the KNN classifier to predict nominal data (a 
# customer's computer brand preference). The main difference is that, in numeric prediction, 
# you are inferring a real number (such as how many products may be sold in a period of time) 
# while, in nominal (or categorical) prediction, you are selecting what class a given observation 
# belongs to. Remember that the data mining algorithms make the prediction in both types of 
# tasks based on the similarities and differences between the attributes (columns) of observations (rows). 
# You will be classifying "brand" in this task. After running KNN:
# Assess the performance of the trained model and record the Accuracy and Kappa scores for each K value 
# the model used during training.



#### 3.4 Make predictions.  ####
# Using the KNN model you just built and the testing set created previously make predictions 
# using the predict() function. After making the predictions using the testing set use 
# postResample() to assess the metrics of the new predictive model. 
# Assess the performance of the predictive model and record the Accuracy and Kappa scores.


source("PasosFuncionan.R", echo = TRUE)
if(!is.null(dev.list())) dev.off() 



examenModelo <- predict(knnModel, testSet)  #make predictions
postResample(examenModelo, testSet$brand)  #performace measurment
plot(examenModelo, testSet$brand) #plot predicted verses actual
# Esto es como la matriz de confusión pero puesto en modo gráfico. 
# Ojo que la diagonal hay que leerla con la diagonal contraria.
pander(prop.table(table(testSet$brand)), 
       style="rmarkdown", 
       caption="Original frequencies (%)")
 



knnModel <- train(brand ~.,
                  data=trainSet,
                  method="rf",
                  trControl=fitControl,
                  #preProcess=c("center","scale"),
                  metric="Accuracy",
                  tuneLength=3)


#### capítulo ####



DecisionTreeModel <- train(brand ~.,
                  data=trainSet,
                  method="C5.0",
                  trControl=fitControl,
                  #preProcess=c("center","scale"),
                  metric="Accuracy",
                  tuneLength=3)


DecisionTreeModel
pander( head(dataFormated) , style="rmarkdown", caption="Original diagnosis frequencies (%)")

# predict
# interval = 
# level =

edaPlot(trainSet)

#### capitulo  ####

library(C50)
modelo_C5.0 <- C5.0(training[1:7500,-7],training$brand)
modelo_C5.0
summary(modelo_C5.0)
modelo_C5.0 <- C5.0(training[1:7500,c(-3,-4,-5,-6,-7)],training$brand)
plot(modelo_C5.0)
modelo_C5.0.0 <- C5.0(formula=training$brand~.,data=training)
test_C5.0 <- predict(modelo_C5.0.0, testing, interval= "predict", level=.95)
test_C5.0 <- predict(modelo_C5.0.0, SurveyIncomplete, interval= "predict", level=.95)
SurveyIncomplete$brand <- test_C5.0
<<<Se me olvidó apuntar lo que hice luego. Debió ser pegar ambos data.frames y al nuevo lo llamé TODO7. Para pegarlos... rbind(data1, data2)
TODO7_C50 <- C5.0(TODO7[,c(-3,-4,-5,-6,-7)],TODO7$brand)
plot(TODO7_C50)

