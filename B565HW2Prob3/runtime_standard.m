
dset = csvread("birch1.csv");
[nrow, ncol] = size(dset);

nclust = 3;
dist_fcn = @euclidean_dist;

[nrow, ~] = size(dset);

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Initialization
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

centroids = dset(1:nclust,:);
centroids(1,:) = mean(dset);
labels = ones(nrow, 1);

for j = 2:nclust
    max = 0;
    max_i = 1;
    for i = 1:nrow
        data_pt = dset(i,:);
        curr = min(dist_fcn(repmat(data_pt, j - 1, 1), centroids(1:j-1,:)));
        if (curr > max)
            max = curr;
            max_i = i;
        end
    end
    centroids(j,:) = dset(max_i, :);
end

tic

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% k-means 
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

itr_no = 0; prev_centroids = centroids + 1;
while (nnz(centroids - prev_centroids))
    if (itr_no > 10000) break; fprintf("Did not converge\n"); end
    itr_no = itr_no + 1;
    fprintf("Iteration No. %d\n", itr_no); 
    
    % Update membership
    for i = 1:nrow
        distances = dist_fcn(repmat(dset(i,:), nclust, 1), centroids);
        [~, labels(i)] = min(distances);
    end
    
    % Update centroids
    prev_centroids = centroids;
    
    empty_clusts = [];  % Used to track empty clusters
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
        prev_centroids = centroids + 1;
        % prev_centroids(empty_clusts, :) = [];
        nclust = nclust - length(empty_clusts);
        
        uniq_labels = unique(labels);
        for i = 1:length(uniq_labels)
            labels(labels == uniq_labels(i)) = i;
        end
    end
end

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Calculate total error
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

tot_err = 0;
for i = 1:nrow
    tot_err = tot_err + dist_fcn(dset(i,:), centroids(labels(i),:)) .^ 2;
end

toc



