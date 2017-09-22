#!RStudio
#run me: source("PasosFuncionan.R", echo = TRUE)

# Pre inicio:
R.Version()
cat("\014")    #limpio consola.
rm(list = ls())   #borro todos los objetos de memoria.
if(!is.null(dev.list())) dev.off() #pone a cero las ventanas de plot y si no hay ninguna no da error


#### 3.1 Import and familiarize yourself with the training set.  ####

#### 3.1.1 Librarys ####
#install.packages("caret")
#install.packages("caret", dependencies = c("Depends", "Suggests"))
#install.packages("edaplot")
library(caret)
library(pander)
library(edaplot)


#### 3.1.2 Absorcion datos ####
dataRaw <- read.csv("/Users/luis/Desktop/Mooc Pharo/dd/Modulo 2/Mod2Task3/Mi trabajo/Mod2T3Luis/Survey_Key_and_Complete_Responses_excel.csv", 
                    #            header=FALSE, 
                    stringsAsFactors=FALSE)
# dataRaw <- read.csv(file.choose())
str(dataRaw)
dataFormated <- dataRaw



#### 3.1.3 Formateo Columnas ####
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
cor(dataFormated[c(-3, -4, -5, -7)])  #limpia. No hay columnas correlacionadas. No incluyo las categóricas.


#### 3.2 Using createDataPartition create training and testing sets.  ####
# These will be created from the Survey Responses Complete.csv file. The 
# training data should represent 75% of the total data and the remaining 25% 
# will be used for testing. After optimizing your model you'll later use it to 
# make predictions on the incomplete surveys.
#creo el train y test Set: 

set.seed(998)
trainPosition <- createDataPartition(dataFormated$brand, p = .75, list = FALSE)
trainSet <- dataFormated[trainPosition,]
testSet <- dataFormated[-trainPosition,]
#Lo chulo sería aquí comprobar si se ha repartido equitativamente las dos clases dependientes.




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

#Me hubiera gustado usar Random Forest porque usa árboles de clasificación y eso es justo lo que 
# aprendí a usar para predecir el tipo de clientes. Sin embargo quieren que usemo KNN porque también 
# sirve para predecir valores contínuos (como hice en la práctica anterior) sino discretos.

#10 fold cross validation
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
#ver las soluciones en el Wiki: 


#### 3.4 Make predictions.  ####
# Using the KNN model you just built and the testing set created previously make predictions 
# using the predict() function. After making the predictions using the testing set use 
# postResample() to assess the metrics of the new predictive model. 
# Assess the performance of the predictive model and record the Accuracy and Kappa scores.

examenModelo <- predict(knnModel, testSet)  #make predictions
postResample(examenModelo, testSet$brand)  #performace measurment

# Accuracy      Kappa 
# 0.60304122  0.06136794
# Esto es más o menos que lo de antes? K=19  0.6022682  0.06497997 ? parece igual ¿Lo es?

plot(examenModelo, testSet$brand) #plot predicted verses actual
# Esto es como la matriz de confusión pero puesto en modo gráfico. 
# ¡Ojo! que la diagonal gráfica hay que leerla con la diagonal contraria a cuando se muestra con datos.
confusionMatrix(examenModelo, testSet$brand)
# Reference
# Prediction Acer Sony
# Acer  254  267
# Sony  691 1287

pander(prop.table(table(testSet$brand)), 
       style="rmarkdown", 
       caption="Original frequencies (%)")






modelRF <- train(brand ~.,
                  data=trainSet,
                  method="rf",
                  trControl=fitControl,
                  #preProcess=c("center","scale"),
                  metric="Accuracy",
                  tuneLength=3)
# ¡Ojo! Este proceso dura una hora y media justas!!!!!!!
examenModeloRF <- predict(modelRF, testSet)  #make predictions
postResample(examenModeloRF, testSet$brand)  #performace measurment

# Accuracy      Kappa 
# 0.60304122  0.06136794
# Esto es más o menos que lo de antes? K=19  0.6022682  0.06497997 ? parece igual ¿Lo es?

plot(examenModeloRF, testSet$brand) #plot predicted verses actual
# Esto es como la matriz de confusión pero puesto en modo gráfico. 
# ¡Ojo! que la diagonal gráfica hay que leerla con la diagonal contraria a cuando se muestra con datos.
confusionMatrix(examenModeloRF, testSet$brand)


#### 3.?? árbol de clasificacion
#tiene sentido hace un KNN o un SVM para predecir? Y con lo predicho completar?
# ¿Qué es lo que quiere saber quien compra qué?
# para eso mejor un árbol de decisión.
# J48 ya lo he hecho con WEKA ahora un 5.0 con R:
# EnJ48 me ha salido claramente que el sueldo es el principal divisor y 
# dentro de algunas franjas de sueldo la edad.
# veamos: 

DecisionTreeModel <- train(brand ~.,
                           data=trainSet,
                           method="C5.0",
                           trControl=fitControl,
                           #preProcess=c("center","scale"),
                           metric="Accuracy",
                           tuneLength=3)


source("rf998y1234.R", echo = TRUE)
source("knn998y1234.R", echo = TRUE)
