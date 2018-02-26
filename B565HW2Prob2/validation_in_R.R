cat("\014")
library(MASS)

nrow <- 1000
ndim <- 30
dset <- mvrnorm(n = nrow, mu = rep(0, ndim), Sigma = diag(ndim))

dist_mat <- as.matrix(dist(dset))

dist_mat <- matrix(-1, nrow = nrow, ncol = nrow)
for (i in 1:nrow) {
    if (i %% 50 == 0)
        cat(i, "\n")
    for (j in 1:nrow) {
        if (dist_mat[i, j] < 0) {
            x <- dset[i,]
            y <- dset[j,]
            dist_mat[i, j] <- 1 - sum(x * y) / (norm(x, type = "2") * norm(y, type = "2")) 
            dist_mat[j, i] <- dist_mat[i, j]
        }
    }
}

fifth_largest <- array(0, dim = nrow)
for (i in 1:nrow) {
    cat("Progress i = ", i, "\n", sep = "")
    fifth_largest[i] <- sort(dist_mat[i,])[5]
}

isInNeighbor_mat <- matrix(F, nrow, nrow)

for (i in 1:nrow) {
    isInNeighbor_mat[i,] <- dist_mat[i,] <= fifth_largest[i]
}

N5 <- array(0, dim = nrow)
for (j in 1:nrow)
    N5[j] <- sum(isInNeighbor_mat[,j])

plot(table(N5) / nrow)








