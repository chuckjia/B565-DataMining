setwd("/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW2Prob3/"); rm(list = ls()); cat("\014")

dset <- read.csv("docs/orig_data_sets/iris_orig.csv", header = F)
dset[,5] <- as.numeric(dset[,5])
write.table(dset, "iris.csv", sep = ",",  col.names = F, row.names = F)


dset <- read.csv("docs/orig_data_sets/Frogs_MFCCs_orig.csv", header = T)
dset <- subset(dset, select = 1:23)
dset[,23] <- as.numeric(dset[,23])
write.table(dset, "Frogs_MFCCs.csv", sep = ",",  col.names = F, row.names = F)
unique(dset[,23])
