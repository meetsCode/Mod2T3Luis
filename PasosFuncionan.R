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
library(caret)



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
cor(dataFormated[c(-3, -4, -5, -7)])  #limpia. No hay columnas correlacionadas.

#if(!is.null(dev.list())) dev.off() 

#### 3.2 Using createDataPartition create training and testing sets.  ####
# These will be created from the Survey Responses Complete.csv file. The 
# training data should represent 75% of the total data and the remaining 25% 
# will be used for testing. After optimizing your model you'll later use it to 
# make predictions on the incomplete surveys.
#creo el train y test Set:

