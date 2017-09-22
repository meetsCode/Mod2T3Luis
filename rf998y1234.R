#!RStudio
#run me: source("rf998y1234.R", echo = TRUE)



set.seed(998)
trainPosition <- createDataPartition(dataFormated$brand, p = .75, list = FALSE)
trainSet <- dataFormated[trainPosition,]
testSet <- dataFormated[-trainPosition,]

fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)


modelRF998 <- train(brand ~.,
                 data=trainSet,
                 method="rf",
                 trControl=fitControl,
                 #preProcess=c("center","scale"),
                 metric="Accuracy",
                 tuneLength=3)


examenModeloRF998 <- predict(modelRF998, testSet)  #make predictions
postResample(examenModeloRF998, testSet$brand)  #performace measurment



set.seed(1234)
trainPosition <- createDataPartition(dataFormated$brand, p = .75, list = FALSE)
trainSet <- dataFormated[trainPosition,]
testSet <- dataFormated[-trainPosition,]

fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)


modelRF1234 <- train(brand ~.,
                 data=trainSet,
                 method="rf",
                 trControl=fitControl,
                 #preProcess=c("center","scale"),
                 metric="Accuracy",
                 tuneLength=3)


examenModeloRF1234 <- predict(modelRF1234, testSet)  #make predictions
postResample(examenModeloRF1234, testSet$brand)  #performace measurment


#### resultados modelRF1234 ####

# > modelRF1234
# Random Forest 
# 
# 7501 samples
# 6 predictor
# 2 classes: 'Acer', 'Sony' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 10 times) 
# Summary of sample sizes: 6750, 6751, 6752, 6751, 6751, 6751, ... 
# Resampling results across tuning parameters:
#   
#   mtry  Accuracy   Kappa       
# 2    0.6216905  0.0001314035
# 18    0.9224516  0.8352687536
# 34    0.9179060  0.8255452603
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was mtry = 18.


# > predictors(modelRF1234)
# [1] "salary"                                         "age"                                           
# [3] "elevelHigh_School_Degree"                       "elevelSome_College"                            
# [5] "elevelx4_Year_College_Degree"                   "elevelMaster_s_Doctoral_or_Professional_Degree"
# [7] "carBuick"                                       "carCadillac"                                   
# [9] "carChevrolet"                                   "carChrysler"                                   
# [11] "carDodge"                                       "carFord"                                       
# [13] "carHonda"                                       "carHyundai"                                    
# [15] "carJeep"                                        "carKia"                                        
# [17] "carLincoln"                                     "carMazda"                                      
# [19] "carMercedes_Benz"                               "carMitsubishi"                                 
# [21] "carNissan"                                      "carRam"                                        
# [23] "carSubaru"                                      "carToyota"                                     
# [25] "carNone_of_the_above"                           "zipcodeMid-Atlantic"                           
# [27] "zipcodeEast_North_Central"                      "zipcodeWest_North_Central"                     
# [29] "zipcodeSouth_Atlantic"                          "zipcodeEast_South_Central"                     
# [31] "zipcodeWest_South_Central"                      "zipcodeMountain"                               
# [33] "zipcodePacific"                                 "credit" 


# > confusionMatrix(modelRF1234)
# Cross-Validated (10 fold, repeated 10 times) Confusion Matrix 
# 
# (entries are percentual average cell counts across resamples)
# 
# Reference
# Prediction Acer Sony
# Acer 34.0  4.0
# Sony  3.8 58.2
# 
# Accuracy (average) : 0.9225


#### resultados modelRF998 ####

# 
# > modelRF998
# Random Forest 
# 
# 7501 samples
# 6 predictor
# 2 classes: 'Acer', 'Sony' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 10 times) 
# Summary of sample sizes: 6751, 6751, 6751, 6751, 6751, 6750, ... 
# Resampling results across tuning parameters:
#   
#   mtry  Accuracy   Kappa    
# 2    0.6216505  0.0000000
# 18    0.9224898  0.8352859
# 34    0.9184236  0.8265449
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was mtry = 18.


# > predictors(modelRF998)
# [1] "salary"                                         "age"                                           
# [3] "elevelHigh_School_Degree"                       "elevelSome_College"                            
# [5] "elevelx4_Year_College_Degree"                   "elevelMaster_s_Doctoral_or_Professional_Degree"
# [7] "carBuick"                                       "carCadillac"                                   
# [9] "carChevrolet"                                   "carChrysler"                                   
# [11] "carDodge"                                       "carFord"                                       
# [13] "carHonda"                                       "carHyundai"                                    
# [15] "carJeep"                                        "carKia"                                        
# [17] "carLincoln"                                     "carMazda"                                      
# [19] "carMercedes_Benz"                               "carMitsubishi"                                 
# [21] "carNissan"                                      "carRam"                                        
# [23] "carSubaru"                                      "carToyota"                                     
# [25] "carNone_of_the_above"                           "zipcodeMid-Atlantic"                           
# [27] "zipcodeEast_North_Central"                      "zipcodeWest_North_Central"                     
# [29] "zipcodeSouth_Atlantic"                          "zipcodeEast_South_Central"                     
# [31] "zipcodeWest_South_Central"                      "zipcodeMountain"                               
# [33] "zipcodePacific"                                 "credit"


# >  confusionMatrix(modelRF998)
# Cross-Validated (10 fold, repeated 10 times) Confusion Matrix 
# 
# (entries are percentual average cell counts across resamples)
# 
# Reference
# Prediction Acer Sony
# Acer 34.0  3.9
# Sony  3.9 58.3
# 
# Accuracy (average) : 0.9225





#### testing modelRF1234 ####
# > postResample(examenModeloRF1234, testSet$brand)  #performace measurment
# Accuracy     Kappa 
# 0.9231693 0.8373113

#### testing modelRF998 ####
# > postResample(examenModeloRF998, testSet$brand)  #performace measurment
# Accuracy       Kappa 
# 0.51660664 -0.02485278 


#### imprimiendo todo para markdown ####
modelo <- c('knn998', 'knn1234', 'RF998', 'RF1234' )
semilla <- c(998, 1234, 998, 1234)
k <- c(15,19, NA, NA )
AccTrain <- c(0 , 0 , 0.9224898 , 0.9224516)
KappaTrain <- c(0 , 0 , 0.8352859,   0.8352687536)
AccTest <- c(0 , 0 , 0.51660664, 0.9231693)
KappaTest <- c(0 , 0 , -0.02485278, 0.8373113)


resumen <- data.frame(modelo, semilla, k, AccTrain, KappaTrain, AccTest, KappaTest)
pander(resumen, 
       style="rmarkdown", 
       caption="Resumen errores")



