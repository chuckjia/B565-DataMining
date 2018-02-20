rm(list = ls())
cat("\014")

setwd("/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW2Prob3")
dset <- read.csv("glass.csv", header = F)
res <- kmeans(dset, centers = 10, nstart = 1)
res$tot.withinss
