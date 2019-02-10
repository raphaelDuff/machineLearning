# Ler arquivo csv
Vinhos <- read.csv2("BaseWine_Red_e_White2018.csv", row.names=1)

Vinhos$Vinho <- as.numeric(Vinhos$Vinho)

fix(Vinhos)

install.packages("dplyr")
library(dplyr)


########RODAR NO FINAL##############
Vinhos2 <- Vinhos %>%
  mutate(pc1 = acpcor$x[, 1]) %>%
  mutate(pc2 = acpcor$x[, 2]) %>%
  mutate(pc3 = acpcor$x[, 3]) %>%
  mutate(pc4 = acpcor$x[, 4]) 

matcor <- cor(Vinhos2)
######################################

install.packages("corrplot")
library(corrplot)
corrplot::corrplot(matcor, method="circle", order="hclust")

install.packages("corrgram")
library(corrgram)
corrgram(matcor, type = "cor", lower.panel = panel.shade, upper.panel = panel.pie)



Padr_Vinhos <- scale(Vinhos)

#Corelação

acpcor <- prcomp(Padr_Vinhos, scale = TRUE) 
summary(acpcor)


plot(1:ncol(Padr_Vinhos), acpcor$sdev^2, type = "b", xlab = "Componente",
     ylab = "Vari?ncia", pch = 20, cex.axis = 0.8, cex.lab = 0.8)

sum(acpcor$sdev^2)

acpcor$x[, 1:4]

