#!RStudio
#run me: source("knn998y1234.R", echo = TRUE)


#### calculando models knnModel 998 y 1234 ####
set.seed(998)
trainPosition <- createDataPartition(dataFormated$brand, p = .75, list = FALSE)
trainSet <- dataFormated[trainPosition,]
testSet <- dataFormated[-trainPosition,]

fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

knnModel998 <- train(brand ~.,
                  data=trainSet,
                  method="knn",
                  trControl=fitControl,
                  preProcess=c("center","scale"),
                  tuneLength=10)


examenModelo998 <- predict(knnModel998, testSet)  #make predictions
postResample(examenModelo998, testSet$brand)  #performace measurment




set.seed(1234)
trainPosition <- createDataPartition(dataFormated$brand, p = .75, list = FALSE)
trainSet <- dataFormated[trainPosition,]
testSet <- dataFormated[-trainPosition,]

fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

knnModel1234 <- train(brand ~.,
                     data=trainSet,
                     method="knn",
                     trControl=fitControl,
                     preProcess=c("center","scale"),
                     tuneLength=10)


examenModelo1234 <- predict(knnModel1234, testSet)  #make predictions
postResample(examenModelo1234, testSet$brand)  #performace measurment


#### resultados knnModel1234 ####
# 
# > knnModel1234
# k-Nearest Neighbors 
# 
# 7501 samples
# 6 predictor
# 2 classes: 'Acer', 'Sony' 
# 
# Pre-processing: centered (34), scaled (34) 
# Resampling: Cross-Validated (10 fold, repeated 10 times) 
# Summary of sample sizes: 6750, 6751, 6752, 6751, 6751, 6751, ... 
# Resampling results across tuning parameters:
#   
#   k   Accuracy   Kappa     
# 5  0.5561107  0.03729664
# 7  0.5750026  0.06179307
# 9  0.5833347  0.06558996
# 11  0.5898802  0.06939000
# 13  0.5919609  0.06526057
# 15  0.5936268  0.05942250
# 17  0.5986272  0.06307298
# 19  0.6004803  0.06031919
# 21  0.5998939  0.05365107
# 23  0.5978662  0.04405928
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was k = 19.
# 
# > predictors(knnModel1234)
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
#
# > confusionMatrix(knnModel1234)
# Cross-Validated (10 fold, repeated 10 times) Confusion Matrix 
# 
# (entries are percentual average cell counts across resamples)
# 
# Reference
# Prediction Acer Sony
# Acer  8.6 10.7
# Sony 29.3 51.5
# 
# Accuracy (average) : 0.6005






#### resultados knnModel998 ####

# 
# > knnModel998
# k-Nearest Neighbors 
# 
# 7501 samples
# 6 predictor
# 2 classes: 'Acer', 'Sony' 
# 
# Pre-processing: centered (34), scaled (34) 
# Resampling: Cross-Validated (10 fold, repeated 10 times) 
# Summary of sample sizes: 6751, 6751, 6751, 6751, 6751, 6750, ... 
# Resampling results across tuning parameters:
#   
#   k   Accuracy   Kappa     
# 5  0.5541795  0.02976663
# 7  0.5713361  0.04999289
# 9  0.5846143  0.06192704
# 11  0.5908004  0.06425526
# 13  0.5968798  0.06767589
# 15  0.5989332  0.06539664
# 17  0.5975860  0.05599329
# 19  0.5953862  0.04497528
# 21  0.5927337  0.03338779
# 23  0.5927202  0.02843859
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was k = 15.
# 
# > predictors(knnModel998)
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

# 
# > confusionMatrix(knnModel998)
# Cross-Validated (10 fold, repeated 10 times) Confusion Matrix 
# 
# (entries are percentual average cell counts across resamples)
# 
# Reference
# Prediction Acer Sony
# Acer  9.3 11.6
# Sony 28.5 50.6
# 
# Accuracy (average) : 0.5989


#### testing knnModel1234 ####
# > examenModelo1234 <- predict(knnModel1234, testSet)  #make predictions
# > postResample(examenModelo1234, testSet$brand)  #performace measurment
# Accuracy      Kappa 
# 0.60304122 0.06136794

#### testing knnModel998 ####
# > examenModelo998 <- predict(knnModel998, testSet)  #make predictions
# > postResample(examenModelo998, testSet$brand)  #performace measurment
# Accuracy     Kappa 
# 0.6166467 0.1063153 




#### imprimiendo todo para markdown ####
pander(prop.table(table(testSet$brand)), 
       style="rmarkdown", 
       caption="Original frequencies (%)")