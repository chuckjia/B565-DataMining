obs <- read.csv("result.csv", header = F)[,1]

hist(obs, 
     ylim = c(0, 2500),
     breaks = 5000)

library(MASS)
num_dim = 3
num_dp = 10000
obs <- mvrnorm(num_dp, mu = rep(0, num_dim), Sigma = diag(num_dim))
dist_matrix <- as.matrix(dist(obs))
