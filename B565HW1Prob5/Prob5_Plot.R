rm(list = ls())

path = "/Users/chuckjia/Documents/Workspace/Eclipse/JIASpace/B565HW1/Results/"
seed_range = c(2, 200, 10000)
n_range <- c(100, 1000, 10000)

distno <- 5
generator <- "normal"

r_mat <- matrix(nrow = 100, ncol = 3)  # All r(k) values for 3 different n values
for (j in 1:3) {
    n <- n_range[j]
    r_n <- matrix(nrow = 100, ncol = 3)  # Matrix of r(k) values with a particular n
    for (i in 1:3) {
        seedno = seed_range[i]
        folder <- paste(generator, "_seed", seedno, "/", sep = "")
        file <- paste("dist_", distno, "_n_", n, sep = "")
        filename <- paste(path, folder, file, ".csv", sep = "")
        r_n[,i] <- read.csv(file = filename, header = F)[,1]
    }
    r_mat[,j] <- rowMeans(r_n)
}


dist_fcn <- "Euclidean Distance"
if (distno == 1) {
    dist_fcn <- "Cityblock Distance"
} else if (distno == 2) {
    dist_fcn <- "Minkowski Distance (p = 3)"
} else if (distno == 3) {
    dist_fcn <- "Distance Function in Problem 4"
} else if (distno == 4) {
    dist_fcn <- "Cosine Distance"
}

filename <- paste(path, generator, "_dist_", distno, ".pdf", sep = "")
pdf(file = filename, width = 8, height = 6)

plot_title <- paste("r(k) Values with ", dist_fcn, sep = "")
plot(r_mat[,1],
     main = plot_title,
     xlab = "k",
     ylab = "r(k)",
     type = "l", col = "darkgreen", lwd = 2)
points(r_mat[,2],
       type = "l", col = "orange", lwd = 2)
points(r_mat[,3],
       type = "l", col = "steelblue2", lwd = 2)
legend(75, 4.5,
    lty = 1, lwd = 3,
    col = c("darkgreen", "orange", "steelblue2"),
    c("n = 100", "n = 1000", "n = 10000"))

dev.off()







