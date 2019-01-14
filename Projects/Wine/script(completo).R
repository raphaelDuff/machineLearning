install.packages("data.table")
install.packages("plotly")
install.packages("rpart.plot")
install.packages("dplyr")
install.packages("corrplot")

library(data.table)
library(dplyr)
library(ggplot2)
library(grid)
library(plotly)
library(tibble)
library(stringr)
library(rpart)
library(rpart.plot)
library(corrplot)

wine_dset <- read.csv2('Documentos/Vinhos/BaseWine_Red_e_White2018.csv')

wine_white_dset <- wine_dset %>%
  filter(Vinho == 'WHITE')

wine_red_dset <- wine_dset %>% 
  filter(Vinho == 'RED')


vinhos_brancos <- wine_white_dset[2:12]

wine_white_dset_padr <- scale(vinhos_brancos)
wine_white_dset_padr <- scale(Vinhos2Cat)
pca <- prcomp(wine_white_dset_padr, scale = TRUE)
pca <- prcomp(wine_white_dset_padr, scale = TRUE)

summary(pca)
summary(wine_white_dset$quality)

plot(1:ncol(wine_white_dset_padr), pca$sdev^2, type = "b", xlab = "Componente",
     ylab = "Vari?ncia", pch = 20, cex.axis = 0.8, cex.lab = 0.8)

pca$rotation

Vinhos2Cat <- wine_white_dset[2:13] %>%
  mutate(quality_cat = NULL) 
attach(Vinhos2Cat)
Vinhos2Cat$quality_cat[quality >= 7] <- 'Bom'
Vinhos2Cat$quality_cat[quality < 7] <- 'Ruim'

Vinhos2 <- wine_white_dset[2:13] %>%
  mutate(pc1 = pca$x[, 1]) %>%
  mutate(pc2 = pca$x[, 2]) %>%
  mutate(pc3 = pca$x[, 3]) %>%
  mutate(pc4 = pca$x[, 4]) %>%
  mutate(pc5 = pca$x[, 5]) %>%
  mutate(pc6 = pca$x[, 6]) %>%
  mutate(pc7 = pca$x[, 7]) %>%
  mutate(pc8 = pca$x[, 8]) %>%
  mutate(pc9 = pca$x[, 9]) %>%
  mutate(pc10 = pca$x[, 10]) %>%
  mutate(pc11 = pca$x[, 11]) 

matcor <- cor(Vinhos2)

#install.packages("corrplot")
corrplot::corrplot(matcor, method="circle", order="hclust")

Vinhos2Cat <- subset(Vinhos2Cat, select = -c(quality))


# amostra de casos de treino aleatoria
set.seed(2019)
prt <- 2/3

Vinhos2Cat$quality_cat <- as.factor(Vinhos2Cat$quality_cat)

treino <- sample(1:NROW(Vinhos2Cat), as.integer(prt*NROW(Vinhos2Cat)))

trainData <- Vinhos2Cat[treino,]
testData  <- Vinhos2Cat[-treino,]


######################################
###### MODELO DE REGRESSÂO LOGISTICA
########################################
?glm
Vinhos2Cat$quality <- as.factor(Vinhos2Cat$quality)
modelo_log<-glm(quality_cat ~ alcohol+residualsugar+density, trainData, family=binomial(link=logit))
modelo_log<-glm(quality ~ pc1+pc9, Vinhos2Cat, family=binomial(link=logit))
summary(modelo_log)




attach(trainData)
modelo_log<-glm(quality ~ pc1, trainData, family=binomial(link=logit))
summary(modelo_log)

predito<-fitted(modelo_log)

summary(predito)

hist(predito)
# Criar vari�vel faixa probabilidade
fx_predito <- cut(predito, breaks=c(0,0.70,1), right=F)
plot(fx_predito , trainData$quality_cat)
fx_predito

attach(testData)
Predito_teste<-predict(modelo_log, testData)
Predito_teste
summary(Predito_teste)
### Matriz de confus�o  

fx_predito1 <- cut(Predito_teste, breaks=c(-1,2.5,4), right=F)
fx_predito1

MC <- table( quality_cat,  fx_predito1 , deparse.level = 2) # montar a matriz de confus�o  
show(MC) # mostra os resultados  
ACC = sum(diag(MC))/sum(MC) # calcula a acur�cia  
show(ACC) # mostra a acur�cia  


#######################################
###############Arvore de Decisão
#########################################
modelo_tree <- rpart (quality_cat ~ alcohol+residualsugar+density, data=trainData, cp = 0.006,minsplit = 150,maxdepth=10)


rpart.plot(modelo_tree, type=4, extra=104, under=FALSE, clip.right.labs=TRUE,
           fallen.leaves=FALSE,   digits=2, varlen=-3, faclen=20,
           cex=0.4, tweak=1.7,
           compress=TRUE,
           snip=FALSE)



print(modelo_tree)
yprob <- predict(modelo_tree,testData )
hist(yprob)


pred_class <- predict(modelo_tree ,testData , type = "class")
pred_class 

Campanha.matriz.de.confusao<-table(testData$quality_cat, pred_class)
Campanha.matriz.de.confusao

diagonal <- diag(Campanha.matriz.de.confusao)
perc.erro <- 1 - sum(diagonal)/sum(Campanha.matriz.de.confusao)
perc.erro
