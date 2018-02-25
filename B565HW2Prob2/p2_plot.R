setwd("/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW2Prob2"); rm(list = ls()); cat("\014")

num_dim = 3000
save_pdf = T
plot_type = "l"  # Line: "l"; point: "p"

filename_prefix = paste("uniform_results/k_", num_dim, "_dist_", sep = "")
x_min <- 0; x_max <- 7; 
y_min <- -10; y_max <- 0;
use_log <- T
if (plot_type == "p") {
    legend_loc_x = 0 * x_max; legend_loc_y = 0.6 * y_min;
} else {
    legend_loc_x = 0 * x_max; legend_loc_y = 0.6 * y_min;
}

if (use_log) {
    x_label <- "log(Times in K Nearest Neighbor)"
    y_label <- "log(Value Frequency)"
} else {
    x_label <- "Times in K Nearest Neighbor"
    y_label <- "Value Frequency"
}

# ===== ===== ===== ===== ===== ===== 
# Plotting 
# ===== ===== ===== ===== ===== ===== 

filename <- paste("p2_k_", num_dim, "_", plot_type, ".pdf", sep = "")
if (save_pdf) pdf(filename, width = 7, height = 5)

color_set <- c("darkgreen", "darkorange", "red", "blue")
pch_set <- c(1, 2, 3, 4)
plot_title <- paste("Results with k = ", num_dim, sep = "")
plot(1, type = "n", main = plot_title, xlab = x_label, ylab = y_label, 
     xlim = c(x_min, x_max), ylim = c(y_min, y_max))
line_width <- ifelse(plot_type == "l", 1.5, 2)
for (dist_no in 1:4) {
    filename <- paste(filename_prefix, dist_no, ".csv", sep = "")
    obs <- read.csv(filename, header = F)[,1]
    obs_vals <- sort(unique(obs)); 
    obs_freq <- table(obs) / length(obs)
    if (use_log) {
        obs_vals <- log(obs_vals + 1) 
        obs_freq <- log(obs_freq)
    }
    points(cbind(obs_vals, obs_freq), type = plot_type, pch = pch_set[dist_no], lwd = line_width, col = color_set[dist_no])
}

dist_names <- c("Euclidean", "Consine", "Distance Eq. 1", "Distance Eq. 2")
if (plot_type == "p") {
    legend(legend_loc_x, legend_loc_y, dist_names, pch = pch_set, pt.lwd = 3, col = color_set)
} else
    legend(legend_loc_x, legend_loc_y, dist_names, lwd = 2, col = color_set)

if (save_pdf) dev.off()


# hist(obs, ylim = c(0, 3000), breaks = 5000)




