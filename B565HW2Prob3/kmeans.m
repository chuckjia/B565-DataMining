clear; clc; tic

% Read dataset and preprocess
dset = csvread('glass.csv');
[nrow, ncol] = size(dset);
true_labels = dset(:, ncol);
ncol = ncol - 1; dset = dset(:, 1:ncol);

% Distance function to be used
dist_fcn = @euclidean_dist;

nclust = 10;  % Number of clusters

% Randomly choose nclust data points as centorids for initialization
centroids = dset(randsample(nrow, nclust),:);
labels = zeros(nrow, 1);

% Random labeling
% labels = randi([1, nclust], nrow, 1);
% centroids = zeros(nclust, ncol);

itr_no = 0; prev_centroids = centroids + 1;

while (nnz(centroids - prev_centroids))
    % fprintf("Iteration No. %d\n", itr_no); itr_no = itr_no + 1;
    
    % Update membership
    for i = 1:nrow
        data_pt = dset(i,:);
        min_dist = dist_fcn(data_pt, centroids(1,:));
        min_centroid = 1;
        for k = 2:nclust
            distance = dist_fcn(data_pt, centroids(k,:));
            if distance < min_dist
                min_dist = distance;
                min_centroid = k;
            end
        end
        labels(i) = min_centroid;
    end
    
    % Update centroids
    prev_centroids = centroids;
    
    empty_clusts = [];
    for k = 1:nclust
        clust_pts = (labels == k);
        if sum(clust_pts) > 0
            centroids(k, :) = mean(dset(clust_pts,:));
        else
            empty_clusts = [empty_clusts, k];
        end
    end
    
    if ~isempty(empty_clusts)
        centroids(empty_clusts, :) = [];
        nclust = nclust - length(empty_clusts);
        prev_centroids = centroids + 1;
    end
end

obj_fcn_val = 0;
for i = 1:nrow
    obj_fcn_val = obj_fcn_val + dist_fcn(dset(i,:), centroids(labels(i),:));
end

num_err = 0;
for k = 1:nclust
    clust_pts = (labels == k);
    clust_true_labels = true_labels(clust_pts);
    pred_label = mode(clust_true_labels);
    num_err = num_err + sum(clust_true_labels ~= pred_label);
end

fprintf("Total error rate = %1.4f%%\n", num_err / nrow * 100);
fprintf("Objective function = %f\n", obj_fcn_val);

toc









