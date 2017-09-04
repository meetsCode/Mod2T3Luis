

- - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat("\014")       #limpio consola.
rm(list = ls())   #borro todos los objetos de memoria.
update.packages() #para mantener los paquetes actualizados.
#para borrar fuentes: /Library/Frameworks/R.framework/Versions/3.4/Resources/library/XX
#para borrar fuentes: /private/var/folders/p8/XXXxxxxxxxxxxxxx
#para borrar librerías:  remove.packages() 
#  .libPaths()    Sys.getenv("R_LIBS_USER") 
available.packages()



#### EJERCICIO. Lectura/instalación paquetes básicos ####
# documentacion: https://cran.r-project.org/web/packages/caret/index.html
# documentacion: https://cran.r-project.org/web/packages/caret/vignettes/caret.pdf
install.packages("caret", dependencies = c("Depends", "Suggests")) #Es para instalar el paquete y las depedencias también
y # primera pregunta: NO  --> Así no instala las fuentes para compilarlas yo.
# La segunda: SI para que cargue las dependencias ya compiladas.
# tarda 5 minutos.


# practicando ejemplos trainSet -------------------------------------------
install.packages("ModelMetrics")  #me dio un error la primera vez que cargué caret diciendo que le faltaba este.
install.packages("mlbench")    #me dio un error la primera vez que cargué caret diciendo que le faltaba este.
install.packages("Sonar")     #me dio un error la primera vez que cargué caret diciendo que le faltaba este. Dice que no está para el paquete 3.3.3
install.packages("caretEnsemble")    #me dio un error la primera vez que cargué caret diciendo que no encontraba Sonar. 
# encontré https://cran.r-project.org

library(caret)
library(mlbech)
data(Sonar)

# NADA! no funciona. Elimino la versión 3.3.3 e instalo la versión 3.2.1
#comienzo otra vez:
install.packages("caret", dependencies = c("Depends", "Suggests")) 
# me pregunta 2 veces por instalar desde sources. Esta vez digo que sí a ambas.
# comienza a 16:12 acaba a las 16:30

library(caret) #paquete no reconocido.
install.packages("caret")
# Loading required package: lattice
# Error: package ‘ggplot2’ required by ‘caret’ could not be found
# Además: Warning message:
#    package ‘caret’ was built under R version 3.2.5 

#no hay 3.2.5 para Mac sino 3.3.3
# NADA! no funciona. Elimino la versión 3.2.1 e instalo la versión 3.3.3 de nuevo
#comienzo otra vez:

install.packages("caret", dependencies = c("Depends", "Suggests")) 
install.packages("caret")
library(caret)
#Me pide: 
install.packages("mlbech")
# Warning in install.packages :
#   package ‘mlbech’ is not available (for R version 3.3.3)

# NADA! no funciona. Elimino la versión 3.3.3 e instalo la versión 3.4.1 de nuevo
#comienzo otra vez:

install.packages("caret", dependencies = c("Depends", "Suggests")) 
# yes / yes


library(caret)
#Me pide: 
install.packages("ggplot2")
# y luegolibrary(caret)  me pide: 
install.packages("munsell")
# y luegolibrary(caret)  me pide: 
install.packages("ModelMetrics")

library(mlbech)
install.packages("mlbech") 
# Warning in install.packages :
#   package ‘mlbech’ is not available (for R version 3.4.1)

# y aquí se acaba mi aventura. Solo me queda probar con Windows

data(Sonar)  



# practicando ejemplos trainSet ---------------------------------------


#### EJERCICIO. Absorción ####
#data <- read.csv("/Users/luis/Desktop/existing product attributes.csv", stringsAsFactors=FALSE)
data <- read.csv(file.choose())
#como no pueden empezar por número me pone una X delante. 
#Los espacios en blanco los pasó a puntos.
#Ahora les quito los espacios en blanco.

colnames(data)
head(data,3)

#### EJERCICIO. Cabeceras de filas y columnas ####
# Es un problema que haya espacios vacíos en las cabeceras de las columnas.
#como no pueden empezar por número me pone una X delante.
# en la versión 3.3.1
#      Los espacios en blanco los pasa a puntos automáticamente.
#      Si empieza por número les pone una X.delante automáticamente. 
# Lo más práctico es cambiarles el nombre en cualquier caso para evitar errores del 
# copiado o corrupción del fichero.

