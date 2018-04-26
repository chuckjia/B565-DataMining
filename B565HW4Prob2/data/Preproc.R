setwd("/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW4Prob2")
rm(list = ls()); cat("\014")

genDummyVariable <- function(dset) {
    allFeatNames <- names(dset)
    numFeat <- ncol(dset)
    
    new_dset <- data.frame(matrix(nrow = nrow(dset), ncol = 0))
    newNames <- c()
    
    for (j in 1:numFeat) {
        origFeatName <- allFeatNames[j]
        uniqVal <- unique(dset[,j])
        for (featVal in uniqVal) {
            newFeatName <- paste(origFeatName, "_", featVal, sep = "")
            new_dset = cbind(new_dset, as.integer(dset[,j] == featVal))
            newNames = c(newNames, newFeatName)
        }
    }
    
    names(new_dset) = newNames
    return(new_dset)
}


# Car set
dset <- read.csv("data/car.data", header = F)
names(dset) <- c("buying", "maint", "doors", "persons", "lug_boot", "safety", "evalulation")
new_dset <- genDummyVariable(dset)

write.table(new_dset, file = "car_dv.csv", row.names = F, col.names = F, sep = ",")
write.table(names(new_dset), file = "car_dv_names.csv", row.names = F, col.names = F, sep = ",")


# Nursery set
dset <- read.csv("data/nursery.data", header = F)
names(dset) <- c("parents", "has_nurs", "form", "children", "housing", "finance", "social", "health", "admission")
new_dset <- genDummyVariable(dset)

write.table(new_dset, file = "data/nursery_dv.csv", row.names = F, col.names = F, sep = ",")
write.table(names(new_dset), file = "data/nursery_dv_names.csv", row.names = F, col.names = F, sep = ",")


# Mushroom set
dset <- read.csv("data/mushroom.data", header = F)
dset <- dset[,1:9]

names(dset) <- c("edible", "cap_shape", "cap_surface", "cap_color", "bruises", "odor", "gill_attachment", "gill_spacing", "gill_size")
new_dset <- genDummyVariable(dset)

write.table(new_dset, file = "data/mushroom_dv.csv", row.names = F, col.names = F, sep = ",")
write.table(names(new_dset), file = "data/mushroom_dv_names.csv", row.names = F, col.names = F, sep = ",")



#naive 100k
(0.827146 + 0.820011 + 0.811239 + 0.810707 + 0.815414) / 5

#naive 10m
(1.479261 + 1.473021 + 1.474050 + 1.480613 + 1.473891) / 5 / 2


