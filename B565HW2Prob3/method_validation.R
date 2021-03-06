setwd("/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW2Prob3"); rm(list = ls()); cat("\014")

# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 
# Read data set and preprocess
# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 

filename <- "frogs.csv"
dset <- read.csv(filename, header = F)
# dset <- dset[sample(nrow(dset)),]  # Shuffle data points orders
true_labels <- dset[,ncol(dset)]
dset <- dset[,1:(ncol(dset)-1)]

# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 
# Random guess
# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 

# Generate randomly guessed labels, using the sample distribution
rand_guess_labels = sample(unique(true_labels), size = nrow(dset), replace = T, prob = array(table(true_labels)) / length(true_labels)) 
# Generate randomly guessed labels, using the uniform distribution
# rand_guess_labels = sample.int(length(unique(true_labels)), size = nrow(dset), replace = T)

# Error rate calculation
err_rate <- 1 - sum(rand_guess_labels == true_labels) / nrow(dset)
cat("Random guess error rate = ", err_rate, "\n", sep = "")

# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
# R built in kmeans
# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

nclust = 3
res <- kmeans(dset, centers = nclust, nstart = 1)

# Assign predicted labels
rkmeans_labels <- array(0, nrow(dset))
for (k in 1:nclust) {
    clust_pts <- res$cluster == k
    rkmeans_labels[clust_pts] <- as.numeric(names(sort(table(true_labels[clust_pts]), decreasing = T))[1])
}

# Error rate calculation
err_rate <- 1 - sum(rkmeans_labels == true_labels) / nrow(dset)
cat("R built in error rate = ", round(err_rate * 100, 4), "%\n", sep = "")
