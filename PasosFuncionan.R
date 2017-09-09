#!RStudio
#
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