#las pongo más legibles:
colnames(data) <- c("ProductType","Product","Price",                        
"x5StarReviews","x4StarReviews","x3StarReviews","x2StarReviews",
"x1StarReviews","X.Positive.Service.Review.",
"NegativeServiceReview","WouldConsumerRecommendProduct","BestSellersRank",
"ShippingWeightLbs","ProductDepth","ProductWidth","ProductHeight",
"ProfitMargin","Volume")



#### EJERCICIO. Observación de datos ####
# Observación de datos. Antes de modificar nada debo saber si hay patrones que se repiten tanto en vertical como en horizontar. 
# Esos patrones son de errores o trampas. Debe incluir una duda sobre la calidad de los datos. 
# Si están extraidos de algún sitio ¿Puedo obtenerlo yo en lugar de ellos? En ese caso luego compararé.
# Si son calculos que ellos han hecho ¿Puedo repetirlos yo otra vez? Quizás hayan sumado mal varias columnas en una tercera.
# ¿Hay NA ordenados en horizontal? --> Algunas instancias estaban corrompidas.
# ¿Hay NA ordenados en vertical? --> Algunas features están mal calculados o el detector no funciona bien.
# ¿Hay Datos que sobresalen del resto (outlisiders) ? ¿El sistema debería ser estable (Deming) pero no lo es?
# ¿Entiendo lo que representa cada columna? ¿Sus nombres son descriptivos/adecuados?¿Sus cálculos lo representan de verdad o el nombre y los datos no casan?
# ¿Categóricos (Factors) aparecen como cadena? ¿Valores de Factors aparecen con espacios? ¿No toma como iguales los que lo son?
# ¿Números aparecen como Strings? --> tienen NAs
# TODO ESTO DEBO ANOTARLO Y NO ACTUAR AÚN. LAS ACTUACIONES VIENEN A CONTINUACIÓN.
# El cliente agradece que en el request del informe final incluyamos la información de los fallos encontrados en sus ficheros.
#    porque muchas veces esos mismos datos los usan ellos para tomar decisiones empresariales.



#### EJERCICIO. cambios datos ####
str(data)
#veo que BestSellersRank ha quedado como sting cuando debería ser num. 
#Eso es porque debe haber vacíos. 

#Trato el campo BestSellersRank
data$BestSellersRank <- as.numeric(data$BestSellersRank)
#me aviso que NAs introducidos por coerción.
#Queda reparados los NA
data$BestSellersRank[is.na(data$BestSellersRank)] <- mean(data$BestSellersRank, na.rm = TRUE)

#ProductType es una variable categórica. La transformo en Factor 
# pero antes hay que eliminar los espacios en sus descripciones:
dataNew[which(dataNew[,1] == "'Game Console'"),1] <- "GameConsole"
dataNew[which(dataNew[,1] == "'Extended Warranty'"),1] <- "Extended_Warranty"
data$ProductType <- factor(data$ProductType)

#La columna product es un código interno sin relación con el código.
#La borro para no despistar al sistema:
#no funcionó    rm(data$Product)
data$Product <- NULL # Y creo la función seleccionColumnasConsolidadas(dataRAW) e introduzco el valor 2.


#### EJERCICIO. Modelización 1 ####
#hago una prueba de modelización a ver qué errores o aciertos me da.
trainSize <- round(nrow(data) * 0.7 )
testSize <- nrow(data) - trainSize
set.seed(123) #esto es para que en todas las veces que lo repita me salga igual.
#trainPosition <- sample( seq_len(nrow(data)), size = trainSize) la simplifico
trainPosition <- sample(x = nrow(data), size = trainSize)
trainSet <- data[trainPosition,]
testSet <- data[-trainPosition,]


model <- lm(formula = trainSet$Volume ~ . , data = trainSet)
summary(model)
#Residual standard error: 2.926e-13 on 28 degrees of freedom
#Multiple R-squared:      1,	Adjusted R-squared:      1 
#p-value: < 2.2e-16
#
#Warning message:
#  In summary.lm(model) : essentially perfect fit: summary may be unreliable
#

#Vaya! parece que algo tan perfecto levanta perspicacias.
#¿Cómo se hacía para encontrar columnas relacionadas?



#### EJERCICIO. LIMPIO DE FEATURES no apropiados ####
#por columna: observo de que van y elimino aquellos que
# no tienen nada que ver(ej: margen producto vs. clientes) o que solo se conocen datos a posteriori (ej: ventas)
# este apartado lo ejecuto uno a uno. Por cada columna borrada realizo una revisión nueva de correlación y calidad d modelo
# ¿La columna que no aporta molesta? Es discutible. A veces sí otras puede ser una sorpresa la info que aparece.
# Al final las <<columnasBorrables>> debe ir a la función   seleccionColumnasConsolidadas(dataRenombrada)
columnasBorrables <- c(2 , 4)#, 12)#, 17)#, 13)
columnaEnAnalisis <- 12
data <- seleccionColumnas_En( c(columnaEnAnalisis, columnasBorrables) , dataRenombrada )
 
 
## 
modelo  <- modelizo_lm_BlackWell(data)
summary(modelo)
correlacion <- cor(data[,-1])



