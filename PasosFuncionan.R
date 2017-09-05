

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



