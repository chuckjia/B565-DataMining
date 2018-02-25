setwd("/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/B565HW2Prob2"); rm(list = ls()); cat("\014")

num_dim = 300
save_pdf = F
plot_type = "p"  # Line: "l"; point: "p"

filename_prefix = paste("normal_results/k_", num_dim, "_dist_", sep = "")
x_min <- 1; x_max <- 3; 
y_min <- 0; y_max <- 0.45;
use_log <- F
if (plot_type == "p") {
    legend_loc_x = 2.6; legend_loc_y = 0.45;
} else {
    legend_loc_x = 0.9 * x_max; legend_loc_y = 0.9 * y_min;
}

x_label <- "Times in K Nearest Neighbor"
y_label <- "Value Frequency"

thr_hub <- 15
thr_outlier <- 2

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
    hubs <- obs >= thr_hub
    outliers <- obs <= thr_outlier
    obs[hubs] = 1
    obs[outliers] = 3
    obs[!hubs & !outliers] = 2
    obs_vals <- sort(unique(obs)); 
    obs_freq <- table(obs) / length(obs)
    points(cbind(obs_vals, obs_freq), type = plot_type, pch = pch_set[dist_no], lwd = line_width, col = color_set[dist_no])
}

dist_names <- c("Euclidean", "Consine", "Distance Eq. 1", "Distance Eq. 2")
if (plot_type == "p") {
    legend(legend_loc_x, legend_loc_y, dist_names, pch = pch_set, pt.lwd = 3, col = color_set)
} else
    legend(legend_loc_x, legend_loc_y, dist_names, lwd = 2, col = color_set)

if (save_pdf) dev.off()


# hist(obs, ylim = c(0, 3000), breaks = 5000)




