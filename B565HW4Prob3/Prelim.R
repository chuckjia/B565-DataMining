setwd('/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW4Prob3/data/')
rm(list = ls()); cat('\014')

# dset <- read.table('100k/u.data', header = F, sep = '\t')
# dset <- read.table('10m/ratings.dat', header = F, sep = ":", colClasses = c(NA, "NULL"))
names(dset) <- c('UserID', 'ItemID', 'Rating', 'TimeStamp')

allUserID = unique(dset$UserID)
length(allUserID)
min(allUserID)
max(allUserID)

allItemID = unique(dset$ItemID)
allItemID = sort(allItemID)
length(allItemID)
min(allItemID)
max(allItemID)


dset <- read.table('100k/u.user', header = F, sep = '|')
names(dset) <- c("Userid", "Age", "Gender")
dset <- subset(dset, select = 1:3)
dset[,3] <- as.integer(dset[,3] == "F")
write.table(dset, file = "100k/user_info.csv", sep = ",", row.names = F, col.names = F)


















