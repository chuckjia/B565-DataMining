clear; clc;

% Read dataset and preprocess
dset = csvread('glass.csv');
[nrow, ncol] = size(dset);
true_labels = dset(:, ncol);
ncol = ncol - 1; dset = dset(:, 1:ncol);

% Distance function to be used
dist_fcn = @euclidean_dist_squared;

nclust = 10;  % Number of clusters

% Randomly choose nclust data points as centorids for initialization
centroids = ones(nclust, ncol);
labels = ones(nrow, 1);
upper_bd = zeros(nrow, 1); upper_bd(:) = realmax;
lower_bd = zeros(nrow, nclust);



itr_no = 0; prev_centroids = centroids + 1;

while (nnz(centroids - prev_centroids))
    % fprintf("Iteration No. %d\n", itr_no); itr_no = itr_no + 1;
    
    between_centr_dist = rep(realmax, nclust, nclust);  % Result of line 5 in algorithm
    for i = 1:(nclust - 1)
        for j = (i + 1) : nclust
            distance = dist_fcn(centroids(i, :), centroids(j, :));
            between_centr_dist(i, j) = distance;
            between_centr_dist(j, i) = distance;
        end
    end
    
    s_dist = min(between_centr_dist) * 0.5;  % s(i) function in algorithm
    
    
    
    
    
    
    for i = 1:nrow
        if upper_bd(i) <= s_dist(labels(i))  continue;  end
        
        recalc = true;
        for j = 1:nclust
            curr_label = labels(i);
            if j == curr_label continue; end
            z = max(lower_bd(i, j), between_centr_dist(curr_label, j));  % Algorithm line 11: z
            if upper_bd(i) <= z continue; end
            
            if recalc 
                new_upper_bd = dist_fcn(dset(i,:), centroids(curr_label,:));
                upper_bd(i) = new_upper_bd;
                recalc = false;
                if new_upper_bd <= z continue; end
            end
            
            new_lower_bd = dist_fcn(dset(i,:), centroids(j,:));
            lower_bd(i, j) = new_lower_bd;
            if new_lower_bd < upper_bd(i)
                labels(i) = j;
            end
        end
    end
    
    
    % Update centroids
    prev_centroids = centroids;
    
    for j = 1:nclust
        clust_pts = (labels == j);
        if sum(clust_pts) > 0
            centroids(j, :) = mean(dset(clust_pts,:));
        else
            empty_clusts = [empty_clusts, j];
        end
    end
    
    if ~isempty(empty_clusts)
        centroids(empty_clusts, :) = [];
        prev_centroids(empty_clusts, :) = [];
        lower_bd(:, empty_clusts)
        nclust = nclust - length(empty_clusts);
    end
    
    delta = repmat(0, nclust, 1);
    for j = 1:nclust
        delta = 
    end
    
    for i = 1:nrow
        upper_bd(i)
    end
    
    
end





















