clear; clc;

% rng(200)

% Read dataset and preprocess
dset = csvread('glass.csv');
[nrow, ncol] = size(dset);
true_labels = dset(:, ncol);
ncol = ncol - 1; dset = dset(:, 1:ncol);

tic
% kmeans
nclust = 7;
% labels = kmeans_elkan(dset, nclust, @euclidean_dist);
labels = kmeans(dset, nclust, @euclidean_dist);
toc

num_err = 0;
for k = 1:nclust
    clust_pts = (labels == k);
    clust_true_labels = true_labels(clust_pts);
    pred_label = mode(clust_true_labels);
    num_err = num_err + sum(clust_true_labels ~= pred_label);
end

fprintf("Total error rate = %1.4f%%\n", num_err / nrow * 100);
% fprintf("Objective function = %f\n", obj_fcn_val);