#### EJERCICIO. ANALIZO/LIMPIO LAS INSTANCIA (LÍNEAS), OUTSIDERS (o es outlier?) y otros ####
#por líneas: observo de que van y elimino aquellos que
# no tienen nada que ver. Me fijo para ello en la primera columna que es una gran 
# forzardora

# CURIOSAMENTE esto se observa también a través de las gráficas de las columnas. 
# Si algun dato sobre sale de los demás debo averiguar porqué. Son los OUTSIDERS
# Quizá mejor quitar esa línea que lo contiene OJO que esto
# también pasa luego con el fichero con datos a predecir pero lo veré luego
plot(data)
plot(data[,1])
plot(data[,2])
plot(data[,3])
plot(data[,4])
plot(data[,5])
plot(data[,6])
#¿Falta algún dato o se repite alguno? ¿Por qué? ¿Será que los reconoce como iguales/distintos respectivamente? 
# Mostrar la gráfica columna_X vs columna_A_Predecir también es útil? 
plot(data[,6],data[,18])
# ¿Cómo descubro líneas de relleno que son trampas? Lo he visto en este ejercicio por 
# casualidad pero existen. ¿Hay un cor() pero para instancias?


## ## ## MAS ADELANTE DEBO ASEGURARME DE QUE LOS DATOS A PREDECIR ESTÁN EN LOS DATOS DEL TRAINER? Y/O TESTER
# VER APARTADO 



#### EJERCICIO. FEATURES DE NUEVO por correlación. Solving Overfit ####

#Solving Overfit Through Feature Engineering
#Since your regression model is overiftting you will need to revisit the 
#feature in order to find the likely cause. 
#Check for collinearity - Using the cor() function of R check to see if any of the independent variables have correlation coefficients of .85 or higher with any of the other independent variables. If any of the independent variables are collinear you must remove one of the two to solve the issue; it is most common to keep the feature with the highest correlation to the dependent variable.
#TIP: The above process is often called filtering and is normally the first order of operations of feature engineering. There are two other areas, embedded methods and wrapper methods, that we'll cover later in the program.
#2. After removing any features with high correlating values rebuild the training set and use it to build a new linear model. If the new model is again overfitting you'll need to revisit your process until you've solved the collinearity that exists among the features.
#3. When you have a constructed a properly trained model that is no longer ovefitting use it with the related test set to predict the volume of new products from the New Products dataset - note the structure of the two datasets must be the same. In other words any features that were removed from the training set must also be removed from the testing set.
#4. Compare your results to those you found in task one when you used Weka for the analysis. Should the results be similar? Why or why not?
dataSoloNumericos <- data[,2:17] #me daba error con una columna de string. La elimino

#por columna: observo de que van y elimino aquellos que
# no tienen nada que ver(ej: margen producto vs. clientes) o que solo se conocen datos a posteriori (ej: ventas)
##data <- seleccionColumnasConsolidadas(dataRenombrada)
columnasBorrables <- c(2, 4, 12, 17, 13, 5, 7)#), 8) #observa que es continúo sobre los de dos puntos antes.
columnaEnAnalisis <- 2
data <- seleccionColumnas_En( c(columnaEnAnalisis, columnasBorrables) , dataRenombrada )

modelo  <- modelizo_lm_BlackWell(data)
summary(modelo)
correlacion <- cor(data[,-1])
which(correlacion >= 0.85)
# para terminar lo hago oficial:
dataRenombrada <- data # y paso estos valores a la funcion seleccionColumnasConsolidadas



correlacion <- cor(dataSoloNumericos)
#observando correlación se ve hay relación muy clara entre la columna x5StarReviews y Volumen 
#por lo tanto Borro x5StarReviews
dataDefinitivos <- dataSoloNumericos[,-2]
correlacion <- cor(dataDefinitivos)
#El resultado es bueno:




#### EJERCICIO. Modelización De nuevo?? en funcion ####
source("/Users/luis/Desktop/Mooc Pharo/dd/Modulo 2/Mod2Task2/Mod2T2Luis/libLuisMod2Task2.R")
model <- modelizo_lm_BlackWell(dataDefinitivos)
summary(model)
# Tiene buena pinta:
# Multiple R-squared:  0.9043
# p-value: < 2.2e-16

#hago un nuevo análisis
correlacion <- cor(dataSoloNumericos)
#Elimino todo aquello que tiene correlación >0.9
#Son: 3Star con 4 Star y 2star con 1 star: Columna 4 (3Star) y columna 6 (1Star)
dataDefinitivos <- dataSoloNumericos[,c(-2,-4,-6)]
model <- modelizo_lm_BlackWell(dataDefinitivos)
summary(model)
# Tiene buena pinta:
# Multiple R-squared:  0.8935
# p-value: < 2.2e-16

#hago un nuevo análisis
correlacion <- cor(dataSoloNumericos)
#Elimino todo aquello que tiene correlación >0.85
#Son: 5Star, 3star, 1 star, NegativeService: Columnas 2,4,6 y 8
dataDefinitivos <- dataSoloNumericos[,c(-2,-4,-6,-8)]
model <- modelizo_lm_BlackWell(dataDefinitivos)
summary(model)
# Tiene buena pinta:
# Multiple R-squared:  0.8777
# p-value: < 2.2e-16


comparisonTrain <- comprobando(modeloM = model, datos = dataDefinitivos)
comparisonTrain <- addComparativa(comparisonTrain)
mapeTrain <- mi_mape(comparisonTrain)   #269.7766% de error absoluto


#¿Con cual me quedo de estas tres? El P-value es el mismo pero el error ha empeorado. 
#¿Cómo se ve esto con el testSet?


#### EJERCICIO. Modelización con train- y test-Set ####

# PREPARO EL TEST Y TRAINSET  #
trainSize <- round(nrow(dataRenombrada) * 0.7 )
testSize <- nrow(dataRenombrada) - trainSize
set.seed(126)
trainPosition <- sample(x = nrow(dataRenombrada), size = trainSize)
trainSet <- dataRenombrada[trainPosition,]
testSet <- dataRenombrada[-trainPosition,]

#  MODELIZO CON TRAINset   #
modelo <- modelizo_RF_BlackWell(trainSet)
summary(modelo)

# pruebo el trainSet   #

comparisonTrain <- comprobando(modeloM = modelo, datos = trainSet)
comparisonTrain <- addComparativa(comparisonTrain)
mapeTrain <- mi_mape(comparisonTrain)   #269.7766% de error absoluto

# pruebo el testSet  # 

comparisonTest <- comprobando(modeloM = modelo, datos = testSet)
comparisonTest <- addComparativa(comparisonTest)
mapeTest <- mi_mape(comparisonTest)  #141.1907% de error absoluto



#con 123 la cosa empeoró:  claro, depende de la semilla usada. Probar varias.
#   
# > mapeTest     590.4545
# > mapeTrain    3942.817

mapeTest
mapeTrain

#Quizás si no hay suficientes datos es mejor usar todos lo datos y no el train-,test-set?






#### EJERCICIO. Making new predictions  #### 
#dataRaw <- read.csv("/Users/luis/Desktop/existing product attributes.csv", stringsAsFactors=FALSE)
#dataRaw <- read.csv("/Users/luis/Desktop/new product attributes copia.csv", stringsAsFactors=FALSE)
#dataNewP <- read.csv("/Users/luis/Desktop/new product attributesII.csv", stringsAsFactors=FALSE)
dataNewP <- read.csv("/Users/luis/Desktop/new product attributes.csv", stringsAsFactors=FALSE)

dataP <- preparacionDatos(dataNewP)
dataP <- seleccionColumnasConsolidadas(dataP)

str(dataP)
# summary(modelo)

predictions <- comprobando(modeloM = modelo, datos = dataP)
resultado <- cbind(data.frame(dataNewP$X.Product...), predictions)
write.csv(resultado, file = "/Users/luis/Desktop/existingResult_RF.csv" )

resultado


## ## ## DEBO ASEGURARME DE QUE LOS DATOS A PREDECIR ESTÁN EN LOS DATOS DEL TRAINER Y EL MODELO.
# Esto es especialmente crítico en el caso de categóricos (:=Factor)
# Para este fin incluí una función "include" como en Smalltalk
# lineasUtiles <- lineas_Includes( dataRenombrada[,1], dataNewExtrapolacion[,1])
# lineasUtiles <- which( lineasUtiles == TRUE)
# dataRenombrada <- dataRenombrada[ lineasUtiles, ]
# str(dataRenombrada)
# 
# 
# lineas_Include( data[,1], "PC")
# lineas_Includes( data[,1], c("PC", "hola"))





